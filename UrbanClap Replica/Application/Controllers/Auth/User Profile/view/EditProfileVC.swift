/
//

import UIKit
import TPKeyboardAvoiding
import SDWebImage

class EditProfileVC: CustomController
{
    @IBOutlet var tfDOB: CustomTextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    let scrollTopEdgeInsets:CGFloat = 0//scrollView Top insets size
    // @IBOutlet weak var headerviewHeightConstraint: NSLayoutConstraint!//headerView height constraint
    //  @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var txtemailTop: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet weak var imgViewSelectImage: UIImageView!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var tf_firstName: CustomTextField!
    @IBOutlet var tf_lastName: CustomTextField!
    @IBOutlet var tf_email: CustomTextField!
    @IBOutlet var tf_phoneNumber: CustomTextField!
    @IBOutlet var tf_address: CustomTextField!
    @IBOutlet var ivProfile: UIImageView!
    @IBOutlet weak var btnDrawer: UIBarButtonItem!
    @IBOutlet var btnProceed: CustomButton!
    var viewModel:EditProfile_ViewModel?
    var  localModel : SignIn_ResponseModel?
    private var selectedPicker: ImagePickers?
    var profileImage : URL?
    
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
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNAV_BAR(controller: self)
        
    }
    func setUpView()
    {
        self.viewModel = EditProfile_ViewModel.init(Delegate: self, view: self)
       // self.hideKeyboardWhenTappedAround()
        btnDrawer.target = self.revealViewController()
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        
//        if self.revealViewController()?.panGestureRecognizer() != nil
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
//
//        }
     //   scrollView.delegate = self
     //   scrollView.contentInset = UIEdgeInsets(top: scrollTopEdgeInsets, left: 0, bottom: 0, right: 0)
        
        self.setUI()
        getProfile()
    }
    
    func getProfile() {
        
        viewModel?.getProfile(moveBack: false)
        
    }
    
    
    override func viewDidLayoutSubviews()
    {
        //self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
    }
    
    
    //MARK:- Actions
    @IBAction func btnEditAction(_ sender: Any)
    {
        btnUpdateProfile.isUserInteractionEnabled = true
        self.tf_firstName.isUserInteractionEnabled = true
        self.tf_firstName.isEnabled = true
        self.tf_lastName.isUserInteractionEnabled = true
        self.tf_lastName.isEnabled = true
        self.tf_email.isUserInteractionEnabled = true
        self.tf_email.isEnabled = true
        self.tf_address.isUserInteractionEnabled = true
        self.tf_address.isEnabled = true
        btnProceed.isUserInteractionEnabled = true
        btnProceed.isHidden = false
        btnProceed.backgroundColor = Appcolor.get_category_theme()
        imgViewSelectImage.isHidden = false
        
        self.lblFullName.text = "\(tf_firstName.text ?? "") \(tf_lastName.text ?? "")"
    }
    @IBAction func btnackAction(_ sender: Any) {
        // showNAV_BAR(controller: self)
        self.revealViewController().revealToggle(self)
        
    }
    
    @IBAction func btnBookingsAction(_ sender: Any) {
        let controller = Navigation.GetInstance(of: .NewOrderListVC) as! NewOrderListVC
        controller.approach = "bookings"
        //  controller.isFromSideMenu = false
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    @IBAction func btnOrdersAction(_ sender: Any) {
        let controller = Navigation.GetInstance(of: .NewOrderListVC) as! NewOrderListVC
        controller.approach = "orderList"
        // controller.isFromSideMenu = false
        self.navigationController?.pushViewController(controller, animated: false)
    }
    //MARK:- ACTION PROCEED
    @IBAction func action_proceed(_ sender: Any)
    {
        var parm = [String:Any]()
        parm["firstName"] = tf_firstName.text
        parm["lastName"] =  tf_lastName.text
        parm["address"] = tf_address.text
        parm["email"] = tf_email.text
        parm["maritalStatus"] = localModel?.body?.maritalStatus ?? ""
        
        var mediaObjs = [[String:Any]]()
        
        if(profileImage != nil)
        {
            var mediaObj = [String:Any]()
            mediaObj["fileType"] = "Image"
            mediaObj["url"] = profileImage
            mediaObjs.insert(mediaObj, at: 0)
        }
        parm["profileImage"] = mediaObjs
        viewModel?.Validations(obj: parm,profileImage: profileImage)
        self.lblFullName.text = "\(tf_firstName.text ?? "") \(tf_lastName.text ?? "")"
        
    }
    
    
    @IBAction func updateProfile(_ sender: UIBarButtonItem)
    {
        
        btnUpdateProfile.isUserInteractionEnabled = true
        tf_firstName.isUserInteractionEnabled = true
        tf_lastName.isUserInteractionEnabled = true
        tf_email.isUserInteractionEnabled = true
        tf_address.isUserInteractionEnabled = true
        btnProceed.isUserInteractionEnabled = true
        btnProceed.isHidden = false
        btnProceed.backgroundColor = Appcolor.get_category_theme()
        imgViewSelectImage.isHidden = false
        
        self.lblFullName.text = "\(tf_firstName.text ?? "") \(tf_lastName.text ?? "")"
        
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        selectedPicker = ImagePickers.Profile
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    
    
    func setData() {
        
        if  localModel?.body?.image != nil && localModel?.body?.image != ""
        {
            ivProfile.sd_setImage(with: URL(string: localModel?.body?.image ?? ""), placeholderImage: UIImage(named: "dummyImage"), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.ivProfile.image = image
                self.ivProfile.layer.borderWidth = 1
                self.ivProfile.layer.borderColor = Appcolor.get_category_theme().cgColor
            }
        }
        if localModel?.body?.firstName != nil && localModel?.body?.firstName != "" {
            tf_firstName.text = localModel?.body?.firstName
            
            self.lblFullName.text = "\(localModel?.body?.firstName ?? "") \(localModel?.body?.lastName ?? "")"
        }
        if localModel?.body?.lastName != nil && localModel?.body?.lastName != "" {
            tf_lastName.text = localModel?.body?.lastName
        }
        if  localModel?.body?.email != nil && localModel?.body?.email != ""
        {
            tf_email.text = localModel?.body?.email
            
          //  self.txtemailTop.text = localModel?.body?.email
            
            self.txtemailTop.text = "My loyalty points: \(localModel?.body?.lPoints ?? "0")"
            self.txtemailTop.textColor = Appcolor.get_category_theme()
        }
        if  localModel?.body?.phoneNumber != nil &&  localModel?.body?.phoneNumber != "" {
            tf_phoneNumber.text = localModel?.body?.phoneNumber
        }
        if  localModel?.body?.address != nil && localModel?.body?.address != "" {
            tf_address.text = localModel?.body?.address
            btnLocation.setTitle(localModel?.body?.address, for: .normal)
        }
        self.tfDOB.text = localModel?.body?.anniversaryDate ?? "N/A"
        
        //                   if  localModel?.data?.gender != nil && localModel?.data?.gender  != "" {
        //                   }
        //
    }
    
    //MARK:- HANDLING UI
    func setUI()
    {
        CornerRadius(radius: 55, view: ivProfile)
        //        self.tf_firstName.backgroundColor = Appcolor.kTextColorWhite
        //        self.tf_lastName.backgroundColor = Appcolor.kTextColorWhite
        //        self.tf_email.backgroundColor = Appcolor.kTextColorWhite
        //        self.tf_phoneNumber.backgroundColor = Appcolor.kTextColorWhite
        //        self.tf_address.backgroundColor = Appcolor.kTextColorWhite
        //
                self.tf_firstName.makeRound_Boarders_with_leftPadding()
                self.tf_lastName.makeRound_Boarders_with_leftPadding()
                self.tf_email.makeRound_Boarders_with_leftPadding()
                self.tf_phoneNumber.makeRound_Boarders_with_leftPadding()
                self.tf_address.makeRound_Boarders_with_leftPadding()
                self.tfDOB.makeRound_Boarders_with_leftPadding()
        
        self.btnProceed.backgroundColor = Appcolor.kButtonBackgroundColor
        self.btnProceed.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        
        
        //         addShadowToTextField(textField: self.tf_firstName)
        //         addShadowToTextField(textField: self.tf_lastName)
        //        addShadowToTextField(textField: self.tf_email)
        //        addShadowToTextField(textField: self.tf_phoneNumber)
        //        addShadowToTextField(textField: self.tf_address)
        //        ivMale.setImageColor(color: Appcolor.kText_Color_Black)
        //        ivFemale.setImageColor(color: Appcolor.kText_Color_Black)
        //        txtfieldPadding(textField: self.tf_firstName)
        //         txtfieldPadding(textField: self.tf_lastName)
        //         txtfieldPadding(textField: self.tf_email)
        //         txtfieldPadding(textField: self.tf_phoneNumber)
        //         txtfieldPadding(textField: self.tf_address)
    }
}

//MARK:- EditProDelegate
extension EditProfileVC:EditProfileVCDelegate
{
    func getData(model: SignIn_ResponseModel) {
        localModel = model
        setData()
    }
    
    func Show_results(msg: String)
    {
        showAlertMessage(titleStr:kAppName , messageStr: msg)
    }
    
    
}
//MARK:- UIImagePickerDelegate
extension EditProfileVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .Profile:
            ivProfile.image = image
            
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

//MARK:- ScrollView
extension EditProfileVC:UIScrollViewDelegate
{
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let minHeight:CGFloat = 50
//        let maxHeight:CGFloat = 220+minHeight
//        let yPos = scrollView.contentOffset.y
//        let newHeaderViewHeight = (maxHeight - yPos)-(maxHeight-minHeight)
//        let tempNewHeaderViewHeight = (maxHeight - yPos)-(maxHeight-minHeight)
//        let titleValue = newHeaderViewHeight-minHeight
//
//        //set screen title alpha value
//        if(titleValue > 0){
//            let finalValue = titleValue*100/scrollTopEdgeInsets
//            let alphaValue = finalValue/100
//            //   screenTitleLbl.alpha = 1-alphaValue
//        }
//
//
//        if scrollView.contentOffset.y < 0 {
//            //  topConstrain.constant = scrollView.contentOffset.y
//            btnEdit.isHidden = false
//            btnBack.isHidden = false
//            hideNAV_BAR(controller: self)
//        }
//        else {
//            //  topConstrain.constant = 0
//            btnEdit.isHidden = true
//            btnBack.isHidden = true
//            showNAV_BAR(controller: self)
//        }
//
//    }
}
