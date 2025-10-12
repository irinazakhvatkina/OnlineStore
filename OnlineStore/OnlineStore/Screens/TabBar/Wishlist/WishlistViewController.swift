//
//  WishlistViewController.swift
//  OnlineStore
//
//  Created by Administration  on 29/09/25.
//

import UIKit

struct WishlistItem {
    let name: String
    let price: String
    
}

class WishlistViewController: UIViewController {

    private let mainView = WishlistView()
    private let viewModel = WishlistViewModel()
    
    private var items: [WishlistItem] = [
         WishlistItem(name: "Earphones for monitor", price: "$1999"),
         WishlistItem(name: "Mechanical Keyboard", price: "$120"),
         WishlistItem(name: "Gaming Mouse", price: "$49"),
         WishlistItem(name: "Studio Microphone", price: "$199"),
         WishlistItem(name: "Earphones for monitor", price: "$1999"),
         WishlistItem(name: "Mechanical Keyboard", price: "$120"),
         WishlistItem(name: "Gaming Mouse", price: "$49"),
         WishlistItem(name: "Studio Microphone", price: "$199")
     ]
    
    override func loadView() {
        self.view = mainView
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        if viewModel.returnCoreData().fetchProducts().isEmpty {
                  viewModel.createMockData()
              }

            
        viewModel.loadSavedProducts()
        print(viewModel.products)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        viewModel.loadSavedProducts()
        mainView.returnCollectionView().reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupCollectionView() {
        mainView.returnCollectionView().delegate = self
        mainView.returnCollectionView().dataSource = self
        mainView.returnCollectionView().register(WishlistCell.self, forCellWithReuseIdentifier: "WishlistCell")
    }
}


extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as? WishlistCell else {
            return UICollectionViewCell()
        }
        
        let product = viewModel.products[indexPath.item]
              cell.configure(with: WishlistItem(name: product.name, price: "$\(product.price)"))
              return cell
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 - 12) / 2
        return CGSize(width: width, height: 220)
    }
}

