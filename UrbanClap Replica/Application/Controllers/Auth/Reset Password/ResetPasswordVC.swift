

import UIKit

class ResetPasswordVC: UIViewController,UITextFieldDelegate
{

    //MARK:- OUTLETS -->
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var txtFld_NewPswd: CustomTextField!
    @IBOutlet var txtFldCnfrmPswd: CustomTextField!
    @IBOutlet var btnProceed: CustomButton!
    
    //MARK:- VARIABLES -->
    var phoneNumber = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.hideNAV_BAR(controller: self)

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    @IBAction func ACTION_PROCEED(_ sender: Any)
    {
        Check_Validations()
    }
    
   //MARK:- TEXT FIELD SHOULD RETURN KEY -->
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
   {
       self.view.endEditing(true)
       return true
   }
   
    //MARK:- CHECKING VALIDATIONS -->
    func Check_Validations()
    {
        guard let password  = self.txtFld_NewPswd.text, !password.isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.EnterNewPassword)
            self.btnProceed.shake()
            return
        }
        if(!password.passwordMinLength)
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.PasswordLength8)
            self.btnProceed.shake()
            return
            
        }
        if(!password.checkTextSufficientComplexity())
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.Password_ShudHave_SpclCharacter)
            self.btnProceed.shake()
            return
        }
        
        guard let confirmPassword  = self.txtFldCnfrmPswd.text, !confirmPassword.isEmpty, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.PasswordCnfrmEmpty)
            self.btnProceed.shake()
            return
        }
        if(password != confirmPassword)
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.Passwordmismatch)
            self.btnProceed.shake()
            return
        }
       
        self.call_api_reset_password()
        
    }
    
    
    //MARK:- API CALL RESET PASSWORD -->
    func call_api_reset_password()
    {
        let obj : [String:Any] = ["password":self.txtFldCnfrmPswd.text ?? "","phone_number":phoneNumber]
        WebService.Shared.PostApi(url: APIAddress.RESET_PASSWORD, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SignIn_ResponseModel.self, from: jsonData)
                print(model as Any)
            }
            catch
            {
                self.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
            }
            
        }, completionnilResponse: {(error) in
            self.showAlertMessage(titleStr: kAppName, messageStr: error)
        })
    }
    
    //MARK:- SET UI -->
       func set_controller_UI()
       {
           self.txtFld_NewPswd.backgroundColor = Appcolor.kTextFieldBackgroundColor
           self.txtFldCnfrmPswd.backgroundColor = Appcolor.kTextFieldBackgroundColor
           self.btnProceed.backgroundColor = Appcolor.kButtonBackgroundColor
           self.btnProceed.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
       }
}
