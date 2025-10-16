import UIKit
import DesignPackage

class WishlistViewController: UIViewController {

    // MARK: - UI Components

    private let mainView = WishlistView()

    // MARK: - Data Sources

    private var items: [Product] {
        return WishlistManager.shared.wishlistItems
    }

    private var filteredItems: [Product] = []
    private var isSearching = false
    private var emptyWishlistLabel: UILabel?

    // MARK: - Currency

    var selectedCurrencyCode: String = "USD" {
        didSet {
            mainView.returnCollectionView().reloadData()
        }
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainView.returnCollectionView().reloadData()
        updateWishlistUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .white
        mainView.searchBar.delegate = self
    }

    private func setupCollectionView() {
        let collectionView = mainView.returnCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WishlistCell.self, forCellWithReuseIdentifier: "WishlistCell")
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(currencyDidChange(_:)),
            name: .currencyDidChange,
            object: nil
        )
    }

    // MARK: - Currency Handling

    @objc private func currencyDidChange(_ notification: Notification) {
        selectedCurrencyCode = CurrencyManager.shared.selectedCurrency
    }

    // MARK: - Wishlist UI Updates

    private func updateWishlistUI() {
        items.isEmpty ? showEmptyWishlistMessage() : hideEmptyWishlistMessage()
        reloadWishlist()
    }

    private func reloadWishlist() {
        mainView.returnCollectionView().reloadData()
    }

    // MARK: - Empty State Handling

    private func showEmptyWishlistMessage() {
        if emptyWishlistLabel == nil {
            let label = UILabel()
            label.text = "Your wishlist is empty."
            label.textAlignment = .center
            label.font = UIFont(name: FontNames.regular_18pt, size: 18)
            label.textColor = .gray
            label.numberOfLines = 0
            label.alpha = 0.0
            mainView.addSubview(label)

            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            emptyWishlistLabel = label
        }
        UIView.animate(withDuration: 0.5) {
            self.emptyWishlistLabel?.alpha = 1.0
        }
    }

    private func hideEmptyWishlistMessage() {
        UIView.animate(withDuration: 0.5) {
            self.emptyWishlistLabel?.alpha = 0.0
        } completion: { _ in
            self.emptyWishlistLabel?.removeFromSuperview()
            self.emptyWishlistLabel = nil
        }
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout

extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private func configureCell(_ cell: WishlistCell, for product: Product) {
        cell.currencyCode = selectedCurrencyCode
        cell.configure(with: product)
        cell.showToast = { [weak self] message in
            self?.showToast(message: message)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredItems.count : items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "WishlistCell", for: indexPath
        ) as? WishlistCell else {
            return UICollectionViewCell()
        }

        let item = isSearching ? filteredItems[indexPath.item] : items[indexPath.item]
        configureCell(cell, for: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 - 12) / 2
        return CGSize(width: width, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = isSearching ? filteredItems[indexPath.item] : items[indexPath.item]
        let detailVC = ProductDetailsVC(product: selectedProduct)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension WishlistViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercased()

        if query.isEmpty {
            isSearching = false
            filteredItems.removeAll()
        } else {
            isSearching = true
            filteredItems = items.filter { $0.title.lowercased().contains(query) }
        }

        mainView.returnCollectionView().reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredItems.removeAll()
        searchBar.text = ""
        mainView.returnCollectionView().reloadData()
    }
}
