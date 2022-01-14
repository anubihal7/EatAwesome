
//

import Foundation

struct CartListModel: Decodable
{
    var code: Int?
    var message : String?
    var body :  BodyDec
}

// MARK: - Body
struct BodyDec: Decodable
{
    var totalQunatity: Int?
   // var sum:Double?
    var data: [CartListResult]
   // var addOns: [AddOn]?
    var lPoints: lPointsDec
}
    
struct CartListResult: Decodable
{
    var id, serviceID, orderPrice, deliveryType: String?
    var quantity, orderTotalPrice, promoCode, companyID: String?
    var userID: String?
    var createdAt, updatedAt: Int?
    var service: ServiceDEC

    enum CodingKeys: String, CodingKey {
        case id
        case serviceID = "serviceId"
        case orderPrice, deliveryType, quantity, orderTotalPrice, promoCode
        case companyID = "companyId"
        case userID = "userId"
        case createdAt, updatedAt, service
    }
}


// MARK: - Service
struct ServiceDEC: Decodable
{
    var addOnIDS: [String]?
    var icon, thumbnail: String?
    var id, name: String?
    var productType: Int?
    var serviceDescription: String?
   // var price: Double?
    var type, duration, includedServices, excludedServices: String?
    var createdAt: String?
    var status: Int?
   // var originalPrice: Double?
  //  var offer: Int?
    var offerName: String?

    enum CodingKeys: String, CodingKey {
        case addOnIDS = "addOnIds"
        case icon, thumbnail, id, name, productType
        case serviceDescription = "description"
        case type, duration, includedServices, excludedServices, createdAt, status, offerName
       // case price
      //  case originalPrice
       // case offer
    }
    
}

// MARK: - AddOn
struct AddOn: Codable {
    var icon, thumbnail: String?
    var id, name: String?
    var productType: Int?
    var addOnDescription: String?
    
    var price: Double?
    
    var type, duration, includedServices, excludedServices: String?
    var createdAt: String?
    var status: Int?
    var originalPrice: Double?
    var offer: Int?
    var offerName: String?
    var addOnIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name, productType
        case addOnDescription = "description"
        case price, type, duration, includedServices, excludedServices, createdAt, status, originalPrice, offer, offerName
        case addOnIDS = "addOnIds"
    }
}


// MARK: - LPoints
struct lPointsDec: Codable
{
    var maxRange,usablePoints, balance: Int?
    var onePointValue : Int?
}






//struct CartListModel: Decodable
//{
//    var code: Int?
//    var message : String?
//    var body :  BodyDec
//}
//
//// MARK: - Body
//struct BodyDec: Decodable
//{
//    var sum, totalQunatity: Int?
//    var data: [CartListResult]
//    var addOns: [AddOn]
//    var lPoints: lPointsDec
//}
//
//struct CartListResult: Decodable
//{
//    var id, serviceID, companyID, userID: String?
//    var createdAt, updatedAt: Int?
//    var service: ServiceDEC
//    var cartCategoryType, cartCategoryCompany: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case serviceID = "serviceId"
//        case companyID = "companyId"
//        case userID = "userId"
//        case createdAt, updatedAt, service, cartCategoryType, cartCategoryCompany
//    }
//}
//
//
//// MARK: - Service
//struct ServiceDEC: Decodable
//{
//    var id, serviceID, orderPrice, deliveryType: String
//    var quantity, orderTotalPrice, promoCode, companyID: String
//    var userID: String
//    var createdAt, updatedAt: Int
//    var service: AddOn
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case serviceID = "serviceId"
//        case orderPrice, deliveryType, quantity, orderTotalPrice, promoCode
//        case companyID = "companyId"
//        case userID = "userId"
//        case createdAt, updatedAt, service
//    }
//}
//
//// MARK: - AddOn
//struct AddOn: Codable {
//    var icon, thumbnail: String?
//    var id, name: String?
//    var productType: Int?
//    var addOnDescription, price, type, duration: String?
//    var includedServices, excludedServices: String?
//    var createdAt, status: Int?
//    var originalPrice: String?
//    var offer: Int?
//    var offerName: String?
//    var addOnIDS: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case icon, thumbnail, id, name, productType
//        case addOnDescription = "description"
//        case price, type, duration, includedServices, excludedServices, createdAt, status, originalPrice, offer, offerName
//        case addOnIDS = "addOnIds"
//    }
//}
//
//
//// MARK: - LPoints
//struct lPointsDec: Codable
//{
//    var maxRange, balance, onePointValue: Int?
//}
//
//// MARK: - Category
//struct CategoryDECC: Codable
//{
//    var id, name, companyID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case companyID = "companyId"
//    }
//}
