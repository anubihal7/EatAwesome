
//

import UIKit
import Lottie
import MarqueeLabel
import LabelSwitch



class HomeNewVC: CustomController
{
    //Event Outlets
    @IBOutlet var BirthdayBannerView_Height: NSLayoutConstraint!
    @IBOutlet var rcntOrderBlurView: UIVisualEffectView!
    @IBOutlet var ivEventBG: UIImageView!
    @IBOutlet var restauantView: UIView!
    @IBOutlet var bestSellerView: UIView!
    @IBOutlet var offersView: UIView!
    @IBOutlet var newSegmntBtn: LabelSwitch!
    
    
    @IBOutlet var btnSwitch: UISwitch!
    @IBOutlet var lblVegOnly: UILabel!
    @IBOutlet var lblTopPicks: UILabel!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var SpclEventsCollection: UICollectionView!
    @IBOutlet var bannerCollection: UICollectionView!
    @IBOutlet var topPickesCollection: UICollectionView!
    @IBOutlet var trendingCollection: UICollectionView!
    @IBOutlet var offerCollection: UICollectionView!
    
    @IBOutlet var vendorsTableView: UITableView!
    @IBOutlet var bestSellerTableView: UITableView!
    
    @IBOutlet var BannerView_Height: NSLayoutConstraint!
    @IBOutlet var topPickesView_Height: NSLayoutConstraint!
    @IBOutlet var vendorView_Height: NSLayoutConstraint!
    @IBOutlet var trendingView_Height: NSLayoutConstraint!
    @IBOutlet var bestSellerView_Height: NSLayoutConstraint!
    @IBOutlet var offerView_Height: NSLayoutConstraint!
    
    @IBOutlet var VendorTBL_Height: NSLayoutConstraint!
    @IBOutlet var bestSellerTBL_Height: NSLayoutConstraint!
    
    @IBOutlet var btnViewAll: ButtonWithShadowAndRadious!
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var ivSplashBG: UIImageView!
    @IBOutlet var lblOrderAmout: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    
    //MARK: RECENT ORDERS BANNER
    @IBOutlet weak var bannerViewCustom: UIView!
    @IBOutlet var animViewRecentOrder: UIView!
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    var viewModel:HomeNew_ViewModel?
    let anim = AnimationView(name: "order_status")
    
    var eventsDATA:[DealNEW]? = nil
   // var bannersDATA: [BannerNEW]? = nil
    var restOffersDATA: [RESTOfferDEC]? = nil
    var topPicksDATA: [TopPickNEW]? = nil
    var vendorsDATA: [BestSellerNEW]? = nil
    var trendingDATA: [TrendingNEW]? = nil
    var bestSellerDATA: [BestSellerNEW]? = nil
    var offersDATA: [OfferNEW]? = nil
    var recentORDER:RecentOrder? = nil
    
    var isSkeleton_Events = true
    var isSkeleton_Banners = true
    var isSkeleton_TopPicks = true
    var isSkeleton_Vendors = true
    var isSkeleton_Trending = true
    var isSkeleton_BestSeller = true
    var isSkeleton_Offer = true
    
    var skeletonItems = 2
    
    let cellID_Events = "EventsCollectionCell"
    let cellID_Vendors = "VendorsNewTableCell"
    let cellID_BestSellar = "BestSellerTableCell"
    let cellID_TopPicks = "TopPicksCollcnCell"
    let cellID_offer = "OffersCollecnCell"
    let cellID_Banners = "BannersCollectionCell"
    let cellID_Trending = "TrendingCollcnCell"
    var tittle = "HOME"
    var vegOnly = ""
    
