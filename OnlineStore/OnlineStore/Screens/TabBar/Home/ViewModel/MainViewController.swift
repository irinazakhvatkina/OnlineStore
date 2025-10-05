import UIKit
import SnapKit
import DesignPackage

class MainViewController: UIViewController, DeliveryAddressDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Components

    private let cartButton = CartButtonView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private var tapGesture: UITapGestureRecognizer!
    private var selectedCategoryIndex: Int = 0
    private let categories: [Category] = defaultCategories
    private let allProducts: [Product] = defaultProducts

    private var filteredProducts: [Product] {
        guard categories.indices.contains(selectedCategoryIndex) else { return [] }
        return allProducts.filter { $0.category == categories[selectedCategoryIndex].name }
    }
    
    // MARK: - Collections
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return collectionView
    }()
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return collectionView
    }()

    // MARK: - Controllers
    
    private var deliveryAddressVC: DeliveryAddressViewController!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTapGestures()
        setupCategoriesCollectionView()
        setupProductsCollectionView()
        
        categoriesCollectionView.reloadData()
        productsCollectionView.reloadData()

        if !categories.isEmpty {
            categoriesCollectionView.selectItem(at: IndexPath(item: selectedCategoryIndex, section: 0), animated: false, scrollPosition: [])
        }
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        configureAddressView()
        configureCartButton()
        configureDeliveryAddressVC()
    }

    private func configureAddressView() {
        addressView.dropdownButton.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addressView)
    }

    private func configureCartButton() {
        cartButton.updateCount(2)
        cartButton.onTap = { [weak self] in
            guard let self = self else { return }

            if self.deliveryAddressVC.isDropdownVisible {
                self.deliveryAddressVC.hideDropdown(animated: true)
            }

            let cartVC = UIViewController()
            cartVC.view.backgroundColor = .white
            cartVC.title = "Cart"
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
    }

    private func configureDeliveryAddressVC() {
        deliveryAddressVC = DeliveryAddressViewController(anchorView: addressView.dropdownButton)
        deliveryAddressVC.delegate = self

        deliveryAddressVC.onDropdownToggle = { [weak self] isOpen in
            guard let self = self else { return }
            isOpen ? self.addressView.setArrowUp() : self.addressView.setArrowDown()
        }
    }

    private func setupTapGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        if let tabBar = tabBarController?.tabBar {
            let tabBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
            tabBarTapGesture.cancelsTouchesInView = false
            tabBar.addGestureRecognizer(tabBarTapGesture)
        }
    }
    
    private func setupCategoriesCollectionView() {
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func setupProductsCollectionView() {
        view.addSubview(productsCollectionView)

        productsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesCollectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc private func didTapAddressButton() {
        deliveryAddressVC.toggleDropdown()
    }

    @objc private func handleTapOutside(_ sender: UITapGestureRecognizer) {
        guard deliveryAddressVC.isDropdownVisible else { return }

        let location = sender.location(in: view)
        let dropdownButtonFrame = view.convert(addressView.dropdownButton.frame, from: addressView.dropdownButton.superview)

        if !dropdownButtonFrame.contains(location) {
            deliveryAddressVC.hideDropdown(animated: true)
        }
    }

    // MARK: - DeliveryAddressDelegate

    func didSelectCountry(country: CountryData) {
        addressView.dropdownButton.setTitle(country.name, for: .normal)
        print("Выбрана страна: \(country.name), валюта: \(country.currencyCode)")
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categories.count
        } else {
            return min(filteredProducts.count, 4)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            cell.configure(with: category)
            cell.isSelected = (indexPath.item == selectedCategoryIndex)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            let product = filteredProducts[indexPath.item]
            cell.configure(with: product)
            cell.onAddToCart = { [weak self] in
                self?.addToCart(product)
            }
            return cell
        }
    }
    
    // MARK: - UICollectionView DelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            let category = categories[indexPath.item]
            let font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            let width = category.name.size(withAttributes: [.font: font]).width + 24
            return CGSize(width: width, height: 31)
        } else {
            let padding: CGFloat = 16 * 3 // левая + правая + межколоночный отступ
            let availableWidth = collectionView.bounds.width - padding
            let itemWidth = availableWidth / 2
            let itemHeight = itemWidth * 1.2 // например, пропорция по высоте
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            selectedCategoryIndex = indexPath.item
            categoriesCollectionView.performBatchUpdates(nil)
            categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            productsCollectionView.reloadData()
            print("Выбрана категория: \(categories[selectedCategoryIndex].name)")
        } else {
            let product = filteredProducts[indexPath.item]
            openProductDetails(product)
        }
    }
    
    // MARK: - Cart & Details
    
    private func addToCart(_ product: Product) {
        print("Добавлено в корзину: \(product.name)")
        // Тут можно обновить состояние корзины или счетчик
    }

    private func openProductDetails(_ product: Product) {
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .white
        detailVC.title = product.name
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "\(product.name)\nЦена: $\(product.price)"
        detailVC.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
