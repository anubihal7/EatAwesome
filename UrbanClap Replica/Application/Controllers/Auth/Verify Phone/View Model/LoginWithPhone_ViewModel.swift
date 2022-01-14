

import Foundation
import Alamofire
import FirebaseAuth
import Firebase



class LoginWithPhone_ViewModel
{
    var view : LoginWithPhoneVC
    var phnNumber = ""
    var cntryCode = ""
    var dataModel : SignIn_ResponseModel?
    
    init(view : LoginWithPhoneVC)
    {
        self.view = view
    }
    
    func SignIn(phoneNumber:String,countryCode:String,cntryWithPlus:String)
    {
        //25cbf58b-46ba-4ba2-b25d-8f8f653e9f11
        self.phnNumber = phoneNumber
        self.cntryCode = countryCode
        
       // self.phnNumber = "9992364445"
      //  self.cntryCode = "91"
        
        //25cbf58b-46ba-4ba2-b25d-8f8f653e9f13
        //let obj : [String:Any] = ["phoneNumber":phoneNumber,"countryCode":countryCode,"deviceToken" :AppDefaults.shared.firebaseToken,"platform" :"ios","companyId":loginMain]
        
        let obj : [String:Any] = ["phoneNumber":self.phnNumber,"countryCode":self.cntryCode,"deviceToken" :AppDefaults.shared.firebaseToken,"platform" :"ios","companyId":loginMain]
        
        
        let simpleURl = APIAddress.LOGIN
      //  let trialURl = APIAddress.LOGIN_TRIAL
        
        
        WebService.Shared.PostApi(url: simpleURl, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SignIn_ResponseModel.self, from: jsonData)
                
                print(model.body?.firstName as Any)
                if (model.code == 200)
                {
                    self.dataModel = model
                    self.view.dataModel = model
                    
                    AppDefaults.shared.userJWT_Token = model.body?.sessionToken ?? ""
                    
                    if(model.body?.isFirst == true)
                    {
                        self.view.ivReferralUnderLine.isHidden = false
                        self.view.heightRefferal.constant = 45
                        self.view.lblLogin.text = "Use referral code"
                        self.view.btnSkip.isHidden = false
                    }
                    else
                    {
                       self.setRoot(userData:model)
                      // self.get_otp_from_firebase(phoneNumber:cntryWithPlus+phoneNumber, userData: model)
                    }
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: kUserNotRegistered, title: kOops)
                }
            }
            catch
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: {(error) in
            
            if (error == "Phone Number does not exist")
            {
                // self.get_otp_from_firebase(phoneNumber:countryCode+phoneNumber, userData: nil)
                self.view.showToastSwift(alrtType: .error, msg: error, title: kOops)
            }
            else
            {
                self.view.showToastSwift(alrtType: .error, msg: error, title: kOops)
            }
            
        })
        
    }
    
    
    
    func applyReferralCode(code:String)
    {
        let obj : [String:Any] = ["referralCode":code,"companyId":loginMain]
        
        WebService.Shared.PostApi(url: APIAddress.USE_REFERRAL_CODE, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.setRoot(userData:self.dataModel)
                }
                else
                {
                    self.view.btnProceed.isUserInteractionEnabled = true

                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.view.btnProceed.isUserInteractionEnabled = true

                self.view.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
            }
        }, completionnilResponse: {(error) in
            self.view.btnProceed.isUserInteractionEnabled = true

            self.view.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
    }
    
    
    func get_otp_from_firebase(phoneNumber:String,userData:SignIn_ResponseModel?)
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self.view, phoneNumber: phoneNumber) { (result) in
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                //go to otp screen
                let controller = Navigation.GetInstance(of: .CheckOTPVC) as! CheckOTPVC
                controller.phoneNumber = self.phnNumber
                controller.countryCode = self.cntryCode
                controller.push_approach = kPush_Approach_from_SignUp
                controller.userData = userData!
                self.view.push_To_Controller(from_controller: self.view, to_Controller: controller)
            }
            
        }
    }
    
    func setRoot(userData:SignIn_ResponseModel!)
    {
        Commands.println(object: userData as Any)
        AppDefaults.shared.userName = (userData?.body?.firstName ?? "") + (userData?.body?.lastName ?? "")
        AppDefaults.shared.userFirstName = userData?.body?.firstName ?? ""
        AppDefaults.shared.userLastName = userData?.body?.lastName ?? ""
        AppDefaults.shared.userJWT_Token = userData?.body?.sessionToken ?? ""
        AppDefaults.shared.userEmail = userData?.body?.email ?? ""
        AppDefaults.shared.userPhoneNumber = userData?.body?.phoneNumber ?? ""
        AppDefaults.shared.userCountryCode = userData?.body?.countryCode ?? ""
        AppDefaults.shared.userID = userData?.body?.id ?? "0"
        AppDefaults.shared.userImage = userData?.body?.image ?? ""
        AppDefaults.shared.userDOB = userData?.body?.dob ?? ""
        AppDefaults.shared.userHomeAddress = userData.body?.address ?? ""
        AppDefaults.shared.isFirst = userData.body?.isFirst ?? false
        AppDefaults.shared.MyReferralCode = userData.body?.referralCode ?? ""
        
        //FOR TRIAL VERSION ONLY
       // AppDefaults.shared.companyID = userData.body?.companyID ?? ""
        
        
        
       // AppDefaults.shared.userAddressAdded = userData?.body?.isAddressAdded ?? ""
        
        
        AppDefaults.shared.showSplash = false
        configs.kAppdelegate.setRootViewController()
    }
    
}

