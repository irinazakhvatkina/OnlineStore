import Foundation

struct CartItem {
    let product: Product
    var quantity: Int

    var title: String { product.title }
    var variant: String { product.category.name }
    var price: String { "\(String(format: "%.2f", product.price))" }
}
