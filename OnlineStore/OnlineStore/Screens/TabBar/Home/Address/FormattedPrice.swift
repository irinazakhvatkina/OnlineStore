import UIKit

extension Double {
    func formattedPrice(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        formatter.locale = Locale(identifier: localeForCurrency(currencyCode: currencyCode))
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    private func localeForCurrency(currencyCode: String) -> String {
        switch currencyCode {
        case "USD": return "en_US"
        case "EUR": return "fr_FR"
        case "KZT": return "kk_KZ" 
        case "GBP": return "en_GB"
        case "JPY": return "ja_JP"
        case "RUB": return "ru_RU"
        default: return "en_US"
        }
    }
}
