//
//
////
//
//
//import Foundation
//
//
//
//struct OrderListModel: Codable
//{
//let code: Int?
//let message: String?
//let body: [OrderData]?
//
//}
//
//// MARK: - Body
//struct OrderData: Codable {
//let orderNo, cookingInstMedia, id, serviceDateTime: String?
//let orderPrice, promoCode, offerPrice, serviceCharges: String?
//let usedLPoints, lPointsPrice, deliveryType, totalOrderPrice: String?
//let addressID, companyID, userID: String?
//let progressStatus, userShow, trackStatus: Int?
//let trackingLatitude, trackingLongitude: JSONNull?
//let cancellationReason, deliveryInstructions, pickupInstructions: String?
//let cookingInstructions: CookingInstructions?
//let tip: String?
//let paymentType: Int?
//let createdAt, updatedAt: String?
//let company: OrderCompany?
//let address: Address1?
//let orderStatus: OrderStatus1?
//let payment: Payment1?
//let suborders: [Suborder1]?
//let cancellable: Bool?
//let totalQuantity: Int?
//let isRated: Bool?
//
//enum CodingKeys: String, CodingKey {
//case orderNo, cookingInstMedia, id, serviceDateTime, orderPrice, promoCode, offerPrice, serviceCharges, usedLPoints
//case lPointsPrice = "LPointsPrice"
//case deliveryType, totalOrderPrice
//case addressID = "addressId"
//case companyID = "companyId"
//case userID = "userId"
//case progressStatus, userShow, trackStatus, trackingLatitude, trackingLongitude, cancellationReason, deliveryInstructions, pickupInstructions, cookingInstructions, tip, paymentType, createdAt, updatedAt, company, address, orderStatus, payment, suborders, cancellable, totalQuantity, isRated
//}
//}
//
//enum AddressType: String, Codable {
//case home = "Home"
//case other = "Other"
//}
//
//enum CookingInstructions: String, Codable {
//case addInstructions = "Add instructions"
//case empty = ""
//case test = "test"
//}
//
//// MARK: - Address
//struct Address1: Codable {
//let addressType: AddressType?
//let id, addressName, houseNo: String?
//let latitude, longitude, town, landmark: String?
//let city: String?
//}
//
//// MARK: - Company
//struct OrderCompany: Codable {
//let logo1: String?
//let companyName: String?
//let latitude, longitude: Double?
//let rating, totalRatings: String?
//}
//
//// MARK: - OrderStatus
//struct OrderStatus1: Codable {
//let statusName: String?
//let status: Int?
//}
//
//// MARK: - Payment
//struct Payment1: Codable {
//let transactionStatus: Int?
//}
//
//// MARK: - Suborder
//struct Suborder1: Codable {
//let id, serviceID, quantity: String?
//let service: Service1?
//
//enum CodingKeys: String, CodingKey {
//case id
//case serviceID = "serviceId"
//case quantity, service
//}
//}
//
//// MARK: - Service
//struct Service1: Codable {
//let icon, thumbnail: String?
//let id, name, serviceDescription: String?
//let productType, price: Int?
//let type, duration: String?
//
//enum CodingKeys: String, CodingKey {
//case icon, thumbnail, id, name
//case serviceDescription = "description"
//case productType, price, type, duration
//}
//}



// MARK: - Welcome
struct OrderListModel: Codable {
    let code: Int?
    let message: String?
    let body: [OrderData]?
}

// MARK: - Body
struct OrderData: Codable {
    let orderNo: String?
   // let cookingInstMedia: String?
    let id, serviceDateTime, orderPrice, promoCode: String?
    let offerPrice, serviceCharges, usedLPoints, lPointsPrice: String?
    let deliveryType, totalOrderPrice, addressID, companyID: String?
    let progressStatus:Int?
   // let userID: String?
  //  let userShow, trackStatus: Int?
   // let trackingLatitude, trackingLongitude: String?
 //   let cancellationReason: String?
 //   let cookingInstructions: String?
 //   let tip: String?
    let paymentType: Int?
    let createdAt, updatedAt: String?
    let company: OrderCompany?
  //  let address: Address1?
    let orderStatus: OrderStatus1?
  //  let payment: Payment1?
    let suborders: [Suborder1]?
    let cancellable: Bool?
    let totalQuantity: Int?
    let isRated: Bool?

    enum CodingKeys: String, CodingKey {
        case orderNo, id, serviceDateTime, orderPrice, promoCode, offerPrice, serviceCharges, usedLPoints
        case lPointsPrice = "LPointsPrice"
        case deliveryType, totalOrderPrice
        case addressID = "addressId"
        case companyID = "companyId"
        case progressStatus
       // case userID = "userId"
        case paymentType, createdAt, updatedAt, company, orderStatus, suborders, cancellable, totalQuantity, isRated
        
       // case trackingLatitude, trackingLongitude,cookingInstMedia, userShow, trackStatus,cancellationReason,cookingInstructions,tip,address,payment
    }
}

// MARK: - Address
struct Address1: Codable {
    let id, addressName, addressType, houseNo: String?
    let latitude, longitude, town, landmark: String?
    let city: String?
}

// MARK: - Company
struct OrderCompany: Codable {
    let logo1: String?
    let companyName: String?
   // let latitude, longitude: Double?
   // let rating, totalRatings: String?
}

// MARK: - OrderStatus
struct OrderStatus1: Codable {
    let statusName: String?
    let status: Int?
}

// MARK: - Payment
struct Payment1: Codable {
    let transactionStatus: Int?
}

// MARK: - Suborder
struct Suborder1: Codable {
   // let id, serviceID, quantity: String?
    let service: Service1?

    enum CodingKeys: String, CodingKey {
       // case id
       // case serviceID = "serviceId"
       // case quantity
        case service
    }
}

// MARK: - Service
struct Service1: Codable {
    let icon, thumbnail: String?
  //  let id, name, serviceDescription: String?
  //  let productType, price: Int?
  //  let type, duration: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail
       // case serviceDescription = "description"
       // case productType, price, type, duration
       // case id, name
    }
}


