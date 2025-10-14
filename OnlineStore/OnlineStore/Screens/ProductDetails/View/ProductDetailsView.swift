import UIKit
import DesignPackage
import SnapKit

class ProductDetailsView: UIView {

    // MARK: - UI Components

    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0)
        return scroll
    }()
    
    private let containerView = UIView()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()

    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
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
    
    private let spacerView = UIView()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "WishlistInactive"), for: .normal)
        return button
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
        label.text = "Product description goes here..."
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
        button.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.94, alpha: 1)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupSubviews() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(containerView)
        containerView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(combineStackView)
        combineStackView.addArrangedSubview(importantInfoStackView)
        combineStackView.addArrangedSubview(spacerView)
        combineStackView.addArrangedSubview(heartButton)

        importantInfoStackView.addArrangedSubview(productTitleLabel)
        importantInfoStackView.addArrangedSubview(productPriceLabel)

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

        mainImageView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
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

    // MARK: - Public Methods

    func configure(with product: Product) {
        productTitleLabel.text = product.title
        productPriceLabel.text = "$\(String(format: "%.2f", product.price))"
        productDescriptionLabel.text = "Description of product"
        productTextLabel.text = product.description

        if let firstImageURL = product.images.first,
           let url = URL(string: firstImageURL) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.mainImageView.image = image ?? UIImage(named: "placeholder")
                }
            }
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Update Heart Button
    func updateHeartButtonState(for product: Product) {
        let isLiked = WishlistManager.shared.isProductInWishlist(product)
        heartButton.setImage(UIImage(named: isLiked ? "WishlistActive" : "WishlistInactive"), for: .normal)
    }


    func returnHeartButton() -> UIButton {
        return heartButton
    }

    func returnBuyNowButton() -> UIButton {
        return buyNowButton
    }

    func returnAddToCartButton() -> UIButton {
        return addToCardButton
    }
}