    var cartVendorID = ""
    
    

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
  
        
        hideNAV_BAR(controller: self)
        self.addSplash()
        self.setSwitchButtonForDeliveryType()
        
        
        btnDrawer.target = self.revealViewController()
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.segmentControl.backgroundColor = Appcolor.get_category_theme()
        
        
        self.addBadge(itemvalue: "0")
        
        
        if(AppDefaults.shared.userDOB.count == 0)
        {
            let controller = Navigation.GetInstance(of: .GetDOBDetailsVC)as! GetDOBDetailsVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        
    
       // self.viewModel = HomeNew_ViewModel.init(Delegate: self, view: self)
        
        
        Location.shared.InitilizeGPS()
        Location.shared.start_location_updates()
          
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.navigationController?.isNavigationBarHidden = false
        
        // self.viewModel?.getCategoryList()
        // setCollection_Layout()
        self.setUI()
        self.viewModel?.getCategoryList()
        
        self.setTableLayoutVendors()
        self.setTableLayoutBestSellar()
        self.updateCartBadge(target:self)
        
        self.getAddressFrom_LatLong(lat: "\(AppDefaults.shared.app_LATITUDE)", long: "\(AppDefaults.shared.app_LONGITUDE)")
        { (adrs) in
            
            self.lblLocation.text = adrs as String
        }
     
       
    }
    
//    override func viewDidDisappear(_ animated: Bool)
//    {
//        self.disposeAnimView()
//    }
    
