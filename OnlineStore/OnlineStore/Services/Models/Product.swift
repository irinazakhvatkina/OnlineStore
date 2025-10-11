import Foundation

public struct Product: Codable {
    public let id: Int
    public let title: String
    public let price: Double
    public let description: String
    public let category: Category
    public let images: [String]
    public let slug: String?
    public let creationAt: String?
    public let updatedAt: String?
}
