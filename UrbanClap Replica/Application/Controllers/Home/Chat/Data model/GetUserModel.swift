
//

import Foundation

struct GetUsersModel
{
    let message: String?
    let code: Int?
    //selectUser for createGroup
    var body1 = [body]()
    
    init(dict: [String:Any]) {
           self.message = dict["message"] as? String
           self.code = dict["code"] as? Int
          
           if let arrGroupMember = dict["body"] as? [[String:Any]]{
               self.body1.removeAll()
               _ = arrGroupMember.map({ (dict) in
                   let model = body.init(dict: dict)
                   self.body1.append(model)
               })
           }

}
// MARK: - body
    struct body
 {
    let connected : Bool?
    let email :String?
    let id : String?
    var selectedUser = false
    let image : String?
    let userName : String?
    var userAleradyAdded = false 
      
init(dict: [String:Any])
  {
   self.connected = dict["connected"] as? Bool
    self.email = dict["email"] as? String
    self.id = dict["id"] as? String
    self.image = dict["image"] as? String
    self.userName = dict["userName"] as? String
    self.selectedUser = (dict["selectedUser"] != nil)
    self.userAleradyAdded = (dict["userAleradyAdded"] != nil)
   }
}

}