    func addSplash()
    {
        if AppDefaults.shared.showSplash == true
        {
            self.ivSplashBG.isHidden = false
            AppDefaults.shared.showSplash = false
            let controller = Navigation.GetInstance(of: .WelcomeHomeVC)as! WelcomeHomeVC
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: {
                self.ivSplashBG.isHidden = true
                self.showNAV_BAR(controller: self)
            })
        }
        else
        {
            self.ivSplashBG.isHidden = true
            showNAV_BAR(controller: self)
        }
    }
    
    
    
    
    
    @IBAction func searchRestaurants(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .SearchVendorsVC)as! SearchVendorsVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func viewAllRestaurants(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .SeeAllRestaurantsVC)as! SeeAllRestaurantsVC
        controller.discount = ""
        controller.bannersDATA = []
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func actionVEGONLY(_ sender: UISwitch)
    {
        if(sender.isOn == true)
        {
            self.vegOnly = "0"
            AppDefaults.shared.isVegOnly = true
        }
        else
        {
            self.vegOnly = ""
            AppDefaults.shared.isVegOnly = false
        }
        
        self.viewModel?.getCategoryList()
    }
    
    
    
    
    @IBAction func ChooseDeliveryOption(_ sender: UISegmentedControl)
    {
        if(sender.selectedSegmentIndex == 0)
        {
            AppDefaults.shared.deliveryType = "delivery"
            self.viewModel?.getCategoryList()
        }
        else
        {
            AppDefaults.shared.deliveryType = "pickup"
            self.viewModel?.getCategoryList()
        }
    }
    
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func actionGoToCart(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func acnGoToOrderDetails(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .OrderDetailVC)as! OrderDetailVC
        controller.orderId = self.recentORDER?.id ?? "0"
        controller.orderCompleted = false
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    //MARK: HANDLING CELL TAP ACTION VENDORS
    @IBAction func CellAction_TapOnVendors(_ sender: UIButton)
    {
        if(self.vendorsDATA?.count ?? 0 > 0)
        {
            let obj = self.vendorsDATA![sender.tag]
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.comId = obj.id ?? ""
            controller.categoryID = mainID
            controller.Tittle = obj.companyName ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            // self.checkVendorIsSameForCartVendoer(cmpnyID:obj.id ?? "")
        }
    }
    
    //MARK: HANDLING CELL TAP ACTION BEST SELLERS
    @IBAction func CellAction_TapOnBestSellars(_ sender: UIButton)
    {
        if(self.bestSellerDATA?.count ?? 0 > 0)
        {
            let obj = self.bestSellerDATA![sender.tag]
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.comId = obj.id ?? ""
            controller.categoryID = mainID
            controller.Tittle = obj.companyName ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            // self.checkVendorIsSameForCartVendoer(cmpnyID:obj.id ?? "")
        }
    }
    
    @IBAction func cellActionTapOnTopPicks(_ sender: UIButton)
    {
        if(self.topPicksDATA?.count ?? 0 > 0)
        {
            let obj = self.topPicksDATA![sender.tag]
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.comId = obj.id ?? ""
            controller.categoryID = mainID
            controller.Tittle = obj.name ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
    
    //MARK: HANDLING CELL TAP ACTION OFFERS
    @IBAction func CellAction_TapOnOffers(_ sender: UIButton)
    {
        if(self.offersDATA?.count ?? 0 > 0)
        {
            let obj = self.offersDATA![sender.tag]
            let controller = Navigation.GetInstance(of: .CouponDetailsVC)as! CouponDetailsVC
            controller.delegateDetails = self
            controller.OfferImg = obj.icon ?? ""
            controller.offerName = obj.name ?? ""
            controller.offerCode = obj.code ?? ""
            controller.OfferOff = obj.discount ?? ""
            controller.OfferDetails = obj.offerDescription ?? ""
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
}

extension HomeNewVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if(tableView == self.vendorsTableView)
        {
            if isSkeleton_Vendors == true
            {
                return skeletonItems
            }
            else
            {
                return self.vendorsDATA?.count ?? 0
            }
        }
        else
        {
            if isSkeleton_BestSeller == true
            {
                return skeletonItems
            }
            else
            {
                return self.bestSellerDATA?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = UITableViewCell()
        
        
        if(tableView == self.vendorsTableView)
        {
            let cellN = tableView.dequeueReusableCell(withIdentifier: cellID_Vendors, for: indexPath)as! VendorsNewTableCell
            
            if(self.vendorsDATA?.count ?? 0 > 0)
            {
                if let obj = self.vendorsDATA?[indexPath.row]
                {
                    cellN.hideAnimation()
                    
                    cellN.btnTapOnCell.tag = indexPath.row
                    let img = obj.logo1 ?? ""
                    cellN.ivDish.setImage(with: img, placeholder: kplaceholderImage)
                    
                    
                    cellN.lblName.text! = obj.companyName ?? "N/A"
                    cellN.lblAddress.text! = obj.address1 ?? "N/A"
                    cellN.lblTime.text = "\(obj.startTime ?? "Timing :") - \(obj.endTime ?? "")"
                    cellN.pastOrders.text = "\(obj.totalOrders24 ?? "No")"
                    
                  //  cellN.lblRatingas.text = obj.rating ?? "0.0"
                    
                    let rateD = Double(obj.rating ?? "0.0") ?? 0.0
                    let rate = CGFloat(rateD)
                    cellN.viewRate.rating = Double(rate.cleanValue) ?? 0.0
                    
                    let distanec = CGFloat(obj.distance ?? 0.0)
                   // cellN.lblDistance.text = "\(distanec.cleanValue) km"
                    let time = self.convertDistanceIntoMinuts(distance: distanec)
                    cellN.lblDistance.text = time
                    
                    let offer = obj.coupan?.discount ?? "0"
                    if(offer != "0")
                    {
                        cellN.offerView.isHidden = false
                        cellN.lblCurrentOffer.text = "\(offer)% off"
                    }
                    else
                    {
                        cellN.offerView.isHidden = true
                    }
                    
                   // cellN.ivDish.roundCornersTopLEFTBottomLEFT()
                    let txt = obj.tags
                    if(txt.count > 0)
                    {
                       // cellN.lblMarquee.backgroundColor = UIColor.white
                        cellN.lblMarquee.text = txt.joined(separator: ", #")
                        cellN.lblMarquee.restartLabel()
                        cellN.viewBottomLeftCorner.isHidden = false
                    }
                    else
                    {
                        cellN.lblMarquee.text = ""
                        cellN.viewBottomLeftCorner.isHidden = true
                       // cellN.lblMarquee.backgroundColor = UIColor.clear
                    }
                }
                else
                {
                    cellN.showAnimation()
                }
            }
            
            cell = cellN
        }
        else
        {
            let cellN2 = tableView.dequeueReusableCell(withIdentifier: cellID_BestSellar, for: indexPath)as! BestSellerTableCell
            
            if(self.bestSellerDATA?.count ?? 0 > 0)
            {
                if let obj = self.bestSellerDATA?[indexPath.row]
                {
                    cellN2.hideAnimation()
                    
                    cellN2.btnTapOnCell.tag = indexPath.row
                    let img = obj.logo1 ?? ""
                    cellN2.ivDish.setImage(with: img, placeholder: kplaceholderImage)
                    
                    
                    cellN2.lblName.text! = obj.companyName ?? "N/A"
                    cellN2.lblAddress.text! = obj.address1 ?? "N/A"
                    cellN2.lblTime.text = "\(obj.startTime ?? "Timing :") - \(obj.endTime ?? "")"
                    cellN2.lblPastOrders.text = "\(obj.totalOrders24 ?? "No")"
                    
                   // cellN2.lblRating.text = obj.rating ?? "0.0"
                    cellN2.viewRate.rating = Double(obj.rating ?? "0.0") ?? 0.0
                    
                    let distanec = CGFloat(obj.distance ?? 0.0)
                    //cellN2.lblDistance.text = "\(distanec.cleanValue) km"
                    let time = self.convertDistanceIntoMinuts(distance: distanec)
                    cellN2.lblDistance.text = time
                    
                   // cellN2.ivDish.roundCornersTopLEFTBottomLEFT()
                    
                    let txt = obj.tags
                    if(txt.count > 0)
                    {
                       // cellN2.lblMarquee.backgroundColor = UIColor.white
                        cellN2.lblMarquee.text = txt.joined(separator: ", #")
                        
                        cellN2.lblMarquee.restartLabel()
                        cellN2.viewBottomCorner.isHidden = false
                        cellN2.lblMarquee.restartLabel()
                    }
                    else
                    {
                        cellN2.lblMarquee.text = ""
                       // cellN2.lblMarquee.backgroundColor = UIColor.clear
                        cellN2.viewBottomCorner.isHidden = true
                    }
                }
                else
                {
                    cellN2.showAnimation()
                }
            }
            
            cell = cellN2
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView == self.vendorsTableView)
        {
            let cell:VendorsNewTableCell = tableView.dequeueReusableCell(withIdentifier: cellID_Vendors) as! VendorsNewTableCell
            cell.lblMarquee.restartLabel()
        }
        else
        {
            let cell:BestSellerTableCell = tableView.dequeueReusableCell(withIdentifier: cellID_BestSellar) as! BestSellerTableCell
            cell.lblMarquee.restartLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 154.0
    }
    
    
    func setSwitchButtonForDeliveryType()
    {
//        let ls = LabelSwitchConfig(text: "Delivery",
//                              textColor: .white,
//                                   font: UIFont.boldSystemFont(ofSize: 15),
//                                   backgroundColor: Appcolor.get_category_theme())
//
//        let rs = LabelSwitchConfig(text: "Pickup",
//                              textColor: .white,
//                                   font: UIFont.boldSystemFont(ofSize: 15),
//                        backgroundColor: .green)
//
//        // Set the default state of the switch,
//        newSegmntBtn = LabelSwitch(center: .zero, leftConfig: ls, rightConfig: rs)

        // Set the appearance of the circle button
        newSegmntBtn.circleShadow = true
        newSegmntBtn.circleColor = .white

        // Make switch be triggered by tapping on any position in the switch
        newSegmntBtn.fullSizeTapEnabled = true

        // Set the delegate to inform when the switch was triggered
        newSegmntBtn.delegate = self
        
        self.checkDeliveryTypeOption()
    }
    
}

extension HomeNewVC: LabelSwitchDelegate
{
    func switchChangToState(sender: LabelSwitch)
    {
        switch sender.curState
        {
            case .L:
                print("left state")
                AppDefaults.shared.deliveryType = "pickup"
                self.viewModel?.getCategoryList()
            
            case .R:
                print("right state")
                AppDefaults.shared.deliveryType = "delivery"
                self.viewModel?.getCategoryList()
        }
    }
}
