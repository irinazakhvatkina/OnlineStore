import Foundation

class CurrencyManager {
    static let shared = CurrencyManager()
    private let apiKey = "eedc7a94167e4675b5edc45640d03941"
    private let session = URLSession.shared

    private(set) var rates: [String: Double] = [:]
    private(set) var baseCurrency: String = "USD"

    private(set) var selectedCurrency: String = "USD" {
        didSet {
            NotificationCenter.default.post(name: .currencyDidChange, object: selectedCurrency)
        }
    }

    func setSelectedCurrency(_ currencyCode: String) {
        selectedCurrency = currencyCode
    }

    func fetchLatestRates(completion: @escaping (Result<Void, Error>) -> Void) {
        let urlStr = "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)"
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "Bad URL", code: 400)))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                self.baseCurrency = json?["base"] as? String ?? "USD"
                self.rates = json?["rates"] as? [String: Double] ?? [:]
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func convert(priceInUSD: Double, to currencyCode: String) -> Double? {
        guard let rate = rates[currencyCode] else { return nil }
        return priceInUSD * rate
    }
}

extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}
