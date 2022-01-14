
//

import Foundation

struct AddressList_ResponseModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  [AddressList_Result]
}

struct AddressList_Result: Decodable
{
    var id, addressName,addressType, latitude, longitude: String
    var town, landmark, city, companyID: String
    var userID: String
    var bodyDefault, status, createdAt, updatedAt: Int

    enum CodingKeys: String, CodingKey
    {
        case id, addressName,addressType, latitude, longitude, town, landmark, city
        case companyID = "companyId"
        case userID = "userId"
        case bodyDefault = "default"
        case status, createdAt, updatedAt
    }
}

