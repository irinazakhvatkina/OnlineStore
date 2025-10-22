//
//  CategoryButton.swift
//  homework
//
//  Created by Zarina Sadykova on 19.08.25.
//
import UIKit

class CustomButton: UIButton {

    // MARK: - Public Properties
    var customCornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Initialization
    convenience init(title: String, cornerRadius: CGFloat = 0) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        self.customCornerRadius = cornerRadius
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Configuration
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: FontNames.semiBold_18pt, size: 20)
        titleLabel?.adjustsFontSizeToFitWidth = false
        titleLabel?.minimumScaleFactor = 1.0
        titleLabel?.lineBreakMode = .byClipping
        backgroundColor = .buttonLightBlue
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Всегда устанавливаем радиус равным половине высоты для максимально круглых краев
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Public Methods
    func setCornerRadius(_ radius: CGFloat) {
        customCornerRadius = radius
        setNeedsLayout()
    }
}
