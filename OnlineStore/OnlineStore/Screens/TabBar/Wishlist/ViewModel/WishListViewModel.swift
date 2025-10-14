//
//  WishListViewModel.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 12/10/25.
//

import Foundation

final class WishlistViewModel {
    private let coreData = CoreDataManager.shared
    var products: [ProductModel] = []

    func loadSavedProducts() {
        products = coreData.fetchProducts()
    }

    func createMockData() {
        let mocks = [
            ProductModel(id: "1", name: "Xiaomi Pro 10", price: 1220.5, description: "Best Chinese phone on the market", imageUrl: "", isFavorite: true),
            ProductModel(id: "2", name: "IPhone 17 Pro Max", price: 55555, description: "No comment", imageUrl: "", isFavorite: true)
        ]

        mocks.forEach { coreData.saveProduct($0) }
    }
    
    func returnCoreData() -> CoreDataManager { coreData }
}
