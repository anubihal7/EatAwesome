

import Foundation

// MARK: - Welcome
struct HomeNew_Response: Codable
{
    let code: Int
    let message: String
    let body: BodyNEW
}

// MARK: - Body
struct BodyNEW: Codable
{
   // let deals: [DealNEW]
    let offers: [OfferNEW]
    let restOffers: [RESTOfferDEC]
   // let banners: [BannerNEW]
    let topPicks, suggested:[TopPickNEW]
    let trending: [TrendingNEW]
    let recentOrder: RecentOrder?
    let completedorder: CompletedorderDEC?
    let cartCompanyType : String?
    let currency : String?
    let detailsFilled :Int?
    let cartCount:Int?
    let deliveryType:Int?
}


// MARK: - Banner
struct BannerNEW: Codable
{
//    let url: String?
//    let name: String?
}


// MARK: - Completedorder
struct CompletedorderDEC: Codable
{
    let empID, companyId, orderID, firstName, lastName: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case empID = "empId"
        case orderID = "orderId"
        case firstName, lastName, image,companyId
    }
}



// MARK: - BestSeller
struct BestSellerNEW: Codable
{
    let logo1: String?
    let id, companyName, address1: String?
    let startTime, endTime: String?
    let rating: String?
    let distance: Double?
    let coupan: CoupanDEC?
    let tags: [String]
    let totalOrders24 : String?
}

// MARK: - Coupan
struct CoupanDEC: Codable {
    let discount, code, validUpto: String?
}

// MARK: - TopPick
struct TopPickNEW: Codable
{
    let icon, thumbnail: String?
    let id, name: String?
    let categoryID: String?
    let validUpto: String?
    let offer: Int?
    let offerName: String?
   // let price, originalPrice: Int?
    let rating, totalRatings: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case categoryID = "categoryId"
        case validUpto, offer, offerName, rating, totalRatings
      //  case price,originalPrice
    }
}

// MARK: - Offer
struct OfferNEW: Codable
{
  let icon, thumbnail: String?
   let id, name, code, discount: String?
   let validupto, offerDescription: String?
   let company: OfferCompany

   enum CodingKeys: String, CodingKey {
       case icon, thumbnail, id, name, code, discount, validupto
       case offerDescription = "description"
       case company
   }
}
struct OfferCompany: Codable {
    let companyName, id: String?
}

// MARK: - Deal
struct DealNEW: Codable
{
    let thumbnail: String?
    let id: String?
    let dealName: String?
    let dealDescription, code, discount, validupto: String?
    let company: CompanyNEW
    let icon: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case thumbnail, id, dealName
        case dealDescription = "description"
        case code, discount, validupto, company, icon, name
    }
}

// MARK: - Company
struct CompanyNEW: Codable
{
    let companyName, id: String?
}

// MARK: - Trending
struct TrendingNEW: Codable
{
   let icon, thumbnail: String?
    let id, name, trendingDescription, popularity: String?
    let categoryID, rating, itemType: String?
    let company: TrendingCompany
    let category: Category

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case trendingDescription = "description"
        case popularity
        case categoryID = "categoryId"
        case rating, itemType, company, category
    }
}
// MARK: - TrendingCompany
struct TrendingCompany: Codable {
    let id: String?
}
// MARK: - Category
struct CategoryNEW: Codable
{
    let name, id: String?
}

// MARK: - RecentOrder
struct RecentOrder: Codable
{
    let orderNo, id: String?
    let progressStatus: Int?
    let totalOrderPrice: String?
    let orderStatus: OrderStatusDEC
}

// MARK: - OrderStatus
struct OrderStatusDEC: Codable {
    let statusName: String?
    let status: Int?
}

// MARK: - RESTOffer
struct RESTOfferDEC: Codable {
  let thumbnail: String?
    let icon: String?
    let discount, name: String?
}
