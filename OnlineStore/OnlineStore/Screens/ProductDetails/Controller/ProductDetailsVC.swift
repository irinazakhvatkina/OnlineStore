import UIKit
import DesignPackage

class ProductDetailsVC: UIViewController {

    // MARK: - Properties

    private let mainView = ProductDetailsView()
    private var isLiked = false
    var product: Product
    private let cartView = CartButtonView()

    // MARK: - Init

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product details"
        view = mainView
        mainView.configure(with: product)
        setupBackButton()
        setupRightButton()
        setupButtonTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        isLiked = WishlistManager.shared.isProductInWishlist(product)
        updateHeartButton()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyChanged(_:)), name: .currencyDidChange, object: nil)
        updatePriceLabel()
    }

    // MARK: - Setup

    private func setupButtonTargets() {
        mainView.returnHeartButton().addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        mainView.returnBuyNowButton().addTarget(self, action: #selector(buyNowTapped), for: .touchUpInside)
        mainView.returnAddToCartButton().addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }

    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .mainTitlesDark
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    private func setupRightButton() {
        cartView.updateCount(CartManager.shared.itemsCount)
        cartView.onTap = { [weak self] in
            self?.goToCart()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartView)
    }

    // MARK: - Actions

    @objc private func heartTapped() {
        isLiked.toggle()

        if isLiked {
            WishlistManager.shared.addToWishlist(product)
            showToast(message: "Added to Wishlist")
        } else {
            WishlistManager.shared.removeFromWishlist(product)
            showToast(message: "Removed from Wishlist")
        }

        updateHeartButton()
    }

    


    private func updateHeartButton() {
        let imageName = isLiked ? "WishlistActive" : "WishlistInactive"
        mainView.returnHeartButton().setImage(UIImage(named: imageName), for: .normal)
    }


    @objc private func addToCartTapped() {
        if !CartManager.shared.contains(product) {
            CartManager.shared.add(product)
            cartView.updateCount(CartManager.shared.itemsCount)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
            showToast(message: "Item added to cart")
        } else {
            showToast(message: "This item is already in the cart")
        }
    }

    @objc private func buyNowTapped() {
        if !CartManager.shared.contains(product) {
            CartManager.shared.add(product)
        }
        
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        
        let allItems = CartManager.shared.allItems()
        if let index = allItems.firstIndex(where: { $0.product.id == product.id }) {
            let cartVC = CartViewController(selectedIndex: index)
            navigationController?.pushViewController(cartVC, animated: true)
        } else {
            goToCart()
        }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func cartUpdated() {
        let itemsCount = CartManager.shared.itemsCount
        cartView.updateCount(itemsCount)
    }

    private func updatePriceLabel() {
        let currency = CurrencyManager.shared.selectedCurrency
        mainView.updatePriceLabel(priceInUSD: product.price, currencyCode: currency)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
    }
    
    @objc private func currencyChanged(_ notification: Notification) {
        updatePriceLabel()
    }
    // MARK: - Navigation

    private func goToCart() {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
}
