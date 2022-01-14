
//

import Foundation

struct ServiceListModel: Decodable
{
    var code: Int?
    var message : String?
    var body: BodyServices
}

// MARK: - Body
struct BodyServices: Decodable
{
    var services :  [ServiceListResult]?
    var headers :  [subCategoryResult]?
}

struct ServiceListResult: Decodable
{
    
    var icon, thumbnail: String?
    var id, name, serviceDescription: String?
    
    var productType: Int?
    
    var originalPrice: Double?
    var price:Double?
    
    var type, duration, includedServices: String?
    var excludedServices: String?
    var offer: Int?
    var offerName: String?
   // var validUpto: JSONNull?
    var itemType: String?
    var category: subCategoryResult?
    var favourite : String?
    var showSlider : String?
    var cart: Cart?
    var previousValue_Stepper : Int?
    
    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case serviceDescription = "description"
        case productType, type, duration, includedServices, excludedServices, offer, offerName, itemType, category, favourite
        case showSlider
        case previousValue_Stepper
        case cart
        
        case price
     //   case originalPrice
        
      //  case validUpto,
    }
    
}

// MARK: - Cart
struct Cart: Codable
{
    var id, quantity, orderPrice, orderTotalPrice: String?
}


//// MARK: - Cart
//struct CartDec: Decodable
//{
//    let id: String
//}

struct favouriteDEC: Decodable
{
    var id : String?
}

struct subCategoryResult: Decodable
{
    var icon, thumbnail: String?
    var id, name: String?
    var headerDescription: String?
    
    enum CodingKeys: String, CodingKey
    {
        case icon, thumbnail, id, name
        case headerDescription = "description"
    }
    
}
