//
//  PasswordPopupViewController.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 21.10.25.
//

import UIKit

protocol PasswordPopupDelegate: AnyObject {
    func didEnterCorrectPassword()
    func didCancelPasswordEntry()
}

class PasswordPopupViewController: UIViewController {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Manager Password"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter password to switch to Manager account"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Incorrect password. Please try again."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    weak var delegate: PasswordPopupDelegate?
    private let correctPassword = "000!000"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Add subviews
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(errorLabel)
        containerView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    private func setupConstraints() {
        // Container view
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(328)
            make.height.equalTo(280)
        }
        
        // Title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Message label
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Password text field
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Error label
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Buttons stack view
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.delegate = self
        
        // Tap outside to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        delegate?.didCancelPasswordEntry()
        dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        validatePassword()
    }
    
    @objc private func textFieldDidChange() {
        // Hide error when user starts typing again
        errorLabel.isHidden = true
    }
    
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            delegate?.didCancelPasswordEntry()
            dismiss(animated: true)
        }
    }
    
    // MARK: - Validation
    private func validatePassword() {
        guard let enteredPassword = passwordTextField.text, !enteredPassword.isEmpty else {
            showError("Please enter password")
            return
        }
        
        if enteredPassword == correctPassword {
            // Показываем успешное сообщение перед закрытием
            showSuccessMessage()
            
            // Даем время увидеть сообщение перед закрытием
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate?.didEnterCorrectPassword()
                self.dismiss(animated: true)
            }
        } else {
            showError("Incorrect password. Please try again.")
            passwordTextField.text = ""
            passwordTextField.becomeFirstResponder()
        }
    }

    private func showSuccessMessage() {
        // Можно временно изменить цвет кнопки подтверждения на зеленый
        confirmButton.backgroundColor = .systemGreen
        confirmButton.setTitle("✓ Access Granted", for: .normal)
        
        // Или показать другое визуальное подтверждение
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = .systemGreen
        checkmark.frame = CGRect(x: containerView.bounds.midX - 25, y: containerView.bounds.midY - 25, width: 50, height: 50)
        containerView.addSubview(checkmark)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

// MARK: - UITextFieldDelegate
extension PasswordPopupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validatePassword()
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PasswordPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}
