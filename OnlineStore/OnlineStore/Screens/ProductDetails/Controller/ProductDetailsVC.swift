//
//  ProductDetailsVC.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 02/10/25.
//
import UIKit

class ProductDetailsVC: UIViewController {
    
    private let mainView = ProductDetailsView()
    private var isLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product details"
        view.backgroundColor = .white
        view = mainView
        
        setupBackButton()
        setupRightButton()
        setupButtonTargets()
    }
    
    private func setupButtonTargets() {
        mainView.returnHeartButton().addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
    }
    
    @objc private func heartTapped() {
        isLiked.toggle()
        let imageName = isLiked ? "WishlistActive" : "WishlistInactive"
        mainView.returnHeartButton().setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func setupBackButton() {
       
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .systemGray
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupRightButton() {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(named: "Buy"), for: .normal)
        rightButton.tintColor = .systemGray
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightButtonTapped() {
        
    }
}
