
//

import Foundation
import Alamofire

protocol SignInVCDelegate
{
    func Show_results(msg: String)
}

class SignInVC_ViewModel
{
    var delegate : SignInVCDelegate
    var view : UIViewController
    
    init(Delegate : SignInVCDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    func SignIn(Params : [String:Any])
    {
        WebService.Shared.PostApi(url: APIAddress.LOGIN, parameter: Params , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SignIn_ResponseModel.self, from: jsonData)
                
                
                AppDefaults.shared.userName = (model.body?.firstName ?? "") + (model.body?.lastName ?? "")
                AppDefaults.shared.userFirstName = model.body?.firstName ?? ""
                AppDefaults.shared.userLastName = model.body?.lastName ?? ""
                AppDefaults.shared.userJWT_Token = model.body?.sessionToken ?? ""
                AppDefaults.shared.userEmail = model.body?.email ?? ""
                AppDefaults.shared.userPhoneNumber = model.body?.phoneNumber ?? ""
                AppDefaults.shared.userCountryCode = model.body?.countryCode ?? ""
                AppDefaults.shared.userID = model.body?.id ?? "0"
                AppDefaults.shared.userImage = model.body?.image ?? ""
     //           AppDefaults.shared.userHomeAddress = model.body?.address ?? ""
                AppDefaults.shared.isFirst = model.body?.isFirst ?? false
                AppDefaults.shared.MyReferralCode = model.body?.referralCode ?? ""
              //  AppDefaults.shared.userAddressAdded = model.body?.isAddressAdded ?? ""

                //go to root screen
               
                AppDefaults.shared.showSplash = false
                configs.kAppdelegate.setRootViewController()
            }
            catch
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.view.showToastSwift(alrtType: .error, msg: error, title: kOops)
        })
        
    }
    
    
    func Validations(obj: [String:Any],Password:String?)
    {
        guard let password  = obj["password"] as? String, !password.isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show_results(msg: "Password is empty")
            return
        }
        
        SignIn(Params: obj)
        
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


