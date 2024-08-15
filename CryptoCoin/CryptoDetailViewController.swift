
import UIKit
import SnapKit

class CryptoDetailViewController: UIViewController {
    
    private var crypto: CryptoModel
    
    // MARK: - UI Elements
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializer
    
    init(crypto: CryptoModel) {
        self.crypto = crypto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureUI()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(changeLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func configureUI() {
        nameLabel.text = crypto.name
        priceLabel.text = String(format: "$%.2f", crypto.priceUsd)
        changeLabel.text = String(format: "%.2f%%", crypto.percentChangeUsdLast24Hours)
        changeLabel.textColor = crypto.percentChangeUsdLast24Hours >= 0 ? ColorPalette.darkGreen : ColorPalette.darkRed
    }
}
