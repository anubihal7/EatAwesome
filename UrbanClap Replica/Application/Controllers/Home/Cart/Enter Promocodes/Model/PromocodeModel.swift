//
//

import Foundation

struct PromocodeModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  [PromocodeResult]
}

// MARK: - Body
struct PromocodeResult: Codable {
    let thumbnail: String?
    let id, bodyDescription, code, discount: String?
    let validupto: String?
    let company: CompanyDetil?

    enum CodingKeys: String, CodingKey {
        case thumbnail, id
        case bodyDescription = "description"
        case code, discount, validupto, company
    }
}

//struct PromocodeResult: Decodable
//{
//    let icon: String?
//    let thumbnail: String?
//    let id, name, code, discount: String?
//    let bodyDescription, type: String?
//    let usageLimit: Int?
//    let categoryID, validupto: String?
//   // let userID: JSONNull?
//    let status: Int?
//    let minimumAmount: String?
//  //  let createdAt: Int?
//    let company:CompanyDetil
//
//    enum CodingKeys: String, CodingKey {
//        case icon, thumbnail, id, name, code, discount
//        case bodyDescription = "description"
//        case type, usageLimit
//        case categoryID = "categoryId"
//        case validupto
//      // case companyID = "companyId"
//       // case userID = "userId"
//        case status, minimumAmount
//        case company
//       // case createdAt
//    }
//}

struct CompanyDetil: Codable
{
    let companyName, id: String?
}





