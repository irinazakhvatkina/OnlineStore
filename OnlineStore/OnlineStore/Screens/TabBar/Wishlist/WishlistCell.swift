//
//  WishlistCell.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 05/10/25.
//

import UIKit
import SnapKit

class WishlistCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "imgslider")
        return imageView
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.text = "Earphones for monitor"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.text = "$1999"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let heartButton: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFit
        iv.setImage(UIImage(named: "WishlistActive"), for: .normal)
        return iv
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryBlue
        button.setTitle("Add to cart", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = #colorLiteral(red: 0.9803919196, green: 0.9803923965, blue: 0.9890013337, alpha: 1)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(itemNameLabel)
        addSubview(priceLabel)
        addSubview(heartButton)
        addSubview(addButton)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(13)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(heartButton)
            make.trailing.equalToSuperview().inset(13)
            make.leading.equalTo(heartButton.snp.trailing).offset(12)
        }
    }

    
    func configure(with item: WishlistItem) {
           itemNameLabel.text = item.name
           priceLabel.text = item.price
           // imageView.image = UIImage(named: item.imageName)
       }
    
}
