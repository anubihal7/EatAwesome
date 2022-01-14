
//

import UIKit
import AVFoundation


class CheckAvailabilityVC: CustomController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var InstrcViewTop: NSLayoutConstraint!
    @IBOutlet var btnEditAddress: CustomButton!
    @IBOutlet var lblAddressTitle: UILabel!
    @IBOutlet var AddressViewHeight: NSLayoutConstraint!
    @IBOutlet var lblTipTitle: UILabel!
    @IBOutlet var lblTipDesc: UILabel!
    @IBOutlet var ivLoyltySign: UIImageView!
    @IBOutlet var navView: UIView!
    @IBOutlet var btnAddAudio: UIButton!
    @IBOutlet var ivPromo: UIImageView!
    @IBOutlet var lblLoyltyChrgsTittle: UILabel!
    @IBOutlet var lblLoyltyChrges: UILabel!
    @IBOutlet var priceDetailViewHeight: NSLayoutConstraint!
    @IBOutlet var btnUseLoyalty: UIButton!
    @IBOutlet var lblLoyltyInstruction: UILabel!
    @IBOutlet var lblLoyaltyPoints: UILabel!
    @IBOutlet var ivLoyaltyTick: UIImageView!
    @IBOutlet var collectionView_Dates: UICollectionView!
    @IBOutlet var collectionView_Slots: UICollectionView!
    
    @IBOutlet var tableViewInstructions: UITableView!
    
    //Constraints
    @IBOutlet var ConstaintHeight_LoyltiPointView: NSLayoutConstraint!
    @IBOutlet var ConstraintHeight_InstructView: NSLayoutConstraint!
    @IBOutlet var ConstraintHeight_InstructTblView: NSLayoutConstraint!
    @IBOutlet var ConstraintHeight_AddressView: NSLayoutConstraint!
    
    //TIPS
    @IBOutlet var btnTip10: UIButton!
    @IBOutlet var btnTip20: UIButton!
    @IBOutlet var btnTip30: UIButton!
    @IBOutlet var btnTip50: UIButton!
    @IBOutlet var btnCookingInstructions: UIButton!
    @IBOutlet var btnPlayAudio: UIButton!
    
    
    @IBOutlet var lblInstructHeader: UILabel!
    
    @IBOutlet var ivLocation: UIImageView!
    @IBOutlet var lblAddressType: UILabel!
    @IBOutlet var lblAddressName: UILabel!
    @IBOutlet var btnCoupon: UIButton!
    @IBOutlet var btnPayNow: CustomButton!
    @IBOutlet var lblItems: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblFinalPrice: UILabel!
    @IBOutlet var lblAvailDate: UILabel!
    @IBOutlet var lblAvailTime: UILabel!
    @IBOutlet var lblShippingCharges: UILabel!
    @IBOutlet var lblShippingChargesTitle: UILabel!
    
    
    
    var viewModel:CheckAvailability_ViewModel?
    
    var apiData_Slots : SlotsResult?
    var apiDataInstructions : [Instruction]? = nil
   // var myLoaylty:lPointsDec?
    
    var myLoaylty = NSDictionary()
    
    var isSkeleton_Service = false
    var skeletonItems_Service = 0
    let cellID = "CellClass_Slots"
    let cellDATE = "CellClass_SlotDates"
    var slotDates = NSMutableArray()
    
    var merchantKey = "7001862"
    var salt = "hlAIVpWKGy"
    var PayUBaseUrl = "https://test.payu.in"
    
    var selectedIndx = -2
    var selectedLot = ""
    
    var selectedIndxDate = -2
    var selectedDate = ""
    var items = 0
    
    var cpnCODE = ""
    var cpnName = ""
    var finalPRICE = ""
    var originalPRICE = ""
    var discountPRICE = ""
    var finalPriceTOTAL = ""
    var shippingCharges = Float(0.0)
    var totalPriceBeforeOffer = ""
    var isOfferApplied = false
    
    var addrssID = ""
    var orderID = ""
    var payMode = ""
    var tipAmount = Float(0.0)
    var compnyID = ""
    var selectedInstructions = NSMutableArray()
    var useLoyaltypoint = 0
    var myAudioFile:URL?
    var player: AVAudioPlayer?
    var payType = "0"//1-> Online, 2-> Cash
    var loyltiPointBalance = Float(0.0)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.lblAvailDate.text = DynamicTextHandler.CHOOSE_AVAIL_DATE
        self.lblAvailTime.text = DynamicTextHandler.CHOOSE_AVAIL_TIME
        
        self.originalPRICE = self.finalPRICE
        self.collectionView_Slots.setEmptyMessage("Slots not available!")
        self.collectionView_Dates.setEmptyMessage("Dates not available!")
        
        self.viewModel = CheckAvailability_ViewModel.init(Delegate: self, view: self)
        // self.viewModel?.getSlotDates()
        
        self.viewModel?.getOrderInstructions(compID:compnyID)
        self.viewModel?.addDates()
        
        self.btnCookingInstructions.setTitle("Add instructions", for: .normal)
           player?.delegate = self
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func ButtonAction_MoveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    @IBAction func ButtonAction_ChangeAddress(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .ChooseAddressVC) as! ChooseAddressVC
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegateCheckout = self
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func ButtonAction_ApplyCoupn(_ sender: Any)
    {
        if(btnCoupon.titleLabel?.text == "Apply coupon")
        {
            let controller = Navigation.GetInstance(of: .PromocodesVC)as! PromocodesVC
            controller.delegateCart = self
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to remove this coupon?", Target: self)
                   { (actn) in
                       if (actn == KYes)
                       {
                           self.viewModel?.removePromoCode(code:self.cpnCODE)
                       }
                   }
        }
        
    }
    
    
    //MARK: ADD TIPS
    @IBAction func actionAdd10RS(_ sender: UIButton)
    {
        var fprice = Float(self.finalPriceTOTAL)
        if(self.btnTip10.tag == 0)
        {
            self.finalPriceTOTAL = "\((fprice ?? 0.0) - self.tipAmount)"
            fprice = Float(self.finalPriceTOTAL)
            
            self.btnTip10.tag = 1
            self.tipAmount = 10.0
            self.btnTip10.setTitleColor(UIColor.white, for: .normal)
            self.btnTip10.backgroundColor = Appcolor.get_category_theme()
            self.finalPriceTOTAL = "\((fprice ?? 0.0) + self.tipAmount)"
        }
        else if(self.btnTip10.tag == 1)
        {
            self.btnTip10.tag = 0
            self.tipAmount = 0.0
            fprice = Float(self.finalPriceTOTAL)
            self.finalPriceTOTAL = "\((fprice ?? 0) - 10.0)"
            self.btnTip10.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
            self.btnTip10.backgroundColor = UIColor.white
        }
        
        self.btnTip20.tag = 0
        self.btnTip30.tag = 0
        self.btnTip50.tag = 0
        self.btnTip20.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip30.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip50.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip20.backgroundColor = UIColor.white
        self.btnTip30.backgroundColor = UIColor.white
        self.btnTip50.backgroundColor = UIColor.white
        
        self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
        self.setOfferLabelPrice()
    }
    @IBAction func actionAdd20RS(_ sender: UIButton)
    {
        var fprice = Float(self.finalPriceTOTAL)
        if(self.btnTip20.tag == 0)
        {
            self.finalPriceTOTAL = "\((fprice ?? 0.0) - self.tipAmount)"
            fprice = Float(self.finalPriceTOTAL)
            
            self.btnTip20.tag = 1
            self.tipAmount = 20.0
            self.btnTip20.setTitleColor(UIColor.white, for: .normal)
            self.btnTip20.backgroundColor = Appcolor.get_category_theme()
            self.finalPriceTOTAL = "\((fprice ?? 0.0) + self.tipAmount)"
        }
        else if(self.btnTip20.tag == 1)
        {
            self.btnTip20.tag = 0
            self.tipAmount = 0
            fprice = Float(self.finalPriceTOTAL)
            self.finalPriceTOTAL = "\((fprice ?? 0) - 20.0)"
            self.btnTip20.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
            self.btnTip20.backgroundColor = UIColor.white
        }
        
        self.btnTip10.tag = 0
        self.btnTip30.tag = 0
        self.btnTip50.tag = 0
        self.btnTip10.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip30.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip50.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        self.btnTip10.backgroundColor = UIColor.white
        self.btnTip30.backgroundColor = UIColor.white
        self.btnTip50.backgroundColor = UIColor.white
        
        self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
        self.setOfferLabelPrice()
    }
    @IBAction func actionAdd30RS(_ sender: UIButton)
    {
        var fprice = Float(self.finalPriceTOTAL)
        if(self.btnTip30.tag == 0)
        {
            self.finalPriceTOTAL = "\((fprice ?? 0.0) - self.tipAmount)"
            fprice = Float(self.finalPriceTOTAL)
            
            self.btnTip30.tag = 1
            self.tipAmount = 30.0
            self.btnTip30.setTitleColor(UIColor.white, for: .normal)
            self.btnTip30.backgroundColor = Appcolor.get_category_theme()
            
            self.finalPriceTOTAL = "\((fprice ?? 0.0) + self.tipAmount)"
        }
        else if(self.btnTip30.tag == 1)
        {
            self.btnTip30.tag = 0
            self.tipAmount = 0
            
            fprice = Float(self.finalPriceTOTAL)
            self.finalPriceTOTAL = "\((fprice ?? 0) - 30.0)"
            
            self.btnTip30.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
            self.btnTip30.backgroundColor = UIColor.white
        }
        
        self.btnTip10.tag = 0
        self.btnTip20.tag = 0
        self.btnTip50.tag = 0
        self.btnTip10.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip20.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip50.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        self.btnTip10.backgroundColor = UIColor.white
        self.btnTip20.backgroundColor = UIColor.white
        self.btnTip50.backgroundColor = UIColor.white
        
        self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
        self.setOfferLabelPrice()
    }
    @IBAction func actionAdd50RS(_ sender: UIButton)
    {
        var fprice = Float(self.finalPriceTOTAL)
        if(self.btnTip50.tag == 0)
        {
            self.finalPriceTOTAL = "\((fprice ?? 0.0) - self.tipAmount)"
            fprice = Float(self.finalPriceTOTAL)
            
            self.btnTip50.tag = 1
            self.tipAmount = 50.0
            self.btnTip50.setTitleColor(UIColor.white, for: .normal)
            self.btnTip50.backgroundColor = Appcolor.get_category_theme()
            
            self.finalPriceTOTAL = "\((fprice ?? 0.0) + self.tipAmount)"
        }
        else if(self.btnTip50.tag == 1)
        {
            self.btnTip50.tag = 0
            self.tipAmount = 0
            
            fprice = Float(self.finalPriceTOTAL)
            self.finalPriceTOTAL = "\((fprice ?? 0) - 50.0)"
            
            self.btnTip50.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
            self.btnTip50.backgroundColor = UIColor.white
        }
        
        self.btnTip10.tag = 0
        self.btnTip20.tag = 0
        self.btnTip30.tag = 0
        self.btnTip10.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip20.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        self.btnTip30.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        self.btnTip10.backgroundColor = UIColor.white
        self.btnTip20.backgroundColor = UIColor.white
        self.btnTip30.backgroundColor = UIColor.white
        
        self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
        self.setOfferLabelPrice()
    }
    
    
    @IBAction func actionAddCookingInstructions(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .AddCookingInstructions)as! AddCookingInstructions
        controller.delegateInstructions = self
        controller.oldText = self.btnCookingInstructions.titleLabel?.text ?? ""
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func acnAddAudioInstructions(_ sender: Any)
    {
        if(btnAddAudio.titleLabel?.text == "Audio Recorded")
        {
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Do you you want to remove this audio?", Target: self)
            { (actn) in
                if (actn == KYes)
                {
                    self.myAudioFile = nil
                    self.btnAddAudio.setTitleColor(kpinkTheme, for: .normal)
                    self.btnAddAudio.setTitle("Add Audio", for: .normal)
                    self.btnPlayAudio.setBackgroundImage(UIImage(named: "aud"), for: .normal)
                }
            }
        }
        else
        {
            let vc = Navigation.GetInstance(of: .RecordAudioViewController)as! RecordAudioViewController
            vc.delegateAudioRecorder = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func acnPlayAudio(_ sender: Any)
    {
        if(btnPlayAudio.tag == 0)
        {
            btnPlayAudio.tag = 1
            self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordpause"), for: .normal)
            
//            if (self.myAudioFile != nil) {
//           let item = AVPlayerItem(url: self.myAudioFile ?? URL(string: "")!)
//                NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item) }

            self.playSound()
        }
        else if(btnPlayAudio.tag == 1)
        {
            btnPlayAudio.tag = 0
            self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
            self.player?.pause()
        }
    }
    
//    func playerDidFinishPlaying(note: NSNotification) {
//        // Your code here
//        btnPlayAudio.tag = 0
//                 self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
//                 self.player?.pause()
//    }
    
    
    @IBAction func actionUseLoyaltyPoints(_ sender: Any)
    {
        if(self.btnUseLoyalty.tag == 0)
        {
            self.btnUseLoyalty.tag = 1
            self.ivLoyaltyTick.image = UIImage(named: "tick2")
            
            self.useLoyaltypoint = Int("\(self.myLoaylty.value(forKey: "usablePoints") ?? "0")") ?? 0
            
            self.lblLoyltyChrgsTittle.text = "Loyalty points offer"
            
            
            let blnc = Double("\(self.myLoaylty.value(forKey: "onePointValue") ?? "0")") ?? 0.0
            
            self.loyltiPointBalance = Float(Double(self.useLoyaltypoint) * Double(blnc))
            self.lblLoyltyChrges.text = "- \(AppDefaults.shared.currency)\(self.loyltiPointBalance)"
            
            var updatedPrice = (Float(self.finalPRICE) ?? 0) + self.shippingCharges + self.tipAmount
            updatedPrice = updatedPrice - Float(self.loyltiPointBalance)
            self.finalPriceTOTAL = "\(updatedPrice)"
            self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
            
            
        }
        else if(self.btnUseLoyalty.tag == 1)
        {
            self.btnUseLoyalty.tag = 0
            self.ivLoyaltyTick.image = UIImage(named: "untick")
            self.useLoyaltypoint = 0
            self.lblLoyltyChrges.text = ""
            self.lblLoyltyChrgsTittle.text = ""
            self.loyltiPointBalance = 0.0
            
            let updatedPrice = (Float(self.finalPRICE) ?? 0) + self.shippingCharges + self.tipAmount
            self.finalPriceTOTAL = "\(updatedPrice)"
            self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(self.finalPriceTOTAL)"
        }
    }
    
    @IBAction func ButtonAction_PayNow(_ sender: UIButton)
    {
        if (self.selectedDate == "")
        {
            self.showToastSwift(alrtType: .statusOrange, msg: "Please select a suitable date for delivery", title: "")
            sender.shake()
        }
        else if (self.selectedLot == "" || self.selectedLot == "0")
        {
            self.showToastSwift(alrtType: .statusOrange, msg: "Please select a suitable time slot", title: "")
            sender.shake()
        }
        
        else
        {
            if(AppDefaults.shared.deliveryType == "delivery")//Delivery Type Order
            {
                if (self.lblAddressType.text == "Select address" || self.lblAddressName.text == "")
                {
                    self.showToastSwift(alrtType: .statusOrange, msg: "Please select your address to proceed", title: "")
                    sender.shake()
                }
                else
                {
                    ChoosePayOptions()
                }
            }
            else//Pickup Type order
            {
                ChoosePayOptions()
            }
        }
    }
    
    func ChoosePayOptions()
    {
        let serviceDate_time = "\(self.selectedDate) \(self.selectedLot)"
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: kAppName, message: "Choose payment option", preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = Appcolor.get_category_theme()
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Cash On Delivery", style: .default) { action -> Void in
            
            self.payType = "2"
            self.viewModel?.createOrder(addressID: self.addrssID, serviceDATE_TIME: serviceDate_time, orderPRICE: self.finalPriceTOTAL, serviceCHARGE: self.shippingCharges, promoCODE: self.cpnCODE)
        }
        
        let scndAction: UIAlertAction = UIAlertAction(title: "Pay Now", style: .default) { action -> Void in
            self.payType = "1"
            self.viewModel?.createOrder(addressID: self.addrssID, serviceDATE_TIME: serviceDate_time, orderPRICE: self.finalPriceTOTAL, serviceCHARGE: self.shippingCharges, promoCODE: self.cpnCODE)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in}
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(scndAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(actionSheetController, animated: true)
        {
            print("option menu presented")
        }
    }
    
}
extension CheckAvailabilityVC : AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,successfully flag: Bool){
        print("finished delegate")
           btnPlayAudio.tag = 0
            self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
       }
}


