
//

import UIKit
import Cosmos


class ServiceDetailVC: BaseUIViewController
{
    //MARK: DETAIL OUTLETS
    @IBOutlet var ivImage: UIImageView!
    @IBOutlet var ivVeg: UIImageView!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var viewRatings: CosmosView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnCart: ButtonWithShadowAndRadious!
    @IBOutlet var lblDetail: UILabel!
    
    @IBOutlet var viewCart: UIView!
    @IBOutlet var lblDuration: UILabel!
   // @IBOutlet var lblTurnAroundTime: UILabel!
    @IBOutlet var lblPricing: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblIncludedServices: UILabel!
    @IBOutlet var lblExcludedServices: UILabel!
    
    @IBOutlet var tiileIncludeService: UILabel!
    @IBOutlet var titleExcludeService: UILabel!
    @IBOutlet var titleDuration: UILabel!
  //  @IBOutlet var titleTuraroudTime: UILabel!
    

    
    var viewModel:ServiceDetail_ViewModel?
    var objData : ServiceDetailResult?
    
    var catID = "0"
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 0
    let cellID = "CellClass_Slots"
    let cellDATE = "CellClass_SlotDates"
    let datePicker = UIDatePicker()
    var slots = NSArray()
    
    
    var cartVendorID = ""
    var companyID = ""
    
    var price = 0
    var serviceType = "1"
    var includeExcludeItems = "Items"
    var itmName = "Details"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        includeExcludeItems = DynamicTextHandler.INCLUDE_EXCLUDE_ITEMS
        
        self.tiileIncludeService.text = "Included \(includeExcludeItems)"
        self.titleExcludeService.text = "Excluded \(includeExcludeItems)"
        self.titleDuration.text = DynamicTextHandler.ITEM_DURATION_TEXT
     //   self.titleTuraroudTime.text = DynamicTextHandler.TURNAROUND_TIME
        
        
        self.title = itmName
        self.viewModel = ServiceDetail_ViewModel.init(Delegate: self, view: self)
        
        self.setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.showNAV_BAR(controller: self)
        self.updateCartBadge(target:self)
        self.viewModel?.getServiceDetails(sId: catID)
    }
    
    
    
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func moveToCartList(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    @IBAction func actionTapOnRatings(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .RatingListVC)as! RatingListVC
        controller.serviceID = objData?.id ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func actionAddToCart(_ sender: Any)
    {
        if (objData?.cart?.count ?? 0 > 0)
        {
            self.viewModel?.deleteCartItem(cartID:objData?.cart ?? "0")
        }
        else
        {
            let str = "\(objData?.price ?? 0)"
            let fprice = Float(str) ?? 0
            let price = Int(fprice) 
            self.checkVendorIsSameForCartVendoer(serviceid:objData?.id ?? "",price: price)
        }
    }
    @IBAction func acnSetFavrt(_ sender: UIButton)
    {
        
        if(self.btnFav.image(for: .normal) == UIImage(named: "fav"))
        {
            self.viewModel?.Set_UNFavorite(serviceId: objData?.favourite ?? "")
        }
        else
        {
            self.viewModel?.Set_Favorite(serviceId: catID)
        }
    }
    
}

extension ServiceDetailVC : ServiceDetailVCDelegate
{
    func getData(data: ServiceDetailResult?)
    {
        self.objData = data
        self.setUI()
    }
}
