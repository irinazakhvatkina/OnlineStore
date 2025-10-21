//
//  RegistrationViewController.swift
//  BestRecipe
//
//  Created by Zarina Sadykova on 31.08.25.
//
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoSquareView = SquareView.createWithLogo()
    private let loginTextField = TextInputView()
    private let passwordTextField = TextInputView()
    private let signinButton = CustomButton(title: "Sign In", cornerRadius: 10)
    private let signInQuestionLabel = UILabel()
    private let signUpButton = UIButton()
    
    private func autofillMockLogin() {
        loginTextField.text = MockUser.email
        passwordTextField.text = MockUser.password
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        autofillMockLogin()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Настройка логотипа
        logoSquareView.setBackgroundColor(.clear)
        logoSquareView.setCornerRadius(0)
        view.addSubview(logoSquareView)
        
        // Настройка поля логина
        loginTextField.title = "Enter your Login"
        loginTextField.placeholder = "Login"
        loginTextField.setKeyboardType(.emailAddress)
        loginTextField.hasOutline = true
        loginTextField.outlineColor = .systemGray5
        loginTextField.backgroundColorType = .screenBackgroundLightGrey
        view.addSubview(loginTextField)
        
        // Настройка поля пароля
        passwordTextField.title = "Enter your Password"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.hasOutline = true
        passwordTextField.outlineColor = .systemGray5
        passwordTextField.backgroundColorType = .screenBackgroundLightGrey
        view.addSubview(passwordTextField)
        
        // Настройка кнопки Sign In - ДОБАВЬТЕ ЭТО
        signinButton.backgroundColor = .primaryBlue
        signinButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(signinButton)
        
        
        // Настройка текста "Don't have an account yet?"
        signInQuestionLabel.text = "Don't have an account yet?"
        signInQuestionLabel.textColor = .secondaryTitlesGrey
        signInQuestionLabel.font = UIFont(name: FontNames.semiBold_18pt, size: 14)
        signInQuestionLabel.textAlignment = .center
        view.addSubview(signInQuestionLabel)
        
        // Настройка кнопки "Sign Up"
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.primaryBlue, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: FontNames.semiBold_18pt, size: 12)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        // Логотип
        logoSquareView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        // Поле логина
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoSquareView.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(45)
        }
        
        // Поле пароля
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(45)
        }
        
        // Кнопка Sign in
        signinButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(180)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(56)
        }

        
        // Текст "Don't have an account yet?"
        signInQuestionLabel.snp.makeConstraints { make in
            make.top.equalTo(signinButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        // Кнопка "Sign Up"
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInQuestionLabel.snp.bottom).offset(-2)
            make.centerX.equalToSuperview()
        }
    }
                                         
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }
        
        if login == MockUser.email && password == MockUser.password {
            // Успешный логин - переходим на таббар
            let tabBarController = CustomTabBarController()
            
            // Анимированный переход на таббар
            if let window = self.view.window {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = tabBarController
                }, completion: nil)
            }
        } else if login != MockUser.email {
            showAlert(message: "❌ Invalid email")
        } else {
            showAlert(message: "❌ Invalid password")
        }
    }
    
    @objc private func signUpTapped() {
        let registrationVC = RegistrationViewController()
        registrationVC.modalPresentationStyle = .fullScreen
        present(registrationVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
