
//

import Foundation
import Alamofire

protocol EditProfileVCDelegate
{
    func Show_results(msg: String)
    func getData (model : SignIn_ResponseModel)
}

class EditProfile_ViewModel
{
    var delegate : EditProfileVCDelegate
    var view : UIViewController
    
    init(Delegate : EditProfileVCDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getProfile(moveBack:Bool)
    {
        WebService.Shared.GetApi(url: APIAddress.GetProfile , Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SignIn_ResponseModel.self, from: jsonData)
                self.delegate.getData(model: model)
                
                
                AppDefaults.shared.userName = (model.body?.firstName ?? "") + (model.body?.lastName ?? "")
                AppDefaults.shared.userFirstName = model.body?.firstName ?? ""
                AppDefaults.shared.userLastName = model.body?.lastName ?? ""
                AppDefaults.shared.userJWT_Token = model.body?.sessionToken ?? ""
                AppDefaults.shared.userEmail = model.body?.email ?? ""
                AppDefaults.shared.userPhoneNumber = model.body?.phoneNumber ?? ""
                AppDefaults.shared.userCountryCode = model.body?.countryCode ?? ""
                AppDefaults.shared.userID = model.body?.id ?? "0"
                AppDefaults.shared.userImage = model.body?.image ?? ""
                
                if(moveBack == true)
                {
                    self.view.showToastSwift(alrtType: .success, msg: "Profile updated successfully.", title: "")
                    configs.kAppdelegate.setRootViewController()
                }
                
            }
            catch
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    
    
    
    func Validations(obj: [String:Any],profileImage:URL?)
    {
        
        
        guard let firstName = obj["firstName"] as? String,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show_results(msg: "First Name is empty")
            return
        }
        
        guard let lastName = obj["lastName"] as? String,  !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show_results(msg: "Last Name is empty")
            return
        }
        guard let emailAddress  = obj["email"] as? String, !emailAddress.isEmpty, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show_results(msg: "Email address is empty")
            return
        }
        if(!emailAddress.isEmail)
        {
            delegate.Show_results(msg: "Invalid Email address is ")
            return
        }
        guard let addressArr = obj["address"] as? String,  addressArr.count > 0 else
        {
            delegate.Show_results(msg: "Address is empty")
            return
        }
        
        WebService.Shared.uploadDataMulti(mediaType:.Image, url: APIAddress.UPDATE_PROFILE, postdatadictionary: obj, Target: view, completionResponse: { response in
            Commands.println(object: response as Any)
            
            self.getProfile(moveBack: true)
            
            
        }, completionnilResponse: { (errorMsg) in
            self.view.showToastSwift(alrtType: .error, msg: errorMsg, title: kFailed)
        }, completionError: { (error) in
            self.view.showToastSwift(alrtType: .error, msg: error as? String ?? "", title: kFailed)
        })
    }
    
}







