




import Foundation

// MARK: - Welcome
struct MembershipDataModel: Codable {
    let code: Int?
    let message: String?
    let body: [MemList]?
}

// MARK: - Body
struct MemList: Codable {
    let features: [String]?
    let id, name, companyID: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let subscriptionDurations: [SubscriptionDuration]?
    let userSubscription: UserSubscription?

    enum CodingKeys: String, CodingKey {
        case features, id, name
        case companyID = "companyId"
        case status, createdAt, updatedAt, subscriptionDurations, userSubscription
    }
}

// MARK: - SubscriptionDuration
struct SubscriptionDuration: Codable {
    let duration, id, price: String?
}

// MARK: - UserSubscription
struct UserSubscription: Codable {
    let id, amount: String?
    let duration: Int?
    let durationID, startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case id, amount, duration
        case durationID = "durationId"
        case startDate, endDate
    }
}
