//
//  ProductDetailsView.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 02/10/25.
//

import UIKit
import DesignPackage
import SnapKit

class ProductDetailsView: UIView {
    
    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 102,
            right: 0
        )

        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "imgslider")
        return iv
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let combineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let importantInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.medium_18pt, size: 16)
        label.text = "Air pods max by Apple"
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.medium_18pt, size: 16)
        label.text = "$1999,99"
        return label
    }()
    
    private let spacerView: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    private let heartButton: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFit
        iv.setImage(UIImage(named: "WishlistInactive"), for: .normal)
        return iv
    }()
    
    private let productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontNames.medium_18pt, size: 16)
        label.text = "Description of product"
        return label
    }()
    
    private let productTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit.
        
    Audio Technology
    Apple-designed dynamic driver
    Active Noise Cancellation
    Transparency mode
    Adaptive EQ
    Spatial audio with dynamic head tracking1
    Sensors
    Optical sensor (each ear cup)
    Position sensor (each ear cup)
    Case-detect sensor (each ear cup)
    Accelerometer (each ear cup)
    Gyroscope (left ear cup)
    Microphones
    Nine microphones total:
    Eight microphones for Active Noise Cancellation
    Three microphones for voice pickup (two shared with Active Noise Cancellation and oneadditional microphone)
    Chip
    Apple H1 headphone chip (each ear cup)
"""
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let buyNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryBlue
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let addToCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9393998981, green: 0.9493477941, blue: 0.944865644, alpha: 1)
        button.setTitle("Add to Card", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.850980401, green: 0.850980401, blue: 0.850980401, alpha: 1)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9725490212, green: 0.9725490212, blue: 0.9725490212, alpha: 1)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mainImageView)
       
        mainStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(combineStackView)
        combineStackView.addArrangedSubview(importantInfoStackView)
        importantInfoStackView.addArrangedSubview(productTitleLabel)
        importantInfoStackView.addArrangedSubview(productPriceLabel)
        combineStackView.addArrangedSubview(spacerView)
        combineStackView.addArrangedSubview(heartButton)
        textStackView.addArrangedSubview(productDescriptionLabel)
        textStackView.addArrangedSubview(productTextLabel)
        addSubview(buttonContainerView)
        buttonContainerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(buyNowButton)
        buttonStackView.addArrangedSubview(addToCardButton)
        
    }
    
    private func setupConstraints() {
        
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(14)
        }

        
        buyNowButton.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        addToCardButton.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }
    
    func returnHeartButton() -> UIButton {heartButton}
}
