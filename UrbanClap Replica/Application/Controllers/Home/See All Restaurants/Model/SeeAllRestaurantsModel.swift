/
//

import Foundation

// MARK: - Welcome
struct AllRestuarants_Response: Codable
{
    let code: Int
    let message: String
    let body: [BestSellerNEW]
}


// MARK: - Body
struct AllRestrnts: Codable
{
    let vendors: [BestSellerNEW]
    let cartCompanyType:String?
}
