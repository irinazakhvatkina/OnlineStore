//
//  PopupButton.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 17.10.25.
//

import UIKit

class PopupActionButton: UIButton {
    
    // MARK: - Enums
    enum ButtonStyle {
        case normal
        case destructive
        case withIcon(String)
    }
    
    // MARK: - Initialization
    init(title: String, style: ButtonStyle = .normal) {
        super.init(frame: .zero)
        setupButton(title: title, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupButton(title: String, style: ButtonStyle) {
        backgroundColor = .screenBackgroundLightGrey
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // Common setup
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentHorizontalAlignment = .left
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        // Apply style
        switch style {
        case .normal:
            setTitleColor(.black, for: .normal)
            setAttributedTitle(createAttributedTitle(title: title), for: .normal)
            
        case .destructive:
            setTitleColor(.red, for: .normal)
            setTitle(title, for: .normal)
            
        case .withIcon(let iconName):
            setTitleColor(.black, for: .normal)
            setAttributedTitle(createAttributedTitleWithIcon(title: title, iconName: iconName), for: .normal)
        }
        
        // Size constraints
        snp.makeConstraints { make in
            make.width.equalTo(296)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Private Methods
    private func createAttributedTitle(title: String) -> NSAttributedString {
        return NSAttributedString(string: title)
    }
    
    private func createAttributedTitleWithIcon(title: String, iconName: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        if let iconImage = UIImage(named: iconName) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = iconImage
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: "   \(title)"))
        } else {
            attributedString.append(NSAttributedString(string: title))
        }
        
        return attributedString
    }
    
    // MARK: - Public Methods
    func setSelected(_ selected: Bool) {
        backgroundColor = selected ? UIColor.blue.withAlphaComponent(0.1) : .screenBackgroundLightGrey
    }
}
