
import UIKit
import SnapKit

class CryptoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(CryptoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let cellIdentifier = "CryptoCell"
    private var cryptoData = [CryptoModel]()
    private var sortedCryptoData = [CryptoModel]()
    private var spinner = UIActivityIndicatorView(style: .large)

    deinit {
        print("deinit CryptoCollectionViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
        setupSpinner()
        fetchCryptos()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemBlue
 
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.leftBarButtonItem = sortButton
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        spinner.startAnimating()
    }
    
    private func fetchCryptos() {
        NetworkManager.shared.fetchCrytos { [weak self] cryptos, error in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                if let error = error {
                    self?.showError(error.localizedDescription)
                    return
                }
                self?.cryptoData = cryptos ?? []
                self?.sortedCryptoData = self?.cryptoData ?? []
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        let authVC = AuthViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.rootViewController = UINavigationController(rootViewController: authVC)
    }
    
    @objc private func sortButtonTapped() {
        let sortOptions = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        sortOptions.addAction(UIAlertAction(title: "Price Change Descending", style: .default, handler: { _ in
            self.sortedCryptoData = self.cryptoData.sorted { $0.percentChangeUsdLast24Hours > $1.percentChangeUsdLast24Hours }
            self.collectionView.reloadData()
        }))
        sortOptions.addAction(UIAlertAction(title: "Price Change Ascending", style: .default, handler: { _ in
            self.sortedCryptoData = self.cryptoData.sorted { $0.percentChangeUsdLast24Hours < $1.percentChangeUsdLast24Hours }
            self.collectionView.reloadData()
        }))
        sortOptions.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sortOptions, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedCryptoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CryptoCell
        cell.configure(with: sortedCryptoData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let crypto = sortedCryptoData[indexPath.item]
        let detailVC = CryptoDetailViewController(crypto: crypto)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (collectionViewSize / numberOfItemsPerRow) - padding
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: CryptoCell

class CryptoCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.layer.cornerRadius = 8.0
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 2.0
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(8)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with crypto: CryptoModel) {
        titleLabel.text = crypto.name
        priceLabel.text = String(format: "$%.2f", crypto.priceUsd)
        changeLabel.text = String(format: "%.2f%%", crypto.percentChangeUsdLast24Hours)
        changeLabel.textColor = crypto.percentChangeUsdLast24Hours >= 0 ? ColorPalette.darkGreen : ColorPalette.darkRed
    }
}

struct ColorPalette {
    static let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    static let darkRed = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
}
