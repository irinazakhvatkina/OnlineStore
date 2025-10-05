import UIKit
import SnapKit
import DesignPackage

class MainViewController: UIViewController, DeliveryAddressDelegate {

    // MARK: - UI Components

    private let cartButton = CartButtonView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private var tapGesture: UITapGestureRecognizer!

    // MARK: - Controllers
    
    private var deliveryAddressVC: DeliveryAddressViewController!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTapGestures()
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
}
