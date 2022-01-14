
//

import Foundation

struct FavoriteListModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  [FavoriteListResult]
}



struct FavoriteListResult: Decodable
{
    let id, serviceID, companyID, userID: String?
    let createdAt, updatedAt: Int?
    let service: ServiceDecode
    let cartCategoryType, cartCategoryCompany: String?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceID = "serviceId"
        case companyID = "companyId"
        case userID = "userId"
        case createdAt, updatedAt, service
        case cartCategoryType, cartCategoryCompany
    }
}


// MARK: - Service
struct ServiceDecode: Decodable
{
    let icon, thumbnail: String?
    let id, name, serviceDescription: String?
    let price: Double?
    let type: String?
    let duration, includedServices, excludedServices: String?
   // let createdAt: String?
    let status: Int?
    let category: CategoryDEC
   // let rating: Int?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case serviceDescription = "description"
        case price, type, duration, includedServices, excludedServices, status, category
       // case createdAt
       // case rating
    }
}



// MARK: - Category
struct CategoryDEC: Decodable

{
    let id, name, companyID: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case companyID = "companyId"
    }
}



