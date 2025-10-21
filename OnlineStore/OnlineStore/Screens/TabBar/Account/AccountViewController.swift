//
//  AccountViewController.swift
//  OnlineStore
//
//  Created by Administration  on 29/09/25.
//

// AccountViewController.swift
import UIKit
import PhotosUI
import AVFoundation
import DesignPackage

class AccountViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: FontNames.semiBold_18pt, size: 15)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        return label
    }()
    
    // УБРАЛ ДУБЛИРОВАНИЕ - оставил только один profileAvatarView
    private let profileAvatarView: ProfileAvatarView = {
        let view = ProfileAvatarView()
        return view
    }()
    
    private let developerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "iCodePro Developer"
        label.font = UIFont(name: FontNames.regular_18pt, size: 16)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "icode@gmail.com"
        label.font = UIFont(name: FontNames.regular_18pt, size: 14)
        label.textColor = .secondaryTitlesGrey
        label.textAlignment = .center

        let attributedString = NSMutableAttributedString(string: "icode@gmail.com")
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        label.attributedText = attributedString
        
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let accountTypeButton = ProfileButtonView(
        title: "Type of account"
    )

    private let termsButton = ProfileButtonView(
        title: "Terms & Conditions"
    )

    private let logoutButton = ProfileButtonView(
        title: "Log out",
        showArrow: false,
        customIconName: "signout"
    )
    
    private var currentAccountType: AccountType = .client {
        didSet {
            updateAccountTypeDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        loadAccountType()
        loadSavedAvatar()
        
        print("🔍 AccountViewController loaded")
        print("🔍 ProfileAvatarView: \(profileAvatarView)")
    }

    private func loadSavedAvatar() {
        if let savedImage = loadImageFromDocuments() {
            profileAvatarView.setAvatarImage(savedImage)
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add profile section
        contentView.addSubview(profileTitleLabel)
        contentView.addSubview(profileAvatarView)
        contentView.addSubview(developerNameLabel)
        contentView.addSubview(emailLabel)
        
        // Add buttons stack view
        contentView.addSubview(buttonsStackView)
        
        // Add buttons to stack view
        buttonsStackView.addArrangedSubview(accountTypeButton)
        buttonsStackView.addArrangedSubview(termsButton)
        buttonsStackView.addArrangedSubview(logoutButton)
    }
    
    private func setupConstraints() {
        // Scroll View
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Content View
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        // Profile Title
        profileTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Profile Avatar View
        profileAvatarView.snp.makeConstraints { make in
            make.top.equalTo(profileTitleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(27)
            make.width.height.equalTo(100)
        }
        
        // Developer Name
        developerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileAvatarView.snp.top).offset(14)
            make.leading.equalTo(profileAvatarView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }

        // Email
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(developerNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileAvatarView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // Buttons Stack View
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(350)
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    private func setupActions() {
        // Profile Avatar View actions
        profileAvatarView.delegate = self
        
        // Button actions
        accountTypeButton.tapAction = { [weak self] in
            self?.showAccountTypeSelection()
        }
        
        termsButton.tapAction = { [weak self] in
            self?.termsTapped()
        }
        
        logoutButton.tapAction = { [weak self] in
            self?.logoutTapped()
        }
    }
    
    // MARK: - Actions
    private func accountTypeTapped() {
        print("Account type tapped")
    }
    
    private func termsTapped() {
        let termsVC = TermsConditionsViewController()
        termsVC.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    private func logoutTapped() {
        print("Logout tapped")
        
        // Показываем подтверждение выхода
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }

    private func performLogout() {
        // Очищаем сохраненные данные (если нужно)
        UserDefaults.standard.removeObject(forKey: "accountType")
        
        // Создаем LoginViewController для возврата на экран логина
        let loginVC = LoginViewController()
        
        // Анимированный переход на экран логина
        if let window = self.view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = loginVC
            }, completion: nil)
        }
    }
    
    // MARK: - Public Methods
    func updateProfileAvatar(_ image: UIImage) {
        print("🎉 Updating profile avatar with new image")
        profileAvatarView.setAvatarImage(image)
        saveImageToDocuments(image)
        
        // Показываем подтверждение
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(
                title: "Success!",
                message: "Profile photo has been updated",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Account Type Management
    private func loadAccountType() {
        let savedType = UserDefaults.standard.string(forKey: "accountType") ?? "client"
        currentAccountType = AccountType(rawValue: savedType) ?? .client
    }
    
    private func saveAccountType(_ type: AccountType) {
        UserDefaults.standard.set(type.rawValue, forKey: "accountType")
        currentAccountType = type
        
        NotificationCenter.default.post(name: NSNotification.Name("AccountTypeDidChange"), object: nil)
        
        showSuccessMessage()
    }
    
    private func updateAccountTypeDisplay() {
        let subtitle = currentAccountType == .client ? "Client" : "Manager"
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(
            title: "Account Type Changed",
            message: "Your account type has been successfully changed to \(currentAccountType == .client ? "Client" : "Manager").",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Account Type Selection
    private func showAccountTypeSelection() {
        let popupVC = AccountTypePopupViewController()
        popupVC.delegate = self
        popupVC.configure(with: currentAccountType)
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true)
    }
    
    // MARK: - Photo Selection
    private func showChangePhotoPopup() {
        let popupVC = ChangePhotoPopupViewController()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true)
    }
    
    // MARK: - Password Popup
    private func showPasswordPopupForManager() {
        let passwordPopup = PasswordPopupViewController()
        passwordPopup.delegate = self
        passwordPopup.modalPresentationStyle = .overFullScreen
        passwordPopup.modalTransitionStyle = .crossDissolve
        present(passwordPopup, animated: true)
    }
}

// MARK: - ProfileAvatarViewDelegate
extension AccountViewController: ProfileAvatarViewDelegate {
    func profileAvatarViewDidTapEdit(_ view: ProfileAvatarView) {
        showChangePhotoPopup()
    }
    
    func profileAvatarViewDidTapAvatar(_ view: ProfileAvatarView) {
        print("Avatar tapped - open full screen view or change photo")
    }
}

// MARK: - AccountTypePopupDelegate
extension AccountViewController: AccountTypePopupDelegate {
    func didSelectAccountType(_ type: AccountType) {
        // Для клиента - просто сохраняем
        saveAccountType(type)
    }
    
    func didSelectManagerWithPassword() {
        // Показываем попап с паролем для менеджера
        showPasswordPopupForManager()
    }
}

// MARK: - PasswordPopupDelegate
extension AccountViewController: PasswordPopupDelegate {
    func didEnterCorrectPassword() {
        // Пароль верный - сохраняем тип менеджера и переходим на вкладку менеджера
        saveAccountType(.manager)
        
        // Автоматически переходим на вкладку менеджера
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.switchToManagerTab()
        }
    }
    
    func didCancelPasswordEntry() {
        // Пользователь отменил ввод пароля - ничего не делаем
        print("Password entry cancelled")
    }
    
    private func switchToManagerTab() {
        // Находим TabBarController и переключаемся на вкладку менеджера
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            // В CustomTabBarController менеджерская вкладка имеет индекс 2
            tabBarController.selectedIndex = 2
            
            // Показываем сообщение о успешном переходе
            showManagerWelcomeMessage()
        } else if let tabBarController = self.tabBarController {
            // Для стандартного TabBarController ищем вкладку менеджера
            if let viewControllers = tabBarController.viewControllers,
               viewControllers.count > 2 {
                tabBarController.selectedIndex = 2
                showManagerWelcomeMessage()
            }
        }
    }
    
    private func showManagerWelcomeMessage() {
        let alert = UIAlertController(
            title: "Welcome Manager!",
            message: "You now have access to manager features and dashboard.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - ChangePhotoPopupDelegate
extension AccountViewController: ChangePhotoPopupDelegate {
    func didSelectImage(_ image: UIImage) {
        print("🎉 AccountViewController: Setting new avatar image - \(image.size)")
        
        // Устанавливаем фото СРАЗУ
        profileAvatarView.setAvatarImage(image)
        
        // Принудительно обновляем интерфейс
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // Сохраняем фото
        saveImageToDocuments(image)
        
        // Показываем визуальное подтверждение
        showPhotoUpdateSuccess()
        
        print("✅ Avatar updated successfully!")
    }
    
    private func showPhotoUpdateSuccess() {
        let alert = UIAlertController(
            title: "Success!",
            message: "Profile photo has been updated",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didSelectTakePhoto() {
        requestCameraAccess()
    }
    
    func didSelectChooseFromFile() {
        // Не нужно ничего делать - фото обрабатывается в didSelectImage
    }
    
    func didSelectDeletePhoto() {
        profileAvatarView.setAvatarImage(nil)
        deleteImageFromDocuments()
    }
    
    private func deleteImageFromDocuments() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("profile_avatar.jpg")
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                print("✅ Image deleted from documents")
            }
        } catch {
            print("❌ Error deleting image: \(error)")
        }
    }
}

// MARK: - Camera Access
extension AccountViewController {
    private func requestCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Доступ уже предоставлен
            presentCamera()
        case .notDetermined:
            // Запрашиваем разрешение
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.presentCamera()
                    } else {
                        self?.showCameraDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            // Доступ запрещен
            showCameraDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true)
    }
    
    private func showCameraDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "Please enable camera access in Settings to take photos",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        present(alert, animated: true)
    }
}

/// MARK: - Image Picker Delegates
extension AccountViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // Обрабатываем снимок с камеры
            profileAvatarView.setAvatarImage(image)
            // Здесь можно сохранить изображение
            saveImageToDocuments(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Image Saving
extension AccountViewController {
    private func saveImageToDocuments(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("profile_avatar.jpg")
        
        do {
            try data.write(to: fileURL)
            print("Image saved successfully: \(fileURL.path)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    private func loadImageFromDocuments() -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("profile_avatar.jpg")
        
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
