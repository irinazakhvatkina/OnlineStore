//
//  PopupChangePhotoViewController.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 17.10.25.
//
import UIKit

protocol ChangePhotoPopupDelegate: AnyObject {
    func didSelectTakePhoto()
    func didSelectChooseFromFile()
    func didSelectDeletePhoto()
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
        
        // Кнопки используют стандартные размеры из PopupActionButton (296x60)
        // 3 кнопки × 60pt = 180pt
        // spacing между кнопками 16pt × 2 = 32pt
        // Итого: 180pt + 32pt = 212pt для кнопок
        // Остальное пространство распределено как отступы
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
        dismiss(animated: true)
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
}

// MARK: - UIGestureRecognizerDelegate
extension ChangePhotoPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}
