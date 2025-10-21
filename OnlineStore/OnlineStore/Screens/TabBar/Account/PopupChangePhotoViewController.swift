//
//  PopupChangePhotoViewController.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 17.10.25.
//
import UIKit
import PhotosUI

protocol ChangePhotoPopupDelegate: AnyObject {
    func didSelectTakePhoto()
    func didSelectChooseFromFile()
    func didSelectDeletePhoto()
    func didSelectImage(_ image: UIImage)
}

class ChangePhotoPopupViewController: UIViewController {
    
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
        label.text = "Change your picture"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let takePhotoButton = PopupActionButton(
        title: "Take a photo",
        style: .normal
    )
    
    private let chooseFromFileButton = PopupActionButton(
        title: "Choose from your file",
        style: .normal
    )
    
    private let deletePhotoButton = PopupActionButton(
        title: "Delete photo",
        style: .destructive
    )
    
    // MARK: - Properties
    weak var delegate: ChangePhotoPopupDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Add subviews
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(takePhotoButton)
        buttonsStackView.addArrangedSubview(chooseFromFileButton)
        buttonsStackView.addArrangedSubview(deletePhotoButton)
    }
    
    private func setupConstraints() {
        // Container view - 328x340
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(328)
            make.height.equalTo(340)
        }
        
        // Title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Buttons stack view
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        chooseFromFileButton.addTarget(self, action: #selector(chooseFromFileTapped), for: .touchUpInside)
        deletePhotoButton.addTarget(self, action: #selector(deletePhotoTapped), for: .touchUpInside)
        
        // Tap outside to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func takePhotoTapped() {
        delegate?.didSelectTakePhoto()
        dismiss(animated: true)
    }
    
    @objc private func chooseFromFileTapped() {
        delegate?.didSelectChooseFromFile()
        dismiss(animated: true) { [weak self] in
            self?.presentImagePicker()
        }
    }
    
    @objc private func deletePhotoTapped() {
        delegate?.didSelectDeletePhoto()
        dismiss(animated: true)
    }
    
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Image Picker
    private func presentImagePicker() {
        if #available(iOS 14.0, *) {
            // Используем PHPickerViewController для iOS 14+
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            // Используем UIImagePickerController для iOS 13 и ниже
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
        }
    }
    
    // MARK: - Camera
    private func presentCamera() {
        // Проверяем доступность камеры
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showErrorAlert(message: "Camera is not available on this device")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate (iOS 14+)
@available(iOS 14.0, *)
extension ChangePhotoPopupViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.delegate?.didSelectImage(image)
                }
            } else if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                // Можно показать alert с ошибкой
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: "Failed to load image")
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate (iOS 13 and below)
extension ChangePhotoPopupViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            delegate?.didSelectImage(image)
        } else {
            showErrorAlert(message: "Failed to load image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ChangePhotoPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}

// MARK: - Alert Helper
extension ChangePhotoPopupViewController {
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Находим верхний представленный контроллер для показа alert
        if let topController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            topController.present(alert, animated: true)
        }
    }
}
