import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    private var items: [CartItem] = []

    var itemsCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }

    func add(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            let item = CartItem(product: product, quantity: quantity)
            items.append(item)
        }
    }

    func allItems() -> [CartItem] {
        return items
    }

    func clear() {
        items.removeAll()
    }

    func contains(_ product: Product) -> Bool {
        return items.contains(where: { $0.product.id == product.id })
    }
}
