import UIKit
import SnapKit
import DesignPackage

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    private let mainView = CartView()
    private var cartItems: [CartItem] = []
    private var selectedIndexes = Set<Int>()
    private var selectedIndex: Int?
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Your cart is empty"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Initialization

    init(selectedIndex: Int? = nil) {
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        view.backgroundColor = .white
        
        cartItems = CartManager.shared.allItems()
        setupTableView()
        setupEmptyCartLabel()
        updateTotalPrice()
        setupBackButton()
        
        if let selectedIndex = selectedIndex {
            selectItem(at: selectedIndex)
        }
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .mainTitlesDark
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupEmptyCartLabel() {
        view.addSubview(emptyCartLabel)
        emptyCartLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // MARK: - Cart Item Selection

    private func selectItem(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let cell = self.mainView.tableView.cellForRow(at: indexPath) as? CartTableViewCell {
                cell.setSelectedCheckbox(true)
                self.selectedIndexes.insert(index)
                self.updateTotalPrice()
            }
            self.mainView.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }

    private func loadCartItems() {
        cartItems = CartManager.shared.allItems()
        mainView.updateItems(cartItems)
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyCartLabel.isHidden = cartItems.count > 0
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        
        cell.setSelectedCheckbox(selectedIndexes.contains(indexPath.row))
        
        return cell
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = cartItems[indexPath.row]
        let detailVC = ProductDetailsVC(product: selectedItem.product)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - CartTableViewCellDelegate Methods

    func didTapPlus(in cell: CartTableViewCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        cartItems[indexPath.row].quantity += 1
        mainView.tableView.reloadRows(at: [indexPath], with: .none)
        updateTotalPrice()
    }

    func didTapMinus(in cell: CartTableViewCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        if cartItems[indexPath.row].quantity > 1 {
            cartItems[indexPath.row].quantity -= 1
            mainView.tableView.reloadRows(at: [indexPath], with: .none)
            updateTotalPrice()
        }
    }

    func didToggleCheckbox(in cell: CartTableViewCell, isSelected: Bool) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        if isSelected {
            selectedIndexes.insert(indexPath.row)
        } else {
            selectedIndexes.remove(indexPath.row)
        }
        updateTotalPrice()
    }

    // MARK: - Update Total Price

    private func updateTotalPrice() {
        let total = selectedIndexes.reduce(0.0) { result, index in
            let item = cartItems[index]
            let priceString = item.price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ".")
            let price = Double(priceString) ?? 0.0
            return result + price * Double(item.quantity)
        }
        mainView.totalPriceLabel.text = String(format: "$ %.2f", total)
        emptyCartLabel.isHidden = !cartItems.isEmpty
    }
}
