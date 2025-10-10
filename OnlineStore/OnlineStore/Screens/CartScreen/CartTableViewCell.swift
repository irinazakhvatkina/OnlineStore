//
//  CartTableViewCell.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 05/10/25.
//

import UIKit
import SnapKit

protocol CartTableViewCellDelegate: AnyObject {
    func didTapPlus(in cell: CartTableViewCell)
    func didTapMinus(in cell: CartTableViewCell)
}

struct CartItem {
    let title: String
    let variant: String
    let price: String
    var quantity: Int
}

class CartTableViewCell: UITableViewCell {
    
    weak var delegate: CartTableViewCellDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgslider")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MacBook Pro M4"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let variantLabel: UILabel = {
        let label = UILabel()
        label.text = "Variant: Grey"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$1299,00"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "increaseButton"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "reduceButton"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(named: "checkedIcon"), for: .selected)
        button.tintColor = .lightGray
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = false
        clipsToBounds = false

        setupSubviews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        checkboxButton.isSelected.toggle()
    }
    

    @objc private func plusTapped() {
        delegate?.didTapPlus(in: self)
    }

    @objc private func minusTapped() {
        delegate?.didTapMinus(in: self)
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkboxButton)
        containerView.addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(variantLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(plusButton)
        containerView.addSubview(minusButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        checkboxButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        productImageView.snp.makeConstraints { make in
            make.leading.equalTo(checkboxButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top)
            make.leading.equalTo(productImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        variantLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productImageView.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(priceLabel)
            make.width.height.equalTo(28)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(plusButton)
            make.trailing.equalTo(plusButton.snp.leading).offset(-8)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(plusButton)
            make.trailing.equalTo(quantityLabel.snp.leading).offset(-8)
            make.width.height.equalTo(28)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containerView.layer.shadowPath = UIBezierPath(
                roundedRect: self.containerView.bounds,
                cornerRadius: self.containerView.layer.cornerRadius
            ).cgPath
        }

    }
    
    func configure(with item: CartItem) {
        titleLabel.text = item.title
        variantLabel.text = "Variant: \(item.variant)"
        priceLabel.text = item.price
        quantityLabel.text = "\(item.quantity)"
    }

    
}
