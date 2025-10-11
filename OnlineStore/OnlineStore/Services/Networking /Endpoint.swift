import Foundation

public enum Endpoint {
    case products
    case productDetails(id: Int)
    case categories
    case search(query: String)
    case createProduct

    public var url: URL {
        let baseURL = "https://api.escuelajs.co/api/v1"

        switch self {
        case .products:
            return URL(string: "\(baseURL)/products")!
        case .productDetails(let id):
            return URL(string: "\(baseURL)/products/\(id)")!
        case .categories:
            return URL(string: "\(baseURL)/categories")!
        case .search(let query):
            var components = URLComponents(string: "\(baseURL)/products")!
            components.queryItems = [URLQueryItem(name: "title", value: query)]
            return components.url!
        case .createProduct:
            return URL(string: "\(baseURL)/products")!
        }
    }

    public var method: String {
        switch self {
        case .createProduct:
            return "POST"
        default:
            return "GET"
        }
    }
}
