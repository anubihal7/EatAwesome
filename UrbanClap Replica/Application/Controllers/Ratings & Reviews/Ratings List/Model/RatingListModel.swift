
//

import Foundation

struct RatingList_ResponseModel: Decodable
{
    var code: Int?
    var message : String?
    var body : RatingList_Result
}


struct RatingList_Result: Decodable
{
    let avgRating: Double
    let data: [rateData]
}

// MARK: - Datum
struct rateData: Decodable
{
    let id, rating, review: String
    let user: UserDec
}

// MARK: - User
struct UserDec: Decodable
{
    let id, firstName, lastName: String
    let image: String?
}
