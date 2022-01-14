
//

import UIKit
import Lottie
import SocketIO


var chat_HistoryData = [ChatListModel]()


class DashboardHome: CustomController
{
    
    @IBOutlet var CartViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var MenuViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var HeightTrendingView: NSLayoutConstraint!
    @IBOutlet var HeightBestOfferView: NSLayoutConstraint!
    @IBOutlet var HeightTopPicks: NSLayoutConstraint!
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var viewTopPicks: UIView!
    @IBOutlet var viewBestOffers: UIView!
    @IBOutlet var viewTrendings: UIView!
    @IBOutlet var viewCoupons: UIView!
    @IBOutlet var viewMenu: UIView!
    
    @IBOutlet var viewSearch: UIView!
    
    @IBOutlet var btnSideBar: UIButton!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnDeliveryType: UIButton!
    
    @IBOutlet var collTopPicks: UICollectionView!
    @IBOutlet var collBestOffers: UICollectionView!
    @IBOutlet var collTrendings: UICollectionView!
    @IBOutlet var collCoupons: UICollectionView!
    @IBOutlet var collMenu: UICollectionView!
    
    @IBOutlet var tableVendors: UITableView!
    @IBOutlet var vendorsTableHeight: NSLayoutConstraint!
    
    //MARK: RECENT ORDERS BANNER
    @IBOutlet var splashView: UIView!
    @IBOutlet weak var bannerViewCustom: UIView!
    @IBOutlet var animViewRecentOrder: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet var lblOrderAmout: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var rcntOrderBlurView: UIVisualEffectView!
    
    //CartView
    @IBOutlet var viewCart: UIView!
    @IBOutlet var lblCartCount: CustomUILabel!
    
    
    var eventsDATA:[DealNEW]? = nil
    var bannersDATA: [TopPickNEW]? = nil
    var couponDATA: [RESTOfferDEC]? = nil
    var topPicksDATA: [TopPickNEW]? = nil
    var vendorsDATA: [BestSellerNEW]? = nil
    var trendingDATA: [TrendingNEW]? = nil
    var bestSellerDATA: [BestSellerNEW]? = nil
    //  var offersDATA: [OfferNEW]? = nil
    var recentORDER:RecentOrder? = nil
    
    let anim = AnimationView(name: "order_status")
    
    var viewModel:HomeNew_ViewModel?
    var menus = ["Best Seller","Near By Restaurants","View All"]
    
    
    let cellID_TopPicks = "CollectionTopPicks"
    let cellID_BestOffer = "CollectionBanners"
    let cellID_Trending = "CollectionTrendings"
    let cellID_Coupons = "CollectionCoupons"
    let cellID_Menu = "CollectionMenu"
    // let cellID_Vendors = "TableVendors"
    let cellID_Vendors = "VendorsNewTableCell"
    
    var vegOnly = ""
    var showingBestSellerData = true
    var cartVendorID = ""
    
    
    var manager:SocketManager!
    var socketIOClient: SocketIOClient!
    
    
    @IBOutlet weak var heightConstraintMenu: NSLayoutConstraint!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // ConnectToSocket()
        self.hideNAV_BAR(controller: self)
        heightConstraintMenu.constant = 0
        
        Location.shared.InitilizeGPS()
        Location.shared.start_location_updates()
        
        self.addSplash()
        self.setUI()
        
        btnSideBar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.viewModel = HomeNew_ViewModel.init(Delegate: self, view: self)
        
        AllUtilies.CameraGallaryPrmission()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        //  AppDefaults.shared.companyID = "25cbf58b-46ba-4ba2-b25d-8f8f653e9f13"
        AppDefaults.shared.companyID = "89624900-a974-4849-9048-c32d6bed220a"
        self.hideNAV_BAR(controller: self)
        if AppDefaults.shared.showSplash == false
        {
            self.viewModel?.getCategoryList()
        }
        self.checkCartBadge()
        
