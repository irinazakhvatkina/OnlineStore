import UIKit
import SnapKit
import DesignPackage

class MainViewController: UIViewController, DeliveryAddressDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Components

    private let cartButton = CartButtonView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private var tapGesture: UITapGestureRecognizer!
    private var selectedCategoryIndex: Int = 0
    private var categories: [Category] = []
    private var allProducts: [Product] = []
    private let specialTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Special for you"
        label.font = UIFont(name: FontNames.medium_24pt, size: 20)
        label.textColor = .black
        return label
    }()
    private let specialView = SpecialForYouView()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    private var filteredProducts: [Product] {
        guard categories.indices.contains(selectedCategoryIndex) else { return [] }
        let selectedCategoryName = categories[selectedCategoryIndex].name
        return allProducts.filter { $0.category.name == selectedCategoryName }
    }
    private var selectedCountry: CountryData?

    // MARK: - Collections

    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
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
        setupScrollViewAndStackView()
        fetchDataFromAPI()

        categoriesCollectionView.reloadData()
        productsCollectionView.reloadData()

        if !categories.isEmpty {
            categoriesCollectionView.selectItem(at: IndexPath(item: selectedCategoryIndex, section: 0), animated: false, scrollPosition: [])
        }
        
        updateProductsCollectionViewHeight()
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange(_:)), name: .currencyDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productsCollectionView.reloadData()
    }
    // MARK: - Setup Methods

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
        let itemsCount = CartManager.shared.itemsCount
        cartButton.updateCount(itemsCount)
        cartButton.onTap = { [weak self] in
            guard let self = self else { return }

            if self.deliveryAddressVC.isDropdownVisible {
                self.deliveryAddressVC.hideDropdown(animated: true)
            }

            let cartVC = CartViewController()
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

    private func setupScrollViewAndStackView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        contentStackView.addArrangedSubview(categoriesCollectionView)
        categoriesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        contentStackView.addArrangedSubview(productsCollectionView)

        contentStackView.addArrangedSubview(specialTitleLabel)
        specialTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }

        contentStackView.addArrangedSubview(specialView)
        specialView.snp.makeConstraints { make in
            make.height.equalTo(320)
        }

        specialView.configure(with: "https://akns-images.eonline.com/eol_images/Entire_Site/2022917/rs_1024x759-221017110819-1024-hm.jpg?fit=around%7C1024:759&output-quality=90&crop=1024:759;center,top")
    }

    private func updateProductsCollectionViewHeight() {
        let itemsCount = min(filteredProducts.count, 4)
        guard itemsCount > 0 else {
            productsCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            return
        }
        
        let layout = productsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let padding: CGFloat = 16 * 3
        let availableWidth = view.bounds.width - padding
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.2

        let rows = CGFloat((itemsCount + 1) / 2) 
        let height = rows * itemHeight + (rows - 1) * layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom

        productsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    private func fetchDataFromAPI() {
        Task {
            do {
                // Загружаем продукты и категории
                let products: [Product] = try await APIManager.shared.fetchData(endpoint: .products, type: [Product].self)
                let categories: [Category] = try await APIManager.shared.fetchData(endpoint: .categories, type: [Category].self)

                // Обновляем UI на главном потоке
                DispatchQueue.main.async {
                    self.allProducts = products
                    self.categories = categories

                    self.selectedCategoryIndex = 0
                    self.categoriesCollectionView.reloadData()
                    self.productsCollectionView.reloadData()
                    
                    if !self.categories.isEmpty {
                        self.categoriesCollectionView.selectItem(at: IndexPath(item: self.selectedCategoryIndex, section: 0), animated: false, scrollPosition: [])
                    }

                    self.updateProductsCollectionViewHeight()
                }
            } catch {
                print("❌ Ошибка при загрузке данных: \(error.localizedDescription)")
            }
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
    
    @objc private func cartUpdated() {
        let itemsCount = CartManager.shared.itemsCount
        cartButton.updateCount(itemsCount)
        productsCollectionView.reloadData()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }

    @objc private func currencyDidChange(_ notification: Notification) {
        productsCollectionView.reloadData()
    }

    // MARK: - DeliveryAddressDelegate

    func didSelectCountry(country: CountryData) {
        selectedCountry = country
        addressView.dropdownButton.setTitle(country.name, for: .normal)
        CurrencyManager.shared.setSelectedCurrency(country.currencyCode)

        CurrencyManager.shared.fetchLatestRates { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.productsCollectionView.reloadData()
                case .failure(let error):
                    print("Ошибка загрузки валют: \(error.localizedDescription)")
                }
            }
        }
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
            let isProductInCart = CartManager.shared.contains(product)
            
            let currencyCode = selectedCountry?.currencyCode ?? "USD"
            cell.configure(with: product, isProductInCart: isProductInCart, selectedCurrency: currencyCode)

            cell.onAddToCart = { [weak self] in
                self?.addToCart(product)
                cell.configure(with: product, isProductInCart: true, selectedCurrency: currencyCode)
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
            let padding: CGFloat = 16 * 3
            let availableWidth = collectionView.bounds.width - padding
            let itemWidth = availableWidth / 2
            let itemHeight = itemWidth * 1.2
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            selectedCategoryIndex = indexPath.item
            categoriesCollectionView.performBatchUpdates(nil)
            categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            productsCollectionView.reloadData()
            updateProductsCollectionViewHeight()
            print("Выбрана категория: \(categories[selectedCategoryIndex].name)")
        } else if collectionView == productsCollectionView {
            let item = filteredProducts[indexPath.item]
            let detailsVC = ProductDetailsVC(product: item)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    // MARK: - Cart & Details

    private func addToCart(_ product: Product) {
        if !CartManager.shared.contains(product) {
            CartManager.shared.add(product)
            cartButton.updateCount(CartManager.shared.itemsCount)
            showToast(message: "Item added to cart")
        } else {
            showToast(message: "This item is already in the cart")
        }
    }


    private func openProductDetails(_ product: Product) {
        let detailVC = ProductDetailsVC(product: product)
        detailVC.view.backgroundColor = .white
        detailVC.title = product.title

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
