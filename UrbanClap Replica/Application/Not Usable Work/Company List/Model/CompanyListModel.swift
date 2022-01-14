//
//
//



import Foundation

struct CompanyListModel: Decodable
{
    let code: Int
    let message: String
    let body: [CompanyBody]
}

// MARK: - Body
struct CompanyBody: Decodable
{
    let logo1: String?
    let id, companyName, address1: String
    let categories: [CategoryDeccode]
    let cartCompanyID: String

    enum CodingKeys: String, CodingKey {
        case logo1, id, companyName, address1, categories
        case cartCompanyID = "cartCompanyId"
    }
}

// MARK: - Category
struct CategoryDeccode: Codable
{
    let id, parentID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parentId"
    }
}

