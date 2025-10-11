import Foundation

public final class APIManager {
    public static let shared = APIManager()
    private init() {}
    
    func fetchData<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: endpoint.url)

        // ✅ Печатаем JSON как строку
        if let json = String(data: data, encoding: .utf8) {
            print("✅ Полученный JSON:\n\(json)")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Ошибка при декодировании: \(error)")
            throw error
        }
    }


    public func sendData<T: Codable, R: Decodable>(endpoint: Endpoint, body: T, responseType: R.Type) async throws -> R {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error \(httpResponse.statusCode)"])
        }

        return try JSONDecoder().decode(R.self, from: data)
    }
}
