//
//  ProfileButton.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 07.10.25.
//
import UIKit
import DesignPackage

// MARK: - Custom Button View
class ProfileButtonView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBlue
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.regular_18pt, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let customIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    private let tapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    var tapAction: (() -> Void)?
    
    // MARK: - Init
    init(title: String, showArrow: Bool = true, customIconName: String? = nil) {
        super.init(frame: .zero)
        setupView(title: title, showArrow: showArrow, customIconName: customIconName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView(title: String, showArrow: Bool, customIconName: String?) {
        backgroundColor = .clear
        
        titleLabel.text = title
        
        if let customIconName = customIconName {
            // Используем кастомную иконку из ассетов
            customIconImageView.image = UIImage(named: customIconName)
            customIconImageView.isHidden = false
            arrowImageView.isHidden = true
        } else {
            // Используем шеврон или скрываем
            arrowImageView.isHidden = !showArrow
            customIconImageView.isHidden = true
        }
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)
        containerView.addSubview(customIconImageView)
        containerView.addSubview(tapButton)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50) // Высота кнопки 50
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(arrowImageView.snp.leading).offset(-8)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        customIconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Устанавливаем приоритеты для правильного расположения
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        arrowImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        arrowImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        customIconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        customIconImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupActions() {
        tapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapAction?()
    }
}
