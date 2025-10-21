//
//  PopupChangePhotoViewController.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 17.10.25.
//
import UIKit
import PhotosUI

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
    private let photoPickerManager = PhotoPickerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
        // Настраиваем менеджер пикера
        photoPickerManager.delegate = self
        print("✅ ChangePhotoPopupViewController: PhotoPickerManager delegate set")
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
        print("🟡 Choose from file tapped")
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            if let topController = self.getTopViewController() {
                print("🟡 Presenting photo picker")

                // 💡 Убедимся, что делегат установлен
                if self.photoPickerManager.delegate == nil {
                    print("⚠️ Delegate was nil – assigning now")
                    self.photoPickerManager.delegate = self
                }

                print("✅ Delegate assigned: \(self.photoPickerManager.delegate != nil)")
                self.photoPickerManager.presentPhotoPicker(from: topController)
            }
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
    
    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}

// MARK: - ChangePhotoPopupDelegate
extension ChangePhotoPopupViewController: ChangePhotoPopupDelegate {
    func didSelectImage(_ image: UIImage) {
        print("🎯 ChangePhotoPopupViewController: Received image - \(image.size)")
        
        // НЕМЕДЛЕННО передаем фото в AccountViewController
        DispatchQueue.main.async {
            print("🟡 Forwarding image to AccountViewController")
            self.delegate?.didSelectImage(image)
        }
    }
    
    func didSelectTakePhoto() {
        delegate?.didSelectTakePhoto()
    }
    
    func didSelectChooseFromFile() {
        delegate?.didSelectChooseFromFile()
    }
    
    func didSelectDeletePhoto() {
        delegate?.didSelectDeletePhoto()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ChangePhotoPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}
