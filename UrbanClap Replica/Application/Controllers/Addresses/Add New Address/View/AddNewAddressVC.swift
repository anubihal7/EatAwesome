//
//

import UIKit
import GoogleMaps
import TPKeyboardAvoiding

class AddNewAddressVC: CustomController,GMSMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate
{
    @IBOutlet var bottomContraint_BlurView: NSLayoutConstraint!
    
    @IBOutlet var viewSelected2: UIView!
    @IBOutlet var viewSelected3: UIVisualEffectView!
    @IBOutlet var viewSelected: CustomUIView!
    @IBOutlet var scrollVIEW: UIScrollView!
    @IBOutlet var tfHouseNumber: CustomTextField!
    @IBOutlet var tfCity: CustomTextField!
    @IBOutlet var tfAddress: UITextView!
    
    @IBOutlet var ivHome: UIImageView!
    @IBOutlet var ivWork: UIImageView!
    @IBOutlet var ivOther: UIImageView!
    
    
    @IBOutlet var btnAddressType_Home: CustomButton!
    @IBOutlet var btnAddressType_Work: CustomButton!
    @IBOutlet var btnAddressType_Hotel: CustomButton!
    
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var btnBack: UIBarButtonItem!
    @IBOutlet var View_GoogleMap: GMSMapView!
    
    @IBOutlet var btnAdd: CustomButton!
    @IBOutlet var btnSaveAddress: CustomButton!
    
    var addressType = "Home"
    var viewModel:AddNewAddress_ViewModel?
    var lat = ""
    var long = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewModel = AddNewAddress_ViewModel.init(view: self)
        View_GoogleMap.delegate = self
        View_GoogleMap.isMyLocationEnabled = true
        View_GoogleMap.settings.myLocationButton = true
        
        moveMapToCurrentLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func moveMapToCurrentLocation()
    {
        let LAT = Double(AppDefaults.shared.app_LATITUDE) ?? 0.0
        let LONG = Double(AppDefaults.shared.app_LONGITUDE) ?? 0.0
        
        let camera = GMSCameraPosition.camera(withLatitude: LAT, longitude: LONG, zoom: 12.0)
        self.View_GoogleMap.camera = camera
        
        self.getAddressFrom_LatLong(lat: "\(LAT)", long: "\(LONG)")
        { (adrs) in
            
            self.lblLocation.text = adrs as String
            self.tfAddress.text = self.lblLocation.text
        }
    }
    
    override func viewDidLayoutSubviews()
    {
       // self.scrollVIEW.contentSize = CGSize(width: self.scrollVIEW.frame.size.width, height: 650)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       HideDetailsView()
       setUI()
    }
    
    @IBAction func actionMoveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    
    @IBAction func HomeSelected(_ sender: Any)
    {
        self.ivHome.image = UIImage(named: "tick2")
        self.ivWork.image = UIImage(named: "untick")
        self.ivOther.image = UIImage(named: "untick")
        addressType = "Home"
    }
    @IBAction func WorkSelected(_ sender: Any)
    {
        self.ivHome.image = UIImage(named: "untick")
        self.ivWork.image = UIImage(named: "tick2")
        self.ivOther.image = UIImage(named: "untick")
        addressType = "Work"
    }
    @IBAction func HotelSelected(_ sender: Any)
    {
        self.ivHome.image = UIImage(named: "untick")
        self.ivWork.image = UIImage(named: "untick")
        self.ivOther.image = UIImage(named: "tick2")
        addressType = "Other"
    }
    
    
    @IBAction func actionCancelAddressDetails(_ sender: Any)
    {
        self.view.endEditing(true)
        HideDetailsView()
    }
    
    @IBAction func actionAddAddress(_ sender: Any)
    {
        ShowDetailsView()
    }
    
    
    @IBAction func actionSaveFinalAddress(_ sender: UIButton)
    {
        self.AddNewAddress_onServer(sender:sender)
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        
        print(coordinate.latitude as Any)
        print(coordinate.longitude as Any)
        
        self.lat = "\(coordinate.latitude)"
        self.long = "\(coordinate.longitude)"
        
        self.getAddressFrom_LatLong(lat: "\(coordinate.latitude)", long: "\(coordinate.longitude)")
        { (adrs) in
            
            self.lblLocation.text = adrs as String
            self.tfAddress.text = self.lblLocation.text
        }
    }
    
    //MARK:- HANDLING UI
    func setUI()
    {
        self.HomeSelected(UIButton.self)
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
       // self.tfHouseNumber.backgroundColor = Appcolor.kTextFieldBackgroundColor
       // self.tfAddress.backgroundColor = Appcolor.kTextFieldBackgroundColor
      //  self.tfCity.backgroundColor = Appcolor.kTextFieldBackgroundColor
        
      //  self.tfHouseNumber.makeRound_Boarders_with_leftPadding()
        
     //   self.tfCity.makeRound_Boarders_with_leftPadding()
        
        self.btnAdd.backgroundColor = Appcolor.get_category_theme()
        self.btnAdd.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        
        
        self.btnSaveAddress.backgroundColor = Appcolor.get_category_theme()
        self.btnSaveAddress.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        
        self.viewSelected.roundCorners_TOPLEFT_TOPRIGHT(val: 20)
        self.viewSelected2.roundCorners_TOPLEFT_TOPRIGHT(val: 20)
        self.viewSelected3.roundCorners_TOPLEFT_TOPRIGHT(val: 20)
    }
    
    
    
}
