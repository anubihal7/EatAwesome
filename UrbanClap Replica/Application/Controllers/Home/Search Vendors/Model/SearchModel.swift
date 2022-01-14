
//

import Foundation

// MARK: - Welcome
struct searchResultsVendors: Codable
{
    let code: Int
    let message: String
    let body: searchBodyV
}


// MARK: - Body
struct searchBodyV: Codable
{
    let services: [ServiceVendors]
}

struct ServiceVendors: Codable
{
    let logo1: String?
    let distance: Double?
    let id, companyName, address1: String?
    let startTime, endTime: String?
    let rating: String?
    let coupan: coupnDEC?
    
}




// MARK: - Welcome
struct searchResults: Codable
{
    let code: Int?
    let message: String?
    let body: searchBody
}

// MARK: - Body
struct searchBody: Codable
{
    let services: [Service2]
}


struct coupnDEC: Codable
{
    let code: String?
    let discount: String?
    let validUpto: String?
}



// MARK: - Service
struct Service2: Codable
{
    
    
    let icon, thumbnail: String?
    let id, name, serviceDescription: String?
    let price: Int?
    let type: String?
    let duration: String?
 //   let includedServices: IncludedServices
 //   let excludedServices: ExcludedServices
    let originalPrice: Int?
    let offer: Int?
  //  let offerName: String?
  //  let validUpto: String?
  //  let itemType: String?
  //  let category: Category
  //  let favourite: String?
    let company: Company22
  //  let cart: String?

    enum CodingKeys: String, CodingKey {
        case icon, thumbnail, id, name
        case serviceDescription = "description"
        case price, type, duration, originalPrice, offer
       // case itemType, category, favourite, cart,validUpto, offerName, includedServices, excludedServices
        case company
    }
    
    
    
}




// MARK: - Category
struct Category22: Codable
{
    let icon, thumbnail: String?
    let id: String?
    let name: String?
}

//enum Name: String, Codable
//{
//    case burgers = "Burgers"
//}

// MARK: - Company
struct Company22: Codable
{
    let id: String?
    let companyName: String?
    let rating: String?
}

enum CompanyName: String, Codable
{
    case foodCourt47 = "Food Court 47"
    case northFoodJunction = "North Food Junction"
}

enum ExcludedServices: String, Codable
{
    case empty = ""
    case packingWraps = "Packing Wraps"
}

enum IncludedServices: String, Codable
{
    case bread = "Bread"
    case empty = ""
    case saladsChutneyRedPeppar = "Salads,Chutney,Red-Peppar"
}

enum TypeEnum: String, Codable
{
    case fixed = "Fixed"
}
