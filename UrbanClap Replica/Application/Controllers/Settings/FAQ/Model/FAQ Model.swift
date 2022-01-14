//

//

import Foundation
struct FAQResponseModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  BodyFAQ
}

// MARK: - Body
struct BodyFAQ: Decodable
{
    var category :[catDEC]
    let data: [FAQResult]
}


struct FAQResult: Decodable
{
    let id, question, answer: String?
    let status: Int?
    let language: String?
}

struct catDEC: Decodable
{
    let catName: String?
    let id: Int?
}

