
//

import UIKit

//MARK:- DelegateMethods
protocol ServicesDetailDelegate:class
{
    func trendingServicesDetail(index:Int?)
    func otherServicesDetail(index:Int?)
}

class HomeDashboardVC: CustomController
{
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet var tfLocation: UITextField!
    @IBOutlet weak var viewNewTab: UIView!
    @IBOutlet weak var viewSettingTab: UIView!
    @IBOutlet weak var viewMyCasesTab: UIView!
    @IBOutlet weak var btnDrawer: UIBarButtonItem!
    @IBOutlet var btnCart: UIBarButtonItem!
    
    var viewModel:HomeViewModel?
    var bannersList = [BannerNew]()
    var trendingServicesList = [TrendingServiceNew]()
    var servicesList = [ServiceNew]()
    var isFirstTimeCallDelegate = false
    var selctedCartID = ""
    
    
    public  static var isSideMenueSelected:Bool?
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = DynamicTextHandler.HOMESCREEN_TITLE
        
        AppDefaults.shared.companyID = "89624900-a974-4849-9048-c32d6bed220a"//
        configs.kAppdelegate.set_nav_bar_color()
        Location.shared.InitilizeGPS()
        Location.shared.start_location_updates()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
       // setView()
        showNAV_BAR(controller: self)
        self.getAddressFrom_LatLong(lat: "\(AppDefaults.shared.app_LATITUDE)", long: "\(AppDefaults.shared.app_LONGITUDE)")
        { (adrs) in

            self.tfLocation.text = adrs as String
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Location.shared.stop_location_updates()
    }
    
    
    @IBAction func actionCART(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    //MARK:- Other functions
    func setView()
    {
        //NAvigationBAR
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.viewModel = HomeViewModel.init(Delegate: self, view: self)
        
        let controller = Navigation.GetInstance(of: .CompanyListVC)as! CompanyListVC
        controller.catID = "b21a7c8f-078f-4323-b914-8f59054c4467"
        self.push_To_Controller(from_controller: self, to_Controller: controller)
        
       // getServices()
        
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        tableView.separatorStyle = .none
        viewSearch.dropShadow(radius: 8.0)
        
    }
    
    //MARK:- Actions
    @IBAction func SideMenuAction(_ sender: Any)
    {
        
    }
    
    //MARK:- Hit API
    func getServices()
    {
        self.viewModel?.getHomeServicesApi(completion: { (responce) in
            
            self.selctedCartID = responce.body?.cartCategoryType ?? ""
            kTermsConditions = responce.body?.termsLink ?? ""
            kPrivacy = responce.body?.privacyLink ?? ""
            kAboutUs = responce.body?.aboutUsLink ?? ""
            
            if(self.selctedCartID.count > 0)
            {
                //self.navigationItem.rightBarButtonItem = self.btnCart
                self.addBadge(itemvalue: "1")
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            AppDefaults.shared.currency = responce.body?.currency ?? "Rs."
            
            if let bannerList = responce.body?.banners
            {
                self.bannersList = bannerList
            }
            if let servicesList = responce.body?.services
            {
                self.servicesList = servicesList
                //  init(data:[servicesList])
            }
            
            
            if let trendingList = responce.body?.trendingServices
            {
                self.trendingServicesList = trendingList
            }
            self.tableView.animateReload()
        })
    }
    
    
    //MARK:-Tap gesture for swrevealcontroller
    override func setTapGestureOnSWRevealontroller(view: UIView,controller: UIViewController)
    {
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: self.view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
        let revealController: SWRevealViewController? = revealViewController()
        let tap: UITapGestureRecognizer? = revealController?.tapGestureRecognizer()
        tap?.delegate = controller as? UIGestureRecognizerDelegate
        self.revealViewController().panGestureRecognizer().isEnabled = false
        self.revealViewController().tapGestureRecognizer().isEnabled = true
        view.addGestureRecognizer(tap!)
    }
    
    //MARK:- Actions
    
    //    @IBAction func TabActions(_ sender: Any)
    //    {
    //        switch (sender as AnyObject).tag {
    //        case 0:
    //            viewNewTab.isHidden = false
    //            viewMyCasesTab.isHidden = true
    //            viewSettingTab.isHidden = true
    //            let controller = Navigation.GetInstance(of: .HomeVC) as! HomeVC
    //            let frontVC = revealViewController().frontViewController as? UINavigationController
    //            frontVC?.pushViewController(controller, animated: false)
    //            revealViewController().pushFrontViewController(frontVC, animated: true)
    //            break
    //        case 1:
    //            viewNewTab.isHidden = true
    //            viewMyCasesTab.isHidden = false
    //            viewSettingTab.isHidden = true
    //            break
    //        case 2:
    //            viewNewTab.isHidden = true
    //            viewMyCasesTab.isHidden = true
    //            viewSettingTab.isHidden = false
    //            let controller = Navigation.GetInstance(of: .SettingVC) as! SettingVC
    //            let frontVC = revealViewController().frontViewController as? UINavigationController
    //            frontVC?.pushViewController(controller, animated: false)
    //            revealViewController().pushFrontViewController(frontVC, animated: true)
    //            break
    //        default:
    //            viewNewTab.isHidden = false
    //            viewMyCasesTab.isHidden = true
    //            viewSettingTab.isHidden = true
    //        }
    //    }
    
}

//MARK:- TableView Delegate and DataSource
extension HomeDashboardVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row
        {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeIdentifiers.ShowAdvertismentCell, for: indexPath) as? ShowAdvertismentCell
            {
                cell.bannerList = self.bannersList
                cell.collectionView.reloadData()
                return cell
            }
            break
        case 1:
            //  if let cell = tableView.dequeueReusableCell(withIdentifier: HomeIdentifiers.TrendingServiceListCell, for: indexPath) as? TrendingServiceListCell
            //   {
            // cell.delegateTrendingService = self
            // cell.trendingServicesList = self.trendingServicesList
            //  cell.collectionViewTrendingServiceList.reloadData()
            //     return cell
            //  }
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeIdentifiers.HelpServicesListCell, for: indexPath) as? HelpServicesListCell
            {
                cell.servicesList = self.servicesList
                if self.servicesList.count > 0{
                    if isFirstTimeCallDelegate == false{
                        isFirstTimeCallDelegate = true
                        cell.setView()
                    }
                }
                cell.delegateService = self
                cell.collectionViewHelpServiceList.reloadData()
                return cell
            }
            
            
            break
        case 2:
            
            
//            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeIdentifiers.HelpServicesListCell, for: indexPath) as? HelpServicesListCell
//            {
//                cell.servicesList = self.servicesList
//                if self.servicesList.count > 0{
//                    if isFirstTimeCallDelegate == false{
//                        isFirstTimeCallDelegate = true
//                        cell.setView()
//                    }
//                }
//                cell.delegateService = self
//                cell.collectionViewHelpServiceList.reloadData()
//                return cell
//            }
            break
            //        case 3:
            //            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecentReviewsListCell", for: indexPath) as? RecentReviewsListCell
            //            {
            //                return cell
            //            }
        //            break
        default:
            break
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

//MARK:- TrendingServicesDelegate
extension HomeDashboardVC : ServicesDetailDelegate
{
    //MARK:- DetailOFTrendingServices
    func trendingServicesDetail(index: Int?)
    {
        //        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
        //        self.navigationController?.pushViewController(vc,animated:false)
    }
    
