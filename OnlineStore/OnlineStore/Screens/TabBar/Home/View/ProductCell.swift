import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)

    var onAddToCart: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true

        // Картинка
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] 
        contentView.addSubview(imageView)

        // Название
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        nameLabel.numberOfLines = 1
        contentView.addSubview(nameLabel)

        // Цена
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        priceLabel.textColor = .darkGray
        contentView.addSubview(priceLabel)

        // Кнопка
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addToCartButton.backgroundColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
        addToCartButton.tintColor = .white
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 40, bottom: 8, right: 40)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        contentView.addSubview(addToCartButton)

        setupConstraints()
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
            make.width.equalTo(170)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(144)
            make.height.equalTo(31)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    @objc private func addToCartTapped() {
        onAddToCart?()
    }

    func configure(with product: Product) {
        imageView.image = UIImage(named: product.imageName)
        nameLabel.text = product.name
        priceLabel.text = String(format: "$%.2f", product.price)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
