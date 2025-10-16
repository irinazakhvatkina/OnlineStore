import UIKit
import SnapKit
import SDWebImage

class WishlistCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: FontNames.regular_18pt, size: 20)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: FontNames.regular_18pt, size: 14)
        return label
    }()

    private let heartButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "WishlistInactive"), for: .normal)
        button.setImage(UIImage(named: "WishlistActive"), for: .selected)
        return button
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryBlue
        button.setTitle("Add to cart", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    var product: Product?
    var onHeartButtonTapped: ((Product) -> Void)?
    var showToast: ((String) -> Void)?
    private var isLiked: Bool = false
    var currencyCode: String = "USD" {
            didSet {
                updatePriceLabel()
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = #colorLiteral(red: 0.9803919196, green: 0.9803923965, blue: 0.9890013337, alpha: 1)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        setupSubviews()
        setupConstraints()
        
        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Subviews
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(itemNameLabel)
        addSubview(priceLabel)
        addSubview(heartButton)
        addSubview(addButton)
    }

    // MARK: - Setup Constraints
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

    // MARK: - Heart Button Action
    @objc private func heartTapped() {
        guard let product = product else { return }
        isLiked.toggle()
        if isLiked {
            WishlistManager.shared.addToWishlist(product)
            showToast?("Added to Wishlist")
        } else {
            WishlistManager.shared.removeFromWishlist(product)
            showToast?("Removed from Wishlist")
        }
        updateHeartButton()
        if let collectionView = superview?.superview?.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView {
            collectionView.reloadData()
        }
    }
    
    func updateHeartButton() {
       let imageName = isLiked ? "WishlistActive" : "WishlistInactive"
       heartButton.setImage(UIImage(named: imageName), for: .normal)
   }
    private func updatePriceLabel() {
        guard let product = product else { return }
        let priceInUSD = product.price
        let convertedPrice = CurrencyManager.shared.convert(priceInUSD: priceInUSD, to: currencyCode) ?? priceInUSD
        priceLabel.text = convertedPrice.formattedPrice(currencyCode: currencyCode)
    }


    // MARK: - Add to Cart Button Action
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        
        if !CartManager.shared.contains(product) {
            CartManager.shared.add(product)
            addButton.setTitle("In Cart", for: .normal)
            addButton.backgroundColor = UIColor.gray
            addButton.isUserInteractionEnabled = false
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } else {
            showToast?("Item already in cart")
        }
    }

    // MARK: - Configure Cell
    func configure(with item: Product) {
        self.product = item
        updatePriceLabel()
        itemNameLabel.text = item.title
        if let imageURLString = item.images.first, let url = URL(string: imageURLString) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        isLiked = WishlistManager.shared.isProductInWishlist(item)
        heartButton.isSelected = isLiked
        
        updateAddToCartButtonState(for: item)
    }
    
    func updateAddToCartButtonState(for product: Product) {
        let isProductInCart = CartManager.shared.contains(product)
        
        if isProductInCart {
            addButton.setTitle("In Cart", for: .normal)
            addButton.backgroundColor = UIColor.gray
            addButton.isUserInteractionEnabled = false
        } else {
            addButton.setTitle("Add to Cart", for: .normal)
            addButton.backgroundColor = .primaryBlue
            addButton.isUserInteractionEnabled = true
        }
    }
}