extension CheckAvailabilityVC : CheckAvailabilityVCDelegate
{
    func getSlotsResult(data: SlotsResult?)
    {
        if (data != nil)
        {
            self.isSkeleton_Service = false
            self.apiData_Slots = data
            self.collectionView_Slots.reloadData()
            self.collectionView_Slots.setEmptyMessage("")
            self.btnPayNow.isEnabled = true
            self.btnPayNow.alpha = 1.0
            self.btnPayNow.backgroundColor = Appcolor.get_category_theme()
        }
        else
        {
            self.nothingFound(type:"")
        }
    }
    
    
    func nothingFound(type:String)
    {
        self.apiData_Slots = nil
        self.isSkeleton_Service = true
        self.collectionView_Slots.reloadData()
        self.collectionView_Slots.setEmptyMessage("Slots not available!")
        self.btnPayNow.isEnabled = false
        self.btnPayNow.alpha = 0.7
        self.btnPayNow.backgroundColor = Appcolor.kTextColorGray
        
    }
    
    
}


extension CheckAvailabilityVC : UpdateCartAfterOfferApplied_Delegate
{
    func offerAppliedSuccffull()
    {
        self.isOfferApplied = true
        self.ivPromo.image = UIImage(named: "tick2")
        
        self.totalPriceBeforeOffer = "\((Float(self.originalPRICE) ?? 0) + self.shippingCharges + self.tipAmount)"
        self.handleCoupon_Applied()
    }
    
