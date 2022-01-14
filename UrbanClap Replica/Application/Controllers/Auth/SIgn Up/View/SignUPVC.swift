
//

import UIKit

class SignUPVC: CustomController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var txtFldAddress: UITextField!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet var txtFldFirstName: UITextField!
    @IBOutlet var txtFldLastName: UITextField!
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var txtFldPhoneNumber: UITextField!
    @IBOutlet var ivMale: UIImageView!
    @IBOutlet var ivFemale: UIImageView!
    
    
    //MARK:- VARIABLES -->
    var viewModel:SignUpVCModel?
    private var selectedPicker: ImagePickers?
    var profileImage : URL?
    var phoneNumber = ""
    var countryCode = ""
    var maleSelected = true
    
    
    enum ImagePickers
    {
        case Profile
        case LicenceFront
        case LicenceBack
        
        init()
        {
            self = .Profile
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setUI()
        self.hideNAV_BAR(controller: self)
    }
    
    override func viewDidLayoutSubviews()
    {
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
    }
    
    
    //MARK:- ACTION CHOOSING GENDER
    @IBAction func ACTION_MALE_CHOOSED(_ sender: Any)
    {
        self.ivMale.image = UIImage(named: "btn_check")
        self.ivFemale.image = UIImage(named: "btn_uncheck")
        self.maleSelected = true
    }
    @IBAction func ACTION_FEMALE_CHOOSED(_ sender: Any)
    {
        self.ivMale.image = UIImage(named: "btn_uncheck")
        self.ivFemale.image = UIImage(named: "btn_check")
        self.maleSelected = false
    }
    
    
    //MARK:- ACTION HANDLE SIGNUP
    @IBAction func ACTION_SIGNUP(_ sender: Any)
    {
        
        var parm = [String:Any]()
        parm["firstName"] = txtFldFirstName.text
        parm["lastName"] =  txtFldLastName.text
        parm["user_type"] =  "1"
        parm["phone_number"] = txtFldPhoneNumber.text
        parm["country_code"] = countryCode
        parm["device_id"] = AppDefaults.shared.userDeviceToken
        parm["device_type"] = "ios"
        parm["address"] = txtFldAddress.text
        parm["notify_id"] = AppDefaults.shared.firebaseToken
        parm["email"] = txtFldEmail.text
        parm["password"] = txtPassword.text
        
        
        var mediaObjs = [[String:Any]]()
        
        if(profileImage != nil)
        {
            var mediaObj = [String:Any]()
            mediaObj["fileType"] = "Image"
            mediaObj["url"] = profileImage
            mediaObjs.insert(mediaObj, at: 0)
        }
        parm["multipartArray"] = mediaObjs
        viewModel?.Validations(obj: parm,confirmPassword: txtConfirmPassword.text,profileImage: profileImage)
    }
    
    
    //MARK:- CHOOSE IMAGE ACTION
    @IBAction func ACTION_ADD_CHOOSE_IMAGE(_ sender: Any)
    {
        selectedPicker = ImagePickers.Profile
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    //MARK:- Other functions
    func setUI()
    {
        self.viewModel = SignUpVCModel.init(Delegate: self, view: self)
    }
    
}

//MARK:- SignUpVCDelegate
extension SignUPVC:SignUpVCDelegate
{
    func Show(msg: String)
    {
        showAlertMessage(titleStr:kAppName , messageStr: msg)
        self.btnSignUp.shake()
    }
}


//MARK:- UIImagePickerDelegate
extension SignUPVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .Profile:
            btnProfile.setBackgroundImage(image, for: UIControl.State.normal)
            
        default: break
            
        }
    }
    
    func selectedImageUrl(url: URL)
    {
        switch selectedPicker
        {
        case .Profile:
            profileImage = url
            
        default: break
        }
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}


//MARK:- UITextFieldDelegate
extension SignUPVC : UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == txtFldFirstName)
        {
            txtFldLastName.becomeFirstResponder()
        }
        if(textField == txtFldLastName)
        {
            txtFldEmail.becomeFirstResponder()
        }
        if(textField == txtFldEmail)
        {
            txtPassword.becomeFirstResponder()
        }
        if(textField == txtPassword)
        {
            txtConfirmPassword.becomeFirstResponder()
        }
        if(textField == txtConfirmPassword)
        {
            textField.resignFirstResponder()
        }
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == " ") && (textField.text?.count)! == 0
        {
            return false
        }
        
        if (textField == txtFldFirstName || textField == txtFldLastName)
        {
            if textField.RestrictMaxCharacter(maxCount: 30, range: range, string: string)
            {
                if (string == " ")
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        if (textField == txtFldFirstName || textField == txtFldLastName)
        {
            let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
            let range = regex.rangeOfFirstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
            return range.length == string.count
        }
        
        if (textField == txtFldEmail)
        {
            return textField.RestrictMaxCharacter(maxCount: 100, range: range, string: string)
        }
        if textField == txtPassword
        {
            return textField.RestrictMaxCharacter(maxCount: 20, range: range, string: string)
        }
        return true
    }
    
    func set_controller_UI()
    {
        self.btnProfile.backgroundColor = Appcolor.kButtonBackgroundColor
        self.btnProfile.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        
        self.txtConfirmPassword.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtPassword.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldFirstName.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldLastName.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldEmail.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldPhoneNumber.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldAddress.backgroundColor = Appcolor.kTextFieldBackgroundColor
        self.txtFldPhoneNumber.text = self.countryCode + self.phoneNumber
        
        self.txtConfirmPassword.makeRound_Boarders_with_leftPadding()
        self.txtPassword.makeRound_Boarders_with_leftPadding()
        self.txtFldFirstName.makeRound_Boarders_with_leftPadding()
        self.txtFldLastName.makeRound_Boarders_with_leftPadding()
        self.txtFldEmail.makeRound_Boarders_with_leftPadding()
        self.txtFldPhoneNumber.makeRound_Boarders_with_leftPadding()
        self.txtFldAddress.makeRound_Boarders_with_leftPadding()
        self.txtFldPhoneNumber.makeRound_Boarders_with_leftPadding()
        
        
    }
}
