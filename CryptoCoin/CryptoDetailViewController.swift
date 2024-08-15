
import UIKit
import SnapKit

class CryptoDetailViewController: UIViewController {
    private let crypto: CryptoModel
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    
    init(crypto: CryptoModel) {
        self.crypto = crypto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        configureView()
    }
    
    private func setupNavigationBar() {
            title = crypto.name
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
        
        @objc private func backButtonTapped() {
            navigationController?.popViewController(animated: true)
        }
    
    private func setupViews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        changeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(changeLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureView() {
        nameLabel.text = crypto.name
        priceLabel.text = String(format: "Current Price: $%.2f", crypto.priceUsd)
        changeLabel.text = String(format: "24 Hours Change: %.2f%%", crypto.percentChangeUsdLast24Hours)
        changeLabel.textColor = crypto.percentChangeUsdLast24Hours >= 0 ? ColorPalette.darkGreen : ColorPalette.darkRed
    }
}
