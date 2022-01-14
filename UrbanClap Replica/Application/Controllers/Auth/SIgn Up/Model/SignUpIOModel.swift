
//

import UIKit
import ObjectMapper

//Param
struct SignupInput : Codable
{
    var profileImage : URL?
  //  var licenseFrontImage : URL?
  //  var licenseBackImage : URL?
    var email : String?
    var mobilePhone : String?
    var password : String?
    var latitude : String?
    var longitude : String?
    var roleName : String?
    var countryName : String?
    var companyName : String?
    var companyAccountNumber : String?
    var companyTaxNumber : String?
    var address : String?
    var education : String?
    var firstname : String?
    var lastName : String?
    var hobbies : String?
    var ocupation : String?
    var userId : Int?
    
    init(profileImage : URL?, licenseFrontImage : URL?, licenseBackImage : URL?,email : String?, mobilePhone : String?, password : String?,latitude : String?,longitude : String?,roleName : String?,countryName : String?,companyName : String?,companyAccountNumber : String?,companyTaxNumber : String?,address: String?,education : String?,firstname : String?,lastname:String?,hobbies:String?,ocupation: String?,userId: Int?)
    {
           self.profileImage = profileImage
        //   self.licenseFrontImage = licenseFrontImage
        //   self.licenseBackImage = licenseBackImage
                  self.email = email
                  self.mobilePhone = mobilePhone
                  self.password = password
                  self.latitude = latitude
                  self.longitude = longitude
                  self.roleName = roleName
                  self.countryName = countryName
                  self.companyName = companyName
                  self.companyAccountNumber = companyAccountNumber
                  self.companyTaxNumber = companyTaxNumber
                  self.address = address
                  self.education = education
                  self.firstname = firstname
                  self.lastName = lastname
                  self.hobbies = hobbies
                  self.ocupation = ocupation
                  self.userId = userId
    }
  }

struct UserData: Codable
{
      var email : String?
      var mobilePhone : String?
      var password : String?
      var latitude : String?
      var longitude : String?
      var roleName : String?
      var countryName : String?
      var companyName : String?
      var companyAccountNumber : String?
      var companyTaxNumber : String?
      var address : String?
      var education : String?
      var firstname : String?
      var lastName : String?
      var hobbies : String?
      var ocupation : String?
      var userId : Int?
    
    
    
    init(email : String?, mobilePhone : String?, password : String?,latitude : String?,longitude : String?,roleName : String?,countryName : String?,companyName : String?,companyAccountNumber : String?,companyTaxNumber : String?,address: String?,education : String?,firstname : String?,lastname:String?,hobbies:String?,ocupation: String?,userId: Int?)
    {
           self.email = email
           self.mobilePhone = mobilePhone
           self.password = password
           self.latitude = latitude
           self.longitude = longitude
           self.roleName = roleName
           self.countryName = countryName
           self.companyName = companyName
           self.companyAccountNumber = companyAccountNumber
           self.companyTaxNumber = companyTaxNumber
           self.address = address
           self.education = education
           self.firstname = firstname
           self.lastName = lastname
           self.hobbies = hobbies
           self.ocupation = ocupation
           self.userId = userId
    }
}


//Model

struct SignUpResponse: Codable
{
    var code : Int
    var goodsDeliveryMessage :String
    var recordsFiltered : Int
    var recordsTotal : Int
    var status :String
    //var Data:[Data1]?

    private enum CodingKeys: String, CodingKey
    {
        case code
        case goodsDeliveryMessage
        case recordsFiltered
        case recordsTotal
        case status
    }
}
struct Data1 : Codable
{
    var CountryId :Int?
    var CountryName:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case CountryId
        case CountryName
    }
}




