//

//

import Foundation

// MARK: - Welcome
struct GalleryResult: Codable
{
    let code: Int
    let message: String
    let body: [BodyGllry]?
}

// MARK: - Body
struct BodyGllry: Codable
{
    let mediaHttpUrl : String?
}
