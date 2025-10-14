import UIKit
import SnapKit
import DesignPackage

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)

    var onAddToCart: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 7

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        // image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.addSubview(imageView)

        // title
        nameLabel.font = UIFont(name: FontNames.regular_18pt, size: 16)
        nameLabel.numberOfLines = 1
        containerView.addSubview(nameLabel)

        // price
        priceLabel.font = UIFont(name: FontNames.regular_18pt, size: 14)
        priceLabel.textColor = .darkGray
        containerView.addSubview(priceLabel)

        // button "Add to cart"
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.titleLabel?.font = UIFont(name: FontNames.medium_18pt, size: 16)
        addToCartButton.backgroundColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
        addToCartButton.tintColor = .white
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        containerView.addSubview(addToCartButton)

        setupConstraints()
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(217)
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
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
        let originalTitle = addToCartButton.title(for: .normal)
        addToCartButton.setTitle("Added", for: .normal)
        
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseInOut, animations: {
            self.addToCartButton.setTitle(originalTitle, for: .normal)
        })
    }

    func configure(with product: Product, isProductInCart: Bool) {
        nameLabel.text = product.title
        priceLabel.text = String(format: "$%.2f", product.price)

        imageView.image = nil

        if let firstImageURLString = product.images.first,
           let url = URL(string: firstImageURLString) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                self.imageView.image = image ?? UIImage(named: "placeholder")
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }

        if isProductInCart {
            addToCartButton.setTitle("In Cart", for: .normal)
            addToCartButton.backgroundColor = UIColor.gray
            addToCartButton.isUserInteractionEnabled = false
        } else {
            addToCartButton.setTitle("Add to Cart", for: .normal)
            addToCartButton.backgroundColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
            addToCartButton.isUserInteractionEnabled = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
