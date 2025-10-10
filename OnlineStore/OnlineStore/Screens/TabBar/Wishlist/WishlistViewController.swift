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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as? WishlistCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 - 12) / 2  // две колонки с отступами
        return CGSize(width: width, height: 220)
    }
}

