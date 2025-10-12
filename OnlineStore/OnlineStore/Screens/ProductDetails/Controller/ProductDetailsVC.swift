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
    var product: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product details"
        view.backgroundColor = .white
        view = mainView
        let saved = CoreDataManager.shared.fetchProducts()
        print("Сохранено \(saved.count) продуктов")
        for _ in saved {
           
        }
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
        
        if isLiked {

            CoreDataManager.shared.saveProduct(product ?? ProductModel(id: "22", name: "22", price: 22, description: "22", imageUrl: "", isFavorite: false))
            print("Сохранено: \(String(describing: product?.name))")
          } else {

              if let id = product?.id {
                  CoreDataManager.shared.deleteProduct(id: id)
              }
              print("Удалено: \(String(describing: product?.name))")
          }
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
