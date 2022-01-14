
//

import UIKit
import SVPinView
import FirebaseAuth
import Firebase
import Drift

class CheckOTPVC: CustomController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var lblTitleDESC: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var lblOTP: UILabel!
    @IBOutlet var myPinView: SVPinView!
    @IBOutlet var btnProceed: UIButton!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblTimerDesc: UILabel!
    @IBOutlet var ivLogo: UIImageView!
    
    //MARK:- VARIABLES -->
    var viewModel:LoginWithPhone_ViewModel?
    var otp = ""
    var phoneNumber = ""
    var countryCode = ""
    var push_approach = ""
    var myTimer = Timer()
    var count  = 0
    var count_reverse  = 60
    var userData = SignIn_ResponseModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.btnProceed.isEnabled = false
        
        
        AllUtilies.CameraGallaryPrmission()
        myPinView.style = .box
        myPinView.isContentTypeOneTimeCode = true
      
       
        myPinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
            self.btnProceed.isEnabled = true
            self.otp = pin
        }
        
        myPinView.didChangeCallback = { pin in
            self.btnProceed.isEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.stop_timer()
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func ACTION_RESEND_OTP(_ sender: Any)
    {
        self.myPinView.clearPin()
        self.resend_OTP()
    }
    
    @IBAction func ACTION_MOVEBACK(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func ACTION_PRCEED(_ sender: Any)
    {
        self.hideKeyboard()
        self.stop_timer()
        FirbaseOTPAuth.verify_number_from_firebase(controller: self, verifID: AppDefaults.shared.firebaseVID, OTP: self.otp)
        { (result) in
                        //go to root screen
            Commands.println(object: self.userData)
            AppDefaults.shared.userName = (self.userData.body?.firstName ?? "") + (self.userData.body?.lastName ?? "")
            AppDefaults.shared.userFirstName = self.userData.body?.firstName ?? ""
            AppDefaults.shared.userLastName = self.userData.body?.lastName ?? ""
            AppDefaults.shared.userJWT_Token = self.userData.body?.sessionToken ?? ""
            AppDefaults.shared.userEmail = self.userData.body?.email ?? ""
            AppDefaults.shared.userPhoneNumber = self.userData.body?.phoneNumber ?? ""
            AppDefaults.shared.userCountryCode = self.userData.body?.countryCode ?? ""
            AppDefaults.shared.userID = self.userData.body?.id ?? "0"
            AppDefaults.shared.userImage = self.userData.body?.image ?? ""
            AppDefaults.shared.userDOB = self.userData.body?.dob ?? ""
            AppDefaults.shared.userHomeAddress = self.userData.body?.address ?? ""
            AppDefaults.shared.isFirst = self.userData.body?.isFirst ?? false
            AppDefaults.shared.MyReferralCode = self.userData.body?.referralCode ?? ""
            
            //FOR TRIAL VERSION ONLY
           // AppDefaults.shared.companyID = self.userData.body?.companyID ?? ""
            
            Drift.logout()
            Drift.setup(kDrift_ClientToken)
            Drift.registerUser(AppDefaults.shared.userID, email: AppDefaults.shared.userEmail, userJwt: AppDefaults.shared.userName)
            
         //   AppDefaults.shared.userAddressAdded = self.userData.body?.isAddressAdded ?? ""
            
            
            //check if birthday not added then push to this view otherwise set root view diractly
            if(AppDefaults.shared.userDOB.count == 0)
            {
                let controller = Navigation.GetInstance(of: .GetDOBDetailsVC)as! GetDOBDetailsVC
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            else
            {
                AppDefaults.shared.showSplash = false
                configs.kAppdelegate.setRootViewController()
            }
        }
        
    }
    
    //MARK:- FUNCTION RESEND OTP -->
    func resend_OTP()
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self, phoneNumber: self.countryCode + phoneNumber)
        { (result) in
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                self.showToastSwift(alrtType: .success, msg: "OTP has been sent on given number", title: "")
                self.Handle_Resend_OTP_Start_timer()
                self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                RunLoop.main.add(self.myTimer, forMode: RunLoop.Mode.common)
            }
        }
    }
    
    
    
    //MARK:- UI SETUP -->
    func set_controller_UI()
    {
       // self.viewModel = LoginWithPhone_ViewModel.init(view: self)
      //  self.btnResendOTP.setTitleColor(Appcolor.get_category_theme(), for: UIControl.State.normal)
       // self.lblOTP.textColor = Appcolor.kTextColorBlack
      //  self.lblTimer.textColor = Appcolor.get_category_theme()
      //  self.lblTimerDesc.textColor = Appcolor.kTextColorBlack
      //  self.lblTitleDESC.textColor = Appcolor.kTextColorBlack
        
        
        self.lblTitleDESC.text = "Verification Code"
        self.lblOTP.text = "Please Enter the code that has been sent to you at \(countryCode)-\(phoneNumber)"
        
       // self.ivLogo = colorHandler.set_image_with_color_change(imgName: "otpVerify", imgView: self.ivLogo, colorApproach: Appcolor.kTheme_Color)
    }
    
    
    @objc func startTimer()
    {
        self.count = self.count+1
        self.count_reverse = self.count_reverse-1
        self.lblTimer.text = "\(self.formatSecondsToString(TimeInterval(self.count_reverse)))"
        if (self.count >= 60)
        {
            self.myTimer.invalidate()
            self.stop_timer()
        }
        
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String
    {
        if seconds.isNaN
        {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func Handle_Resend_OTP_Start_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = true
        self.lblTimer.isHidden = false
        self.lblTimerDesc.isHidden = false
    }
    func stop_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = false
        self.lblTimer.isHidden = true
        self.lblTimerDesc.isHidden = true
    }
    
}

