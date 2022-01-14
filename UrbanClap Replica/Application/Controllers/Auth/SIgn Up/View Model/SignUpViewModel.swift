
//

import Foundation
import Alamofire

protocol SignUpVCDelegate
{
    func Show(msg: String)
}

class SignUpVCModel
{
    typealias successHandler = (SignUpResponse) -> Void
    var delegate : SignUpVCDelegate
    var view : UIViewController
    
    init(Delegate : SignUpVCDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    func SignUp(Params : [String:Any],completion: @escaping successHandler)
    {
        
        WebService.Shared.uploadDataMulti(mediaType:.Image, url: APIAddress.REGISTER, postdatadictionary: Params, Target: view, completionResponse: { response in
            Commands.println(object: response as Any)
//            if let result = response["result"] as? [String:Any]
//            {
//                UserDefault.userPhone = result["mobilePhone"] as? String ?? ""
//                UserDefault.userId = result["userId"] as? Int ?? 0
//                UserDefault.userName = (result["firstName"] as? String ?? "") + (result["lastName"] as? String ?? "")
//                UserDefault.userType = result["roleName"] as? String ?? ""
//                UserDefault.profileImageUrl = result["profileImageUrl"] as? String ?? ""
//                UserDefault.email = result["email"] as? String ?? ""
//            }
            
            self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: response["goodsDeliveryMessage"] as! String, Target: self.view)
            {
               
            }
            
        }, completionnilResponse: { (errorMsg) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: errorMsg)
        }, completionError: { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error as! String)
        })
        
    }
    
    func MoveToOtp()
    {
       // let obj = Navigation.GetInstance(of: .HomeVC) as! HomeVC
       // view.navigationController?.pushViewController(obj, animated: true)
    }
    
    func Validations(obj: [String:Any],confirmPassword:String?,profileImage:URL?)
    {
        
        guard let profileImgUrl = profileImage,  !profileImgUrl.absoluteString.isEmpty, !profileImgUrl.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show(msg: "Select Profile Image")
            return
        }
        guard let firstName = obj["firstName"] as? String,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show(msg: "First Name is empty")
            return
        }
        
        guard let lastName = obj["lastName"] as? String,  !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show(msg: "Last Name is empty")
            return
        }
        guard let emailAddress  = obj["email"] as? String, !emailAddress.isEmpty, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show(msg: "Email address is empty")
            return
        }
        if(!emailAddress.isEmail)
        {
            delegate.Show(msg: "Invalid Email address is ")
            return
        }
        guard let addressArr = obj["address"] as? String,  addressArr.count > 0 else
        {
            delegate.Show(msg: "Address is empty")
            return
        }
        guard let password  = obj["password"] as? String, !password.isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show(msg: "Password is empty")
            return
        }
        if(!password.passwordMinLength)
        {
            delegate.Show(msg: "Password length should be of 8-20 characters")
            return
            
        }
        if(!password.checkTextSufficientComplexity())
        {
            //"Please enter at least one numeric and one capital letter"
            delegate.Show(msg: "Your password should contain one numeric,one special character,one upper and lower case character")
            return
        }
        
        guard let confirmPassword  = confirmPassword, !confirmPassword.isEmpty, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show(msg: "Confirm password is empty")
            return
        }
        if(password != confirmPassword)
        {
            delegate.Show(msg: "Create password and confirm password does not match")
            return
        }
        
        SignUp(Params: obj) { obj in
            Commands.println(object: obj)
            
            self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "SignUp successfully", Target: self.view)
            {
                let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "SWRevealViewController")
                self.view.navigationController!.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func jsonToString(json: [String:Any]) -> String
    {
        do
        {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            return convertedString ?? ""
        }
        catch let myJSONError
        {
            print(myJSONError)
            return ""
        }
        
    }
}
