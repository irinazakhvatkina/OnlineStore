//
//  CartViewController.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 05/10/25.
//

import UIKit

class CartViewController: UIViewController {

    private let mainView = CartView()

    private var cartItems: [CartItem] = [
        CartItem(title: "MacBook Pro M4", variant: "Grey", price: "$ 1299,00", quantity: 1),
        CartItem(title: "MacBook Pro M4", variant: "Grey", price: "$ 1299,00", quantity: 1),
        CartItem(title: "MacBook Pro M4", variant: "Grey", price: "$ 1299,00", quantity: 1)
    ]

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell",
                                                       for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cartItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension CartViewController: CartTableViewCellDelegate {
    func didTapPlus(in cell: CartTableViewCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        cartItems[indexPath.row].quantity += 1
        mainView.tableView.reloadRows(at: [indexPath], with: .none)
    }

    func didTapMinus(in cell: CartTableViewCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        if cartItems[indexPath.row].quantity > 1 {
            cartItems[indexPath.row].quantity -= 1
            mainView.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