    //MARK:- DetailOFOtherServices
    func otherServicesDetail(index: Int?)
    {
//        self.push_toSubcats(indx:index ?? 0)
        
        if (self.selctedCartID.count == 0)
        {
            self.push_toSubcats(indx:index ?? 0)
        }
        else
        {
            let currentCatID = self.servicesList[index ?? 0].id!
            if (self.selctedCartID.contains(currentCatID))
            {
                self.push_toSubcats(indx:index ?? 0)
            }
            else
            {
                self.AlertMessageWithOkCancelAction(titleStr: "Reminder", messageStr: "Are you sure you want to change the service vendor? Your current cart items will be removed!", Target: self)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.viewModel?.clearCart()
                    }
                }
            }
        }
        
        
    }
    
    func checkCategoryIsSameOrNot(ids:String)->Int
    {
        if(ids.count > 0)
        {
           return 1
        }
        else
        {
           return 1
        }
    }
    
    func push_toSubcats(indx:Int)
    {
       // let hexColor = self.servicesList[indx].colorCode ?? "#F75469"
       // AppDefaults.shared.categoryTheme = self.hexStringToRGB(hexString: hexColor)
      //  Appcolor.update_ThemeColor()
        
        //push to home categories
//        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
//        let catID = self.servicesList[indx].id!
//        controller.categoryID = catID
//        self.push_To_Controller(from_controller: self, to_Controller: controller)
 
        //push to vendor list
        let catID = self.servicesList[indx].id!
        let controller = Navigation.GetInstance(of: .CompanyListVC)as! CompanyListVC
        controller.catID = catID
        controller.tittle = self.servicesList[indx].name ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
}
