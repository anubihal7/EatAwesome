
//

import Foundation

struct OrderDetail: Codable {
    let code: Int?
    let message: String?
    let body: OrderBody
}

// MARK: - Body
struct OrderBody: Codable {
    
    let orderNo, id, serviceDateTime, orderPrice,totalOrderPrice: String?
    let promoCode, offerPrice, serviceCharges, usedLPoints: String?
   // let lPointsPrice, addressID, deliveryType: String?
    let companyID, userID: String?
    let progressStatus, trackStatus,paymentType,refundType : Int?
  //  let trackingLatitude, trackingLongitude: String?
   // let cancellationReason, deliveryInstructions, pickupInstructions, cookingInstructions: String?
    
    
    let tip, createdAt, updatedAt: String?
    let address: Address?
    let orderStatus: OrderStatus?
    let company: CompanyDetail?
    let suborders: [Suborder]
    let assignedEmployees: [AssignedEmployee]
    
    
    

    enum CodingKeys: String, CodingKey {
        case orderNo, id, serviceDateTime, orderPrice, promoCode, offerPrice, serviceCharges, usedLPoints
        
        
        
        case progressStatus,paymentType, refundType, trackStatus, tip, createdAt, updatedAt, address, orderStatus, company, suborders, assignedEmployees,totalOrderPrice
          
       // case lPointsPrice = "LPointsPrice"
       // case cancellationReason, deliveryInstructions, pickupInstructions, cookingInstructions
       // case trackingLatitude, trackingLongitude
       // case addressID,deliveryType
       // case addressID = "addressId"
        case companyID = "companyId"
        case userID = "userId"
    }
}

// MARK: - Address
struct Address: Codable
{
    let id, addressName, addressType, houseNo: String?
    let latitude, longitude: String?
   // let city, town, landmark: String?
}

// MARK: - AssignedEmployee
struct AssignedEmployee: Codable {
    let id: String?
    let jobStatus: Int?
    let employee: Employee?
}

// MARK: - Employee
struct Employee: Codable {
    let image: String?
    let id, firstName, lastName, countryCode: String?
    let phoneNumber, rating, totalRatings, totalOrders: String?
}

// MARK: - Company
struct CompanyDetail: Codable {
    let logo1: String?
    let companyName, rating, totalRatings, address1: String?
    let latitude, longitude: Double?
}

//MARK: - OrderStatus
struct OrderStatus: Codable {
    let statusName: String?
    let status: Int?
    let parentStatus: String?
}

// MARK: - Suborder
struct Suborder: Codable
{
    let id, serviceID, quantity: String?
    let service: ServiceDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceID = "serviceId"
        case quantity, service
    }
}

// MARK: - Service
struct ServiceDetail: Codable {
    let icon, thumbnail: String?
    let id, name: String?
    let productType: Int?
    let serviceDescription: String?
  //  let price: Int?
    let type, duration: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name, productType
        case serviceDescription = "description"
        case type, duration
       // case price
    }
}

