import UIKit
import SnapKit

// MARK: - DeliveryAddressViewController

class DeliveryAddressViewController: UIViewController {

    // MARK: - Nested Types

    private enum Constants {
        static let rowHeight: CGFloat = 44
        static let maxVisibleRows: Int = 5
        static let tableViewCornerRadius: CGFloat = 6
        static let tableViewBorderWidth: CGFloat = 1
        static let tableViewVerticalOffset: CGFloat = 4
        static let animationDuration: TimeInterval = 0.25
    }

    // MARK: - Properties

    weak var delegate: DeliveryAddressDelegate?

    private let countries: [CountryData] = [
        CountryData(name: "Tajikistan (TJS)", currencyCode: "TJS"),
        CountryData(name: "USA (USD)", currencyCode: "USD"),
        CountryData(name: "Russia (RUB)", currencyCode: "RUB"),
        CountryData(name: "Germany (EUR)", currencyCode: "EUR"),
        CountryData(name: "Korea (KRW)", currencyCode: "KRW"),
        CountryData(name: "China (CNY)", currencyCode: "CNY"),
        CountryData(name: "Japan (JPY)", currencyCode: "JPY")
    ]

    var isDropdownVisible = false
    var selectedCountry: CountryData?
    var onDropdownToggle: ((Bool) -> Void)?

    private let tableView = UITableView()
    private weak var anchorView: UIView?

    // MARK: - Init

    init(anchorView: UIView) {
        self.anchorView = anchorView
        super.init(nibName: nil, bundle: nil)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.isHidden = true
        tableView.layer.borderWidth = Constants.tableViewBorderWidth
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = Constants.tableViewCornerRadius
        tableView.delegate = self
        tableView.dataSource = self

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(tableView)
        }
    }

    // MARK: - Public Methods

    func toggleDropdown() {
        isDropdownVisible ? hideDropdown(animated: true) : showDropdown()
    }

    func hideDropdown(animated: Bool) {
        let collapse = {
            self.tableView.frame.size.height = 0
        }

        let finish: (Bool) -> Void = { _ in
            self.tableView.isHidden = true
            self.isDropdownVisible = false
            self.onDropdownToggle?(false)
        }

        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: collapse, completion: finish)
        } else {
            collapse()
            finish(true)
        }
    }

    // MARK: - Private Methods

    private func showDropdown() {
        guard let anchorView = anchorView,
              let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        isDropdownVisible = true
        onDropdownToggle?(true)

        tableView.isHidden = false
        tableView.reloadData()

        let anchorFrame = anchorView.convert(anchorView.bounds, to: window)
        let visibleRowCount = min(countries.count, Constants.maxVisibleRows)
        let targetHeight = CGFloat(visibleRowCount) * Constants.rowHeight

        // Start from 0 height
        tableView.frame = CGRect(
            x: anchorFrame.minX,
            y: anchorFrame.maxY + Constants.tableViewVerticalOffset,
            width: anchorFrame.width,
            height: 0
        )

        UIView.animate(withDuration: Constants.animationDuration) {
            self.tableView.frame.size.height = targetHeight
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension DeliveryAddressViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CountryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ??
                   UITableViewCell(style: .default, reuseIdentifier: cellId)

        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        selectedCountry = country
        delegate?.didSelectCountry(country: country)
        hideDropdown(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
}
