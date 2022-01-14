

import Foundation

// MARK: - Welcome
struct ServiceDetailCatModel: Decodable
{
    let code: Int
    let message: String
    let body: ServiceDetailResult
}

// MARK: - Body
struct ServiceDetailResult: Decodable
{
    let icon, thumbnail,favourite: String?
    let id, name, bodyDescription: String?
    let type, duration, turnaroundTime, includedServices: String?
    let excludedServices, rating, cart: String?
    let category: CategoryDec
    let originalPrice:Double?
    let itemType:String?
    let price:Double?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case bodyDescription = "description"
        case price, type, duration, turnaroundTime, includedServices, excludedServices, rating, favourite, cart, category
        case itemType
        case originalPrice
    }
}


// MARK: - Category
struct CategoryDec: Decodable
{
    let icon, thumbnail: String?
    let id, name: String?
}




