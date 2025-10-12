import Foundation

struct CountryData {
    let name: String
    let currencyCode: String
}

protocol DeliveryAddressDelegate: AnyObject {
    func didSelectCountry(country: CountryData)
}
