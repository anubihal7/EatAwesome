
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

class FillSurveyVC: UIViewController
{
    
    @IBOutlet var tfName: SkyFloatingLabelTextField!
    @IBOutlet var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet var tfPhone: SkyFloatingLabelTextField!
    @IBOutlet var tfAddress: SkyFloatingLabelTextField!
    
    @IBOutlet var txtViewPurpose: KMPlaceholderTextView!
    @IBOutlet var btnSubmit: ButtonWithShadowAndRadious!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.btnSubmit.backgroundColor = kpurpleTheme
        self.btnSubmit.updateLayerProperties()
        self.txtViewPurpose.layer.cornerRadius = 15
        self.txtViewPurpose.layer.borderColor = UIColor.black.cgColor
        self.txtViewPurpose.layer.borderWidth = 1
        self.txtViewPurpose.layer.masksToBounds = true
        self.tfPhone.text = "\(AppDefaults.shared.userCountryCode)\(AppDefaults.shared.userPhoneNumber)"
        self.tfPhone.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func acnSubmit(_ sender: UIButton)
    {
        if(tfName.text?.count ?? 0 == 0)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter your name", title: kAppName)
        }
        else if(tfName.text?.count ?? 0 < 3)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter valid name", title: kAppName)
        }
        else if(tfEmail.text?.count ?? 0 == 0)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter your email", title: kAppName)
        }
        else if(!(tfEmail.text!.isEmail))
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter valid email", title: kAppName)
        }
        else if(tfPhone.text?.count ?? 0 == 0)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter your phone number", title: kAppName)
        }
        else if(tfPhone.text?.count ?? 0 < 6)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter valid phone number", title: kAppName)
        }
        else if(tfAddress.text?.count ?? 0 == 0)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter your address", title: kAppName)
        }
        else if(tfAddress.text?.count ?? 0 < 6)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter valid address", title: kAppName)
        }
        else if(txtViewPurpose.text?.count ?? 0 == 0)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter your purpose why you are here", title: kAppName)
        }
        else if(txtViewPurpose.text?.count ?? 0 < 20)
        {
            sender.shake()
            self.showToastSwift(alrtType: .statusRed, msg: "Please enter valid purpose", title: kAppName)
        }
        else
        {
            self.view.endEditing(true)
            self.submitSurvey()
        }
    }
    
    
    func submitSurvey()
    {
        //params : name,email,phoneNumber,address,purpose
        let params = ["name":self.tfName.text,"email":self.tfEmail.text,"phoneNumber":self.tfPhone.text,"address":self.tfAddress.text,"purpose":self.txtViewPurpose.text]
        
        WebService.Shared.PostApi(url: APIAddress.FILL_SURVEY, parameter: params as [String : Any], Target: self, completionResponse:
            { (response) in
                
                if let responseData = response as? NSDictionary
                {
                    let code = responseData.value(forKey: "code") as? Int ?? 0
                    let msg = responseData.value(forKey: "message") as? String ?? "success"
                    
                    if (code == 200)
                    {
                        self.showToastSwift(alrtType: .success, msg: msg, title: "Thank you for your time")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else
                    {
                        self.showToastSwift(alrtType: .error, msg: msg, title: kOops)
                    }
                }
                else
                {
                    self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
                }
                
        })
        { (err) in
            self.showToastSwift(alrtType: .error, msg: err, title: kFailed)
        }
    }
    
}
