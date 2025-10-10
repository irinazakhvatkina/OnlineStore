class CartManager {
    static let shared = CartManager()
    private init() {}

    private var products: [Product] = []

    var itemsCount: Int {
        return products.count
    }

    func add(_ product: Product) {
        products.append(product)
    }

    func remove(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products.remove(at: index)
        }
    }

    func allItems() -> [Product] {
        return products
    }

    func clear() {
        products.removeAll()
    }
}
