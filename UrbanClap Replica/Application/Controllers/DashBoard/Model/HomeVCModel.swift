// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   var welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable
{
    var code: Int?
    var message: String?
    var body: BodyNew?
    
    // MARK: - Body
    internal struct BodyNew: Codable
    {
        var aboutUsLink:String?
        var privacyLink:String?
        var termsLink:String?
        
        var cartCategoryType:String?
        var currency:String?
        var banners: [BannerNew]?
        var trendingServices: [TrendingServiceNew]?
        var services: [ServiceNew]?
    }
}



// MARK: - Banner
struct BannerNew: Codable
{
    var name: String?
    var url: String?
    
    var code: String?
    var icon: String?
    var id: String?
}

// MARK: - Service
struct ServiceNew: Codable
{
    var id: String?
    var name: String?
    var icon: String?
    var colorCode:String?
}

// MARK: - TrendingService
struct TrendingServiceNew: Codable
{
    var id: String?
    var name: String?
    var icon: String?
}

//MARK:- Customize Service

struct OtherServicesNew
{
    var id: String?
    var name: String?
    var icon: String?
    var isSelected = false
    
    init(dict: [String:Any])
    {
        self.id = dict["id"] as? String
        self.name = dict["name"] as? String
        self.icon = dict["icon"] as? String
        self.isSelected = (dict["isSelected"] != nil)
    }
}


class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        var container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
