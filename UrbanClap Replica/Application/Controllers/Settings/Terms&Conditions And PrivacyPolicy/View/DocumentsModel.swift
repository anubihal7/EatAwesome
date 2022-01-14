
//

import Foundation

// MARK: - Welcome
struct documentsResult: Codable {
    let code: Int
    let message: String
    let body: Docs
}

// MARK: - Body
struct Docs: Codable {
    let id, aboutus: String
    let aboutusLink: String
    let privacyContent, termsContent: String
    var termsLink, privacyLink: String
    var cancellationPolicy,cancellationLink : String
}
