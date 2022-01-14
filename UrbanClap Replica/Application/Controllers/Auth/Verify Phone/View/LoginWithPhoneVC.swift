
//

import UIKit
import FirebaseAuth
import Firebase
import CountryPickerView


class LoginWithPhoneVC: CustomController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var btnProceed: UIButton!
    @IBOutlet var ivReferralUnderLine: UIImageView!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var lblLogin: UILabel!
    @IBOutlet var heightRefferal: NSLayoutConstraint!
    @IBOutlet var tfReferral: UITextField!
    @IBOutlet weak var txtFldForCountryCode: CustomTextField!
    @IBOutlet var txtFldPhone: CustomTextField!
    @IBOutlet weak var loginImgView: UIImageView!
    
    //MARK:- VARIABLES -->
    var ACCEPTABLE_CHARACTERS_Phone = "1234567890 "
    let countryPickerView = CountryPickerView()
    var push_approach = ""
    var viewModel:LoginWithPhone_ViewModel?
    
    var dataModel : SignIn_ResponseModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Location.shared.InitilizeGPS()
        Location.shared.start_location_updates()
        
        setUpView()
        
        AllUtilies.CameraGallaryPrmission()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.hideNAV_BAR(controller: self)
    }
    
    func setUpView()
    {
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.hideNAV_BAR(controller: self)
        txtFldPhone.addDoneButtonToKeyboard(target:self,myAction:  #selector(self.doneButtonAction), Title: kDone)
        countryPickerView.delegate = self
        let country = countryPickerView.selectedCountry
        txtFldForCountryCode.text = country.phoneCode
        txtfieldPadding(textField: txtFldPhone)
    }
    
    
    
    @objc func doneButtonAction()
    {
        self.txtFldPhone.resignFirstResponder()
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func SubmitAction(_ sender: UIButton)
    {
        
        if (self.heightRefferal.constant == 45)
        {
            if tfReferral.text!.count == 0
            {
                self.showToastSwift(alrtType: .statusOrange, msg: "Please enter refferal code", title: "")
            }
            else
            {
                btnProceed.isUserInteractionEnabled = false
                self.viewModel?.applyReferralCode(code:self.tfReferral.text ?? "")
            }
        }
        else
        {
            if txtFldPhone.text!.count > 12
            {
                self.showToastSwift(alrtType: .statusOrange, msg: AlertTitles.Phone_digits_exceeded, title: "")
                sender.shake()
            }
            else if txtFldPhone.text!.count == 0
            {
                self.showToastSwift(alrtType: .statusOrange, msg: AlertTitles.Enter_phone_number, title: "")
                sender.shake()
            }
            else if txtFldPhone.text!.count < 7
            {
                self.showToastSwift(alrtType: .statusOrange, msg: AlertTitles.EnterValid_phone_number, title: "")
                sender.shake()
            }
            else
            {
                // checking if number is exist or not in our server side
                let str = self.txtFldForCountryCode.text!//Removing + from country code
                let newCode = "\(str.replacingOccurrences(of: "+", with: ""))"
                self.viewModel?.SignIn(phoneNumber: self.txtFldPhone.text!, countryCode: newCode,cntryWithPlus:self.txtFldForCountryCode.text!)
            }
        }
        
        //  configs.kAppdelegate.setRootViewController()
    }
    
    @IBAction func acnSkip(_ sender: Any)
    {
        self.viewModel?.setRoot(userData: self.viewModel?.dataModel)
       // self.viewModel?.get_otp_from_firebase(phoneNumber: "\(self.txtFldForCountryCode.text!)\(self.txtFldPhone.text!)", userData: dataModel)
    }
    
    
    @IBAction func CountryCode(_ sender: Any)
    {
        countryPickerView.showCountriesList(from: self)
    }
    
    
    @IBAction func strtFreeTrial(_ sender: Any)
    {
        if let url = URL(string: "https://www.cerebruminfotech.com")
        {
            UIApplication.shared.open(url)
        }
        
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
//        {
//            UIApplication.shared.open(URL(string:"comgooglemaps://?center=0.0,0.0&zoom=14&views=traffic&q=0.0,0.0")!, options: [:], completionHandler: nil)
//        }
    }
    
}

extension LoginWithPhoneVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFldPhone
        {
            
            let maxLength = 12
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
            
            //            if (textField.text!.count > 12)
            //            {
            //               return false
            //            }
            //
            //            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_Phone).inverted
            //            let filtered = string.components(separatedBy: cs).joined(separator: "")
            //            return (string == filtered)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

extension LoginWithPhoneVC:CountryPickerViewDelegate
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        let country = countryPickerView.selectedCountry
        txtFldForCountryCode.text = country.phoneCode
    }
}

extension LoginWithPhoneVC
{
    func set_controller_UI()
    {
        self.viewModel = LoginWithPhone_ViewModel.init(view: self)
        // self.txtFldPhone.backgroundColor = Appcolor.kTextColorWhite
        //  self.tfReferral.backgroundColor = Appcolor.kTextColorWhite
        //  self.txtFldForCountryCode.backgroundColor = Appcolor.kTextColorWhite
        // self.btnProceed.backgroundColor = Appcolor.kButtonBackgroundColor
        // self.btnProceed.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        //   addShadowToTextField(textField: txtFldPhone)
        //  addShadowToTextField(textField: tfReferral)
        //  addShadowToTextField(textField: txtFldForCountryCode)
        // txtfieldPadding(textField: txtFldPhone)
        // txtfieldPadding(textField: tfReferral)
        
        
        //  self.loginImgView = colorHandler.set_image_with_color_change(imgName: "SwiftLogo", imgView: self.loginImgView, colorApproach: Appcolor.kTheme_Color)
        
    }
}


