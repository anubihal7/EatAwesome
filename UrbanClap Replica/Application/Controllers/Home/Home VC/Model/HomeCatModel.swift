
//

import Foundation

// MARK: - Welcome
struct HomeCat_ResponseModel: Decodable
{
    let code: Int?
    let message: String?
    let body: Body?
}



// MARK: - Body
struct Body: Codable {
    let offers: [Offer]?
    let subcat: [subcats]?
    let banners: [compnyBanners]?
    let details: Details?
    let trending: [TrendingServices]?
    let gallery:[galleryDec]?
    let ratingInfo: RatingInfoDec?
}

// MARK: - RatingInfo
struct RatingInfoDec: Codable
{
    let rating,foodQuality,foodQuantity,packingPres, review: String?
    let orderID: String?

    enum CodingKeys: String, CodingKey
    {
        case rating,foodQuality,foodQuantity,packingPres, review
        case orderID = "orderId"
    }
}


// MARK: - Banner
struct compnyBanners: Codable {
    let url: String?
    let name: String?
}

// MARK: - Gallery
struct galleryDec: Codable
{
    let mediaHttpUrl: String?
}


// MARK: - Details
struct Details: Codable {
    let logo1: String?
    let companyName, address1, email, countryCode: String?
    let phoneNumber, rating, totalRatings, startTime, foodQualityRating, foodQuantityRating, packingPresRating: String?
    let endTime: String?
    let deliveryType, itemType: Int?
    let document: Document?
    let latitude,longitude:Double?
}

// MARK: - Document
struct Document: Codable {
    let aboutUs: String?
    let aboutUsLink: String?
    let facebookLink, gmailLink, twitterLink, linkedinLink: String?
}

// MARK: - Offer
struct Offer: Codable {
    let icon, thumbnail: String?
    let id, name, offerDescription, code: String?
    let discount, validupto: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case offerDescription = "description"
        case code, discount, validupto
    }
}

// MARK: - Subcat
struct subcats: Codable {
    let icon, thumbnail: String?
    let id, name, subcatDescription: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case subcatDescription = "description"
    }
}

// MARK: - Trending
struct TrendingServices: Codable {
    let icon, thumbnail: String?
    let id, name: String?
    let productType: Int?
    let popularity, trendingDescription, categoryID, itemType: String?
    let category: Category?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name, productType, popularity
        case trendingDescription = "description"
        case categoryID = "categoryId"
        case itemType, category
    }
}

// MARK: - Category
struct Category: Codable {
    let name, id: String?
}