    func getOffPercentage(payableAmount:String,cpDiscount:String,totalAmount:String,cpnCode:String)
    {
        self.cpnCODE = cpnCode
        self.finalPRICE = payableAmount
        self.discountPRICE = totalAmount
        self.cpnName = cpDiscount
        
        let p = (Float(self.finalPRICE) ?? 0)
        let updatedPrice = (p + self.shippingCharges + self.tipAmount)
        self.finalPriceTOTAL = "\(updatedPrice)"
    }
}


extension CheckAvailabilityVC : UpdateViewAfterSuccess_Delegate
{
    func refreshController(approach: String)
    {
        if (approach == "home")
        {
            let controller = Navigation.GetInstance(of: .DashboardHome)as! DashboardHome
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
}

//MARK: GET INSTRUCTIONS
extension CheckAvailabilityVC : UpdateViewAfterInstruction_Delegate
{
    func refreshController(text: String,audioPath:URL)
    {
        
        if(text.count == 0)
        {
            self.btnCookingInstructions.setTitle("Add instructions", for: .normal)
            self.btnCookingInstructions.setTitleColor(kpurpleTheme, for: .normal)
//            if(audioPath.absoluteString == "www.google.com")
//            {
//                //both empty not data
//            }
//            else
//            {
//                self.myAudioFile = audioPath
//                self.btnCookingInstructions.setTitle("Audio File", for: .normal)
//                self.btnPlayAudio.isHidden = false
//                self.btnPlayAudio.tag = 0
//                self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
//            }
        }
        else
        {
            self.btnCookingInstructions.setTitle(text, for: .normal)
            self.btnCookingInstructions.setTitleColor(kpurpleTheme, for: .normal)
//            self.btnPlayAudio.isHidden = true
//            self.btnPlayAudio.tag = 0
//            self.btnPlayAudio.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
        }
    }
}


extension CheckAvailabilityVC : UpdateAddressOnCheckout_Delegate
{
    func goToAddNewAddress()
    {
        let controller = Navigation.GetInstance(of: .AddNewAddressVC) as! AddNewAddressVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func addressFound(addrss:String,type:String,adrssID:String)
    {
        if(adrssID.count > 0)
        {
            
            self.viewModel?.checkAddressCharges(addresID: adrssID, getResult:
                { (result) in
                    
                    self.shippingCharges = Float(result) ?? 0.0
                    let fp = Float(self.finalPRICE) ?? 0.0
                    let updatedPrice = fp + self.shippingCharges + self.tipAmount
                    self.finalPriceTOTAL = "\(updatedPrice)"
                    
                    
                    if(self.isOfferApplied == true)
                    {
                        self.totalPriceBeforeOffer = "\((Float(self.originalPRICE) ?? 0) + (Float(result) ?? 0))"
                        self.setOfferLabel()
                    }
                    
                    
                    self.lblAddressName.text = addrss
                    self.lblAddressType.text = type
                    self.addrssID = adrssID
                    
                    self.lblShippingCharges.text = "\(AppDefaults.shared.currency)\(result)"
                    self.lblFinalPrice.text = "\(AppDefaults.shared.currency)\(updatedPrice)"
                    
                    if (self.lblAddressType.text == "" || self.lblAddressName.text == "")
                    {
                        self.lblAddressType.text = "Select address"
                        self.lblAddressName.text = ""
                    }
                    
                    if (type == "Home")
                    {
                        self.ivLocation.image = UIImage(named:"home")
                    }
                    else if (type == "Work")
                    {
                        self.ivLocation.image = UIImage(named:"work")
                    }
                    else
                    {
                        self.ivLocation.image = UIImage(named:"other")
                    }
                    
            })
        }
        else
        {
            // self.showToastSwift(alrtType: .error, msg: "Address ID not found", title: kOops)
        }
    }
    
}

extension CheckAvailabilityVC : getAudioProtocol
{
    func getFilePathAudio(fileURL: URL)
    {
        self.myAudioFile = fileURL
        self.btnAddAudio.setTitle("Audio Recorded", for: .normal)
        self.btnAddAudio.setTitleColor(kpurpleTheme, for: .normal)
        
    }
}


