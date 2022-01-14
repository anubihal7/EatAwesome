
//

import Foundation

struct EditProfile_ResponseModel: Decodable
{
    var code: Int?
    var status: Int?
    var message : String?
    var data :  EditProfile_Result?
}

struct EditProfile_Result: Decodable
{
    var address : String?
    var country_code :String?
    var created_at :String?
    var device_id :String?
    var device_type :String?
    var email :String?
    var first_name :String?
    var gender : String?
    var jwt_token : String?
    var last_name :String?
    var notify_id : String?
    var password : String?
    var phone_number : String?
    var profile_pic : String?
    var updated_at : String?
    var user_id : Int?
    var user_type : String?
    
    
}
