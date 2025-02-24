import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    
    private let viewModel = AuthViewModel()

    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CryptoCoin"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.setPadding(left: 12)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.setPadding(left: 12)
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please enter both login and password")
            return
        }
        
        viewModel.login = login
        viewModel.password = password
        
        if viewModel.validateCredentials() {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let homeVC = CryptoCollectionViewController()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }
            window.rootViewController = UINavigationController(rootViewController: homeVC)
        } else {
            showError("Invalid login or password")
        }
    }
    
    // MARK: - Helpers
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        loginTextField.layer.borderColor = UIColor.red.cgColor
        loginTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1.0
    }
}

// MARK: - UITextField Extension

private extension UITextField {
    func setPadding(left: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
