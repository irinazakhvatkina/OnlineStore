import UIKit
import DesignPackage

class WishlistViewController: UIViewController {

    private let mainView = WishlistView()

    private var items: [Product] {
        return WishlistManager.shared.wishlistItems
    }

    // MARK: - Lifecycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        updateWishlistUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
//        updateHeartButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainView.returnCollectionView().reloadData()
        updateWishlistUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Setup

    private func setupCollectionView() {
        mainView.returnCollectionView().delegate = self
        mainView.returnCollectionView().dataSource = self
        mainView.returnCollectionView().register(WishlistCell.self, forCellWithReuseIdentifier: "WishlistCell")
    }

    // MARK: - UI Handling

    private func showEmptyWishlistMessage() {
        let emptyMessageLabel = UILabel()
        emptyMessageLabel.text = "Your wishlist is empty."
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.font = UIFont(name: FontNames.regular_18pt, size: 18)
        emptyMessageLabel.textColor = .gray
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.alpha = 0.0
        mainView.addSubview(emptyMessageLabel)

        emptyMessageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        UIView.animate(withDuration: 0.5) {
            emptyMessageLabel.alpha = 1.0
        }
    }

    private func hideEmptyWishlistMessage() {
        if let messageLabel = mainView.subviews.first(where: { $0 is UILabel && ($0 as! UILabel).text == "Your wishlist is empty." }) {
            UIView.animate(withDuration: 0.5, animations: {
                messageLabel.alpha = 0.0
            }) { _ in
                messageLabel.removeFromSuperview()
            }
        }
    }

    private func updateWishlistUI() {
        if items.isEmpty {
            showEmptyWishlistMessage()
        } else {
            hideEmptyWishlistMessage()
            reloadWishlist()
        }
    }
    
    private func reloadWishlist() {
        mainView.returnCollectionView().reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate FlowLayout
extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureCell(_ cell: WishlistCell, for product: Product) {
        cell.configure(with: product)
        cell.showToast = { [weak self] message in
            self?.showToast(message: message)  
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as? WishlistCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 - 12) / 2
        return CGSize(width: width, height: 220)
    }
}
