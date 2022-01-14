
//

import Foundation
struct NotificationResponseModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  [NotificationResult]?
}

struct NotificationResult: Decodable
{
    let id, notificationTitle, notificationDescription, userID: String?
    let role, readStatus, status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, notificationTitle, notificationDescription
        case userID = "userId"
        case role, readStatus, status, createdAt, updatedAt
    }
}
