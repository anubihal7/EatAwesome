
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var txtFld_Password: CustomTextField!
    @IBOutlet var btnForgotPassowrd: UIButton!
    @IBOutlet var btnDontHaveAccount: UIButton!
    @IBOutlet var btnProceed: CustomButton!
    
    
    //MARK:- VARIABLES -->
    var viewModel:SignInVC_ViewModel?
    var phoneNumber = ""
    var cntryCode = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.hideNAV_BAR(controller: self)
    }
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func ACTION_FORGOT_PASSWORD(_ sender: Any)
    {
        //Asking Firebase Verification
        self.get_otp_from_firebase()
    }
    
    @IBAction func ACTION_DONT_HAVE_ACOUNT(_ sender: Any)
    {
        let obj = Navigation.GetInstance(of: .SignUPVC) as! SignUPVC
        self.push_To_Controller(from_controller: self, to_Controller: obj)
    }
    
    //MARK:- TEXT FIELD SHOULD RETURN KEY -->
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    
    
    //MARK:- ACTION PROCEED -->
    @IBAction func ACTION_PRCEED(_ sender: Any)
    {
        var parm = [String:Any]()
        parm["country_code"] = self.cntryCode
        parm["phone_number"] = self.phoneNumber
        parm["device_type"] = "ios"
        parm["notify_id"] = AppDefaults.shared.firebaseToken
        parm["password"] = txtFld_Password.text
        parm["device_id"] = AppDefaults.shared.userDeviceToken
        viewModel?.Validations(obj: parm,Password: txtFld_Password.text)
    }
    
    
    func get_otp_from_firebase()
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self, phoneNumber: phoneNumber) { (result) in
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                
                //go to otp screen
                let controller = Navigation.GetInstance(of: .CheckOTPVC) as! CheckOTPVC
                controller.phoneNumber = self.phoneNumber
                controller.countryCode = self.cntryCode
                controller.push_approach = kPush_Approach_from_ForgotPassword
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            
        }
    }
    
    
    //MARK:- OTHER FUNCTIONS -->
    func set_controller_UI()
    {
        self.viewModel = SignInVC_ViewModel.init(Delegate: self, view: self)
        self.txtFld_Password.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.btnProceed.backgroundColor = Appcolor.kButtonBackgroundColor
        self.btnProceed.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        self.btnForgotPassowrd.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        self.btnDontHaveAccount.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        self.lblDesc.textColor = Appcolor.kTextColorBlack
    }
    
}

//MARK:- SignUpVCDelegate
extension SignInVC:SignInVCDelegate
{
    func Show_results(msg: String)
    {
        showAlertMessage(titleStr:kAppName , messageStr: msg)
    }
}