        checkDeliveryTypeOption()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //socketIOClient.disconnect()
    }
    
    func ConnectToSocket()
    {
        manager = SocketManager(socketURL: URL(string: APIAddress.Socket_Url)!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        // self.StartIndicator(message: kLoading)
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
        }
        
        
        
        
        
        socketIOClient.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
        }
        socketIOClient.connect()
    }
    
    
    @IBAction func acnGotoCart(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func acnFilter(_ sender: Any)
    {
        //        let controller = Navigation.GetInstance(of: .SearchVendorsVC)as! SearchVendorsVC
        //        self.push_To_Controller(from_controller: self, to_Controller: controller)
        
        //        if(self.topPicksDATA?.count ?? 0 > 0)
        //                  {
        // let obj = self.topPicksDATA![indexPath.row]
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        // AppDefaults.shared.companyID = obj.id ?? ""
        controller.comId = AppDefaults.shared.companyID
        controller.categoryID = mainID
        //  controller.Tittle = obj.companyName ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
        // }
        
        
    }
    
    
    
    @IBAction func actionMenu(_ sender: Any) {
        
        let controller = Navigation.GetInstance(of: .CatServiceListVC)as! CatServiceListVC
        controller.vendrCatID = mainID
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    @IBAction func selectDeliveryType(_ sender: UIButton)
    {
        if (AppDefaults.shared.deliveryType == "both" || AppDefaults.shared.deliveryType == "")
        {
            if(btnDeliveryType.tag == 1)
            {
                btnDeliveryType.tag = 0
                AppDefaults.shared.deliveryTypeForBoth = "1"
                self.btnDeliveryType.setBackgroundImage(UIImage(named: "delivery"), for: .normal)
                // self.viewModel?.getCategoryList()
            }
            else if(btnDeliveryType.tag == 0)
            {
                btnDeliveryType.tag = 1
                AppDefaults.shared.deliveryTypeForBoth = "0"
                self.btnDeliveryType.setBackgroundImage(UIImage(named: "pickup"), for: .normal)
                // self.viewModel?.getCategoryList()
            }
        }
        else
        {
            var type = ""
            if(btnDeliveryType.tag == 1)
            {
                type = "Delivery"
            }
            else if(btnDeliveryType.tag == 0)
            {
                type = "Pickup"
            }
            self.showToastSwift(alrtType: .info, msg: "Sorry, \(type) option is not available for now", title: kOops)
        }
    }
    
    @IBAction func acnSearch(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .SearchVendorsVC)as! SearchVendorsVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    @IBAction func acnRecentOrder(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .OrderDetailVC)as! OrderDetailVC
        controller.orderId = self.recentORDER?.id ?? "0"
        controller.orderCompleted = false
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func cellActionTapOnCoupons(_ sender: UIButton)
    {
        let obj = self.couponDATA?[sender.tag]
        let controller = Navigation.GetInstance(of: .CouponDetailsVC)as! CouponDetailsVC
        controller.delegateDetails = self
        controller.OfferImg = obj?.thumbnail ?? ""
        controller.offerName = obj?.name ?? ""
        // controller.offerName = obj?.code ?? ""
        // controller.offerCode = obj?.code ?? ""
        controller.OfferOff = obj?.discount ?? ""
        //  controller.OfferDetails = obj?.bodyDescription ?? ""
        self.present(controller, animated: true, completion: nil)
    }
    
    
}




extension DashboardHome : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (showingBestSellerData == true)
        {
            return self.bestSellerDATA?.count ?? 0
        }
        else
        {
            return self.vendorsDATA?.count ?? 0
        }
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //    {
    //        var cell = UITableViewCell()
    //        let cellN = tableView.dequeueReusableCell(withIdentifier: cellID_Vendors, for: indexPath)as! VendorsNewTableCell
    //
    //
    //        var obj = self.vendorsDATA?[indexPath.row]
    //
    //        if (showingBestSellerData == true)
    //        {
    //            obj = self.bestSellerDATA?[indexPath.row]
    //        }
    //        else
    //        {
    //            obj = self.vendorsDATA?[indexPath.row]
    //        }
    //
    //        cellN.btnTapOnCell.tag = indexPath.row
    //        let img = obj?.logo1 ?? ""
    //        cellN.ivDish.setImage(with: img, placeholder: kplaceholderImage)
    //
    //
    //        cellN.lblName.text! = obj?.companyName ?? "N/A"
    //        cellN.lblAddress.text! = obj?.address1 ?? "N/A"
    //        cellN.lblTime.text = "\(obj?.startTime ?? "Timing :") - \(obj?.endTime ?? "")"
    //        cellN.pastOrders.text = "\(obj?.totalOrders24 ?? "No")"
    //
    //        let rateD = Double(obj?.rating ?? "0.0") ?? 0.0
    //        let rate = CGFloat(rateD)
    //        cellN.viewRate.rating = Double(rate.cleanValue) ?? 0.0
    //
    //        let distanec = CGFloat(obj?.distance ?? 0.0)
    //        let time = self.convertDistanceIntoMinuts(distance: distanec)
    //        cellN.lblDistance.text = time
    //
    //        let offer = obj?.coupan?.discount ?? "0"
    //        if(offer != "0")
    //        {
    //            cellN.offerView.isHidden = false
    //            cellN.lblCurrentOffer.text = "\(offer)% off"
    //        }
    //        else
    //        {
    //            cellN.offerView.isHidden = true
    //        }
    //
    //        let txt = obj?.tags
    //        if(txt?.count ?? 0 > 0)
    //        {
    //            cellN.lblMarquee.text = txt?.joined(separator: ", #")
    //            cellN.lblMarquee.restartLabel()
    //            cellN.viewBottomLeftCorner.isHidden = false
    //        }
    //        else
    //        {
    //            cellN.lblMarquee.text = ""
    //            cellN.viewBottomLeftCorner.isHidden = true
    //        }
    //
    //
    //        cell = cellN
    //        return cell
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        let cellN = tableView.dequeueReusableCell(withIdentifier: "TableVendors", for: indexPath)as! TableVendors
        
        
        var obj = self.vendorsDATA?[indexPath.row]
        
        if (showingBestSellerData == true)
        {
            obj = self.bestSellerDATA?[indexPath.row]
        }
        else
        {
            obj = self.vendorsDATA?[indexPath.row]
        }
        
        let img = obj?.logo1 ?? ""
        cellN.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
        cellN.ivVendor.CornerRadius(radius: 15)
        
        
        cellN.lblName.text! = obj?.companyName ?? "N/A"
        
        
        let rateD = Double(obj?.rating ?? "0.0") ?? 0.0
        let rate = CGFloat(rateD)
        cellN.lblRate.text = "\(Double(rate.cleanValue) ?? 0.0)"
        
        let distanec = CGFloat(obj?.distance ?? 0.0)
        let time = self.convertDistanceIntoMinuts(distance: distanec)
        cellN.lblTime.text = time
        cellN.lblPastOrders.text = "Orders in past 24 hrs: \(obj?.totalOrders24 ?? "0")"
        
        let offer = obj?.coupan?.discount ?? "0"
        if(offer != "0")
        {
            cellN.lblOff.text = "\(offer)% off"
        }
        else
        {
            cellN.lblOff.text = ""
        }
        
        let txt = obj?.tags
        if(txt?.count ?? 0 > 0)
        {
            cellN.lblTags.text = txt?.joined(separator: ", #")
            cellN.lblTags.restartLabel()
        }
        else
        {
            cellN.lblTags.text = ""
        }
        
        cell = cellN
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell:TableVendors = tableView.dequeueReusableCell(withIdentifier: "TableVendors") as! TableVendors
        cell.lblTags.restartLabel()
        
        var obj = self.vendorsDATA?[indexPath.row]
        if (showingBestSellerData == true)
        {
            obj = self.bestSellerDATA?[indexPath.row]
        }
        else
        {
            obj = self.vendorsDATA?[indexPath.row]
        }
        
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        //  AppDefaults.shared.companyID = obj?.id ?? ""
        controller.comId = AppDefaults.shared.companyID
        controller.categoryID = mainID
        controller.Tittle = obj?.companyName ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0
    }
    
    
    func setSwitchButtonForDeliveryType()
    {
        self.checkDeliveryTypeOption()
    }
    
}
