//
//  ProductModel.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 12/10/25.
//

struct ProductModel: Identifiable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let imageUrl: String
    var isFavorite: Bool
}
