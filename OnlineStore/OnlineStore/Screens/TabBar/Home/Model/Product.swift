import Foundation

struct Product {
    let id: Int
    let name: String
    let price: Double
    let category: String
    let imageName: String
}

let defaultProducts: [Product] = [
    Product(id: 1, name: "T-Shirt", price: 19.99, category: "Clothes", imageName: "tshirt"),
    Product(id: 2, name: "Playstation", price: 499.99, category: "Electronics", imageName: "playstation"),
    Product(id: 3, name: "Basketball", price: 29.99, category: "Sports", imageName: "basketball"),
    Product(id: 4, name: "Macbook", price: 3.99, category: "School", imageName: "macbook"),
    Product(id: 5, name: "Cap", price: 14.99, category: "Clothes", imageName: "cap"),
]
