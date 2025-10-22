//
//  RegistrationViewController.swift
//  BestRecipe
//
//  Created by Zarina Sadykova on 31.08.25.
//
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let accountTypeButton = AccountTypeButton()
    private var textFields: [TextInputView] = []
    
    private let signUpButton = CustomButton(title: "Sign Up", cornerRadius: 10)
    private let alreadyHaveAccountLabel = UILabel()
    
    // MARK: - Properties
    private var selectedAccountType: AccountType = .client
    
    // Конфигурация полей (убрал Last Name)
    private let fieldConfigs: [RegistrationFieldConfig] = [
        RegistrationFieldConfig(title: "First Name",
                                placeholder: "Enter your first name",
                                isSecure: false,
                                keyboardType: .default),
        RegistrationFieldConfig(title: "E-mail",
                                placeholder: "Enter your email",
                                isSecure: false,
                                keyboardType: .emailAddress),
        RegistrationFieldConfig(title: "Password",
                                placeholder: "Create password",
                                isSecure: true,
                                keyboardType: .default),
        RegistrationFieldConfig(title: "Confirm Password",
                                placeholder: "Confirm your password",
                                isSecure: true,
                                keyboardType: .default)
    ]
    
    // Autofill полей для теста
    private func autofillMockUser() {
        guard textFields.count == fieldConfigs.count else { return }
        textFields[0].text = MockUser.firstName
        textFields[1].text = MockUser.email
        textFields[2].text = MockUser.password
        textFields[3].text = MockUser.password // confirm
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupLoginTapGesture()
        setupAccountTypeButtonAction()
        autofillMockUser()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Заголовок
        titleLabel.text = "Sign Up"
        titleLabel.textColor = .mainTitlesDark
        titleLabel.font = UIFont(name: FontNames.semiBold_18pt, size: 38)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        // Подзаголовок
        subtitleLabel.text = "Complete your account"
        subtitleLabel.textColor = .mainTitlesDark
        subtitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        subtitleLabel.textAlignment = .left
        view.addSubview(subtitleLabel)
        
        // Кнопка выбора типа аккаунта
        accountTypeButton.configure(title: "Type of account")
        view.addSubview(accountTypeButton)
        
        // Поля по конфигу
        for config in fieldConfigs {
            let textField = TextInputView()
            textField.title = config.title
            textField.placeholder = config.placeholder
            textField.cornerRadius = 20
            textField.isSecureTextEntry = config.isSecure
            textField.setKeyboardType(config.keyboardType)
            textField.hasOutline = true
            textField.outlineColor = .systemGray4
            textField.backgroundColorType = .systemGray6
            view.addSubview(textField)
            textFields.append(textField)
        }
        
        // Кнопка регистрации
        signUpButton.backgroundColor = .buttonLightBlue
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        setupAlreadyHaveAccountText()
    }
    
    private func setupAccountTypeButtonAction() {
        accountTypeButton.addTarget(self, action: #selector(accountTypeButtonTapped), for: .touchUpInside)
    }
    
    private func setupAlreadyHaveAccountText() {
        let fullText = "Already have an account? Login"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let loginRange = fullText.range(of: "Login") {
            let nsRange = NSRange(loginRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.primaryBlue, range: nsRange)
            if let font = UIFont(name: FontNames.regular_18pt, size: 32) {
                attributedString.addAttribute(.font, value: font, range: nsRange)
            } else {
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .medium), range: nsRange)
            }
        }

        alreadyHaveAccountLabel.attributedText = attributedString
        alreadyHaveAccountLabel.textAlignment = .center
        alreadyHaveAccountLabel.isUserInteractionEnabled = true
        view.addSubview(alreadyHaveAccountLabel)
    }
    
    private func setupLoginTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        alreadyHaveAccountLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        // Поля - УВЕЛИЧЕННЫЕ ОТСТУПЫ
        var previous: UIView = subtitleLabel
        for (index, textField) in textFields.enumerated() {
            textField.snp.makeConstraints { make in
                make.top.equalTo(previous.snp.bottom).offset(index == 0 ? 50 : 50)
                make.centerX.equalToSuperview()
                make.width.equalTo(335)
                make.height.equalTo(45)
            }
            previous = textField
        }
        
        // Кнопка выбора типа аккаунта
        accountTypeButton.snp.makeConstraints { make in
            make.top.equalTo(previous.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(45)
        }
        
        // Кнопка регистрации
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(accountTypeButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(56)
        }
        
        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func accountTypeButtonTapped() {
        let popupVC = AccountTypePopupViewController()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        let values = textFields.map { $0.text ?? "" }
        let titles = fieldConfigs.map { $0.title }

        if let error = RegistrationValidator.validate(fields: values, fieldTitles: titles) {
            showAlert(message: error.localizedDescription)
            return
        }
        
        // Сохраняем выбранный тип аккаунта
        saveSelectedAccountType()
        
        // Показываем успешное сообщение и переходим на логин
        showSuccessAlertAndGoToLogin()
    }
    
    private func saveSelectedAccountType() {
        UserDefaults.standard.set(selectedAccountType.rawValue, forKey: "accountType")
        print("💾 Saved account type during registration: \(selectedAccountType.rawValue)")
    }
    
    private func showSuccessAlertAndGoToLogin() {
        let alert = UIAlertController(
            title: "Success!",
            message: "Account created successfully!\nPlease log in with your credentials.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc private func loginTapped() {
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AccountTypePopupDelegate
extension RegistrationViewController: AccountTypePopupDelegate {
    func didSelectAccountType(_ type: AccountType) {
        // Сохраняем выбранный тип
        selectedAccountType = type
        
        // Обновляем кнопку с выбранным типом аккаунта
        accountTypeButton.configure(title: "Type of account", accountType: type)
    }
}
