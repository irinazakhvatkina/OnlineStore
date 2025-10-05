import UIKit
import SnapKit
import DesignPackage

class MainViewController: UIViewController, DeliveryAddressDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Components

    private let cartButton = CartButtonView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Collections

    private let categories: [Category] = [
        Category(name: "Clothes"),
        Category(name: "Electronics"),
        Category(name: "Sports"),
        Category(name: "School"),
        Category(name: "Category")

    ]
    
    private var selectedCategoryIndex: Int = 0
    
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

    // MARK: - Controllers
    
    private var deliveryAddressVC: DeliveryAddressViewController!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTapGestures()
        setupCategoriesCollectionView()
        
        // первую категорию
        categoriesCollectionView.selectItem(at: IndexPath(item: selectedCategoryIndex, section: 0), animated: false, scrollPosition: [])

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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.configure(with: category)
        cell.isSelected = (indexPath.item == selectedCategoryIndex) // Обновляем визуально выбранность
        return cell
    }
    
    // MARK: - UICollectionView DelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        let width = category.name.size(withAttributes: [.font: font]).width + 24
        return CGSize(width: width, height: 31)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
        collectionView.performBatchUpdates(nil)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print("Выбрана категория: \(categories[selectedCategoryIndex].name)")
    }
}
