import Foundation

class WishlistManager {
    
    static let shared = WishlistManager()
    
    private(set) var wishlistItems: [Product] = []
    
    private init() {}
    
    func addToWishlist(_ product: Product) {
        if !wishlistItems.contains(where: { $0.id == product.id }) {
            wishlistItems.append(product)
        }
    }
    
    func removeFromWishlist(_ product: Product) {
        if let index = wishlistItems.firstIndex(where: { $0.id == product.id }) {
            wishlistItems.remove(at: index)
        }
    }
    
    func isProductInWishlist(_ product: Product) -> Bool {
        return wishlistItems.contains(where: { $0.id == product.id })
    }
}
