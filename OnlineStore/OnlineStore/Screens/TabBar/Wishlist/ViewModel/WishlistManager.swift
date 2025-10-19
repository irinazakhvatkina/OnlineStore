import Foundation

class WishlistManager {
    
    static let shared = WishlistManager()
    
    private(set) var wishlistItems: [Product] = []
    private let coreData = CoreDataManager.shared
    
    private init() {
        loadWishlistFromCoreData()
    }
    
    func addToWishlist(_ product: Product) {
        guard !wishlistItems.contains(where: { $0.id == product.id }) else { return }
        wishlistItems.append(product)
        
        // Сохраняем в Core Data
        coreData.saveProduct(ProductModel(
            id: String(product.id),
            name: product.title,
            price: product.price,
            description: product.description,
            imageUrl: product.images.first ?? "",
            isFavorite: true
        ))
    }

    func removeFromWishlist(_ product: Product) {
        if let index = wishlistItems.firstIndex(where: { $0.id == product.id }) {
            wishlistItems.remove(at: index)
            
            // Удаляем из Core Data
            coreData.deleteProduct(id: String(product.id))
        }
    }

    
    func isProductInWishlist(_ product: Product) -> Bool {
        return wishlistItems.contains(where: { $0.id == product.id })
    }
    
    private func loadWishlistFromCoreData() {
        let productsFromCoreData = coreData.fetchProducts()
        wishlistItems = productsFromCoreData.map {
            Product(
                id: Int($0.id) ?? 0,
                title: $0.name,
                price: $0.price,
                description: $0.description,
                category: Category(
                    id: 0,
                    name: "Saved",
                    creationAt: nil,
                    updatedAt: nil
                ),
                images: $0.imageUrl.isEmpty ? [] : [$0.imageUrl],
                slug: nil,
                creationAt: nil,
                updatedAt: nil
            )
        }
    }

}
