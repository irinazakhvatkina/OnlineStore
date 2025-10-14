import UIKit
import SnapKit

class CartView: UIView {
    
    // MARK: - UI Elements
    
    let deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery to"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let addressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salatiga City, Central Java ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.clipsToBounds = false
        return table
    }()

    private let bottomSummaryView = UIView()
    
    let orderSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Order Summary"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Totals"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$ 1299.00"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let paymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Go to payment", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(deliveryLabel)
        addSubview(addressButton)
        addSubview(separatorView)
        addSubview(tableView)
        addSubview(bottomSummaryView)
        
        bottomSummaryView.addSubview(orderSummaryLabel)
        bottomSummaryView.addSubview(totalLabel)
        bottomSummaryView.addSubview(totalPriceLabel)
        bottomSummaryView.addSubview(paymentButton)
        
        // Configure table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        deliveryLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        addressButton.snp.makeConstraints { make in
            make.centerY.equalTo(deliveryLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(deliveryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(bottomSummaryView.snp.top)
        }
        
        bottomSummaryView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(140)
        }
        
        orderSummaryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(orderSummaryLabel.snp.bottom).offset(8)
            make.leading.equalTo(orderSummaryLabel)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        paymentButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Public Methods

    func updateItems(_ items: [CartItem]) {
        tableView.reloadData()
    }

    func updateTotalPrice(_ price: String) {
        totalPriceLabel.text = price
    }
}

extension CartView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
