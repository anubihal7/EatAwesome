
//

import UIKit
import KMPlaceholderTextView

class ContactusVC: CustomController,UITextViewDelegate
{
    
    @IBOutlet var tfDetails: KMPlaceholderTextView!
    @IBOutlet var btnSubmit: ButtonWithShadowAndRadious!
    @IBOutlet var btnCall: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideNAV_BAR(controller: self)
        self.setStatusBarColor(view:self.view,color:kpurpleTheme)
        self.btnSubmit.backgroundColor = Appcolor.get_category_theme()
        self.btnSubmit.updateLayerProperties()
        self.tfDetails.layer.cornerRadius = 10
        self.tfDetails.layer.masksToBounds = true
        self.tfDetails.layer.borderColor = Appcolor.get_category_theme().cgColor
        self.tfDetails.layer.borderWidth = 1.0
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    @IBAction func acnSubmit(_ sender: UIButton)
    {
        if(self.tfDetails.text.count == 0)
        {
            self.showToastSwift(alrtType: .statusOrange, msg: "Please write something", title: "")
            sender.shake()
        }
        else
        {
            self.view.endEditing(true)
            self.ContactUS()
        }
    }
    
    @IBAction func acnCall(_ sender: Any)
    {
        if let url = URL(string: "tel://9992364445"),UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
        else
        {
            // add error message here
        }
    }
    
    
    func ContactUS()
    {
        let params = ["email":AppDefaults.shared.userEmail,"query":self.tfDetails.text!] as [String : Any]
        WebService.Shared.PostApi(url: APIAddress.GET_CONTACT_US, parameter: params, Target: self, completionResponse:
            { (response) in
                
                if let responseData = response as? NSDictionary
                {
                    let code = responseData.value(forKey: "code") as? Int ?? 0
                    let msg = responseData.value(forKey: "message") as? String ?? "success"        
                    
                    if (code == 200)
                    {
                        self.moveBACK(controller: self)
                        self.showToastSwift(alrtType: .success, msg: msg, title: "")
                    }
                    else
                    {
                        self.showToastSwift(alrtType: .error, msg: msg, title: "")
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            self.view.endEditing(true)
            return true
        }
        
        return true
    }
}


