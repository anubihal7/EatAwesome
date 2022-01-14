//

//

import Foundation

struct SubCatsModel: Decodable
{
    let code: Int
    let message: String
    let body: BodyData
}

struct BodyData: Decodable
{
    let subcategories: [Subcategory]
}


// MARK: - Subcategory
struct Subcategory: Decodable
{
    let id, categoryID: String
    let name: String
    let thumbnail: String
    let isService: Bool

    enum CodingKeys: String, CodingKey
    {
        case id
        case categoryID = "category_id"
        case name, thumbnail, isService
    }
}



