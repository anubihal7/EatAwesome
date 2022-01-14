
//

import Foundation

// MARK: - TiffinHomeModel
struct TiffinHomeModel: Codable {
    let code: Int?
    let message: String?
    let body: [TiffinHomeBody]?
}

// MARK: - Body
struct TiffinHomeBody: Codable {
    let tags, availability, packages: [String]?
    let deliveryTimings: [String]?
    let icon, thumbnail, id, name: String?
    let bodyDescription, itemType, companyId, totalRatings: String?
    let rating: String?
    let company: Company?
}

// MARK: - Company
struct Company: Codable {
    let id, companyName: String?
    let distance: Double?
}
