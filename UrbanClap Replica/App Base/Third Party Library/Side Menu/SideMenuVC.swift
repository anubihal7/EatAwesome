
//

import UIKit
import SDWebImage
import Drift
import SocketIO


class SideMenuVC: BaseUIViewController,UIActionSheetDelegate
{
    
    //MARK: - Outlets
    @IBOutlet var ivBanner: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var viewBG: UIView!
    
    //MARK: - Variables
    var sideMenu:[String]?
    var sideMenuImg:[String]?
    //  var isSideMenuCallFirst:Bool = false
    
    override var prefersStatusBarHidden: Bool
    {
        return false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_statusBar_color(view: self.view)
        //start live tracking
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        SetUI()
        
        // isSideMenuCallFirst = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews()
    {
        userImg.layer.borderWidth = 1.0
        userImg.layer.masksToBounds = false
        userImg.layer.borderColor = UIColor.white.cgColor
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
    }
    
    //MARK:- Other functions
    func SetUI()
    {
        sideMenu = ["Home","Addresses","Favourites","Orders","History","Notifications","Refer & Earn", "Membership"]
        sideMenuImg = ["hom","address","favorite","order","history","notification","support","support"]
        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.tableFooterView = UIView()
        self.userImg.image = UIImage(named:kplaceholderProfile)
        self.userImg.setImage(with: AppDefaults.shared.userImage, placeholder: kplaceholderProfile)
        self.lblUserName.text = AppDefaults.shared.userFirstName + " " + AppDefaults.shared.userLastName
        
        //  self.viewBG.backgroundColor = Appcolor.get_category_theme()
        self.set_statusBar_color(view: self.view)
        lblAddress.text = AppDefaults.shared.userHomeAddress
        
    }
    
    
    @IBAction func actionCrossBtn(_ sender: UIButton)
    {
        
                   showNAV_BAR(controller: self)
                   let controller = Navigation.GetInstance(of: .DashboardHome) as! DashboardHome
                   controller.navigationController?.isNavigationBarHidden = false
                   let frontVC = revealViewController().frontViewController as? UINavigationController
                   frontVC?.pushViewController(controller, animated: false)
                   revealViewController().pushFrontViewController(frontVC, animated: true)
        
    }
    
    //MARK:- IBActions
    @IBAction func Edit(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .EditProfileVC) as! EditProfileVC
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(controller, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    
    @IBAction func acnSettings(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .SettingsVC) as! SettingsVC
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(controller, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    @IBAction func acnLogout(_ sender: Any)
    {
        self.logout_app()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    //Actions
    
    //MARK:- ConnectSocket
    
}

//MARK:- UITableViewDelegate
extension SideMenuVC : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row
        {
        case 0:
            showNAV_BAR(controller: self)
            let controller = Navigation.GetInstance(of: .DashboardHome) as! DashboardHome
            controller.navigationController?.isNavigationBarHidden = false
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
        case 1:
            
            let controller = Navigation.GetInstance(of: .AddressListVC) as! AddressListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
        case 2:
            
            let controller = Navigation.GetInstance(of: .FavoriteListVC) as! FavoriteListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            
            break
            
        case 3:
            
            let controller = Navigation.GetInstance(of: .NewOrderListVC) as! NewOrderListVC
            controller.approach = "orderList"
           // controller.isFromSideMenu = true
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
            
        case 4:
            
            let controller = Navigation.GetInstance(of: .NewOrderListVC) as! NewOrderListVC
            controller.approach = "bookings"
          //  controller.isFromSideMenu = true
            
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
        case 5:
            
            let controller = Navigation.GetInstance(of: .NotificationVC) as! NotificationVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
            
        case 6:
            
            // Drift.showCreateConversation()
            
            //            let controller = Navigation.GetInstance(of: .ChatVC) as! ChatVC
            //           // controller.chatHistoryData  = self.chatHistoryData
            //            let frontVC = revealViewController().frontViewController as? UINavigationController
            //            frontVC?.pushViewController(controller, animated: false)
            //            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            let controller = Navigation.GetInstance(of: .ReferAndEarnVC) as! ReferAndEarnVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
            
            case 7:
                
               
                let controller = Navigation.GetInstance(of: .MembershipVC) as! MembershipVC
                let frontVC = revealViewController().frontViewController as? UINavigationController
                frontVC?.pushViewController(controller, animated: false)
                revealViewController().pushFrontViewController(frontVC, animated: true)
                
                break
            
            
            
        default: break
            
        }
        
    }
    
    func logout_app()
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: kAppName, message: "Do you want to logout?", preferredStyle: .actionSheet)
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            
            self.call_api_logoutDriver(Params : ["":""])
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(actionSheetController, animated: true)
        {
            print("option menu presented")
        }
    }
    
    func call_api_logoutDriver(Params : [String:Any])
    {
        WebService.Shared.PostApi(url: APIAddress.LOGOUT, parameter: Params, Target: self, completionResponse: { (response) in
            
         //   Commands.println(object: response as Any)
            
            if let result = response as? [String:Any]
            {
                // let msg = result["message"] as? String ?? "Null!"
                self.emptyData()
            }
            else
            {
                self.emptyData()
                // self.showAlertMessage(titleStr: kAppName, messageStr: kSomthingWrong)
            }
            
        })
        { (error) in
            //self.showAlertMessage(titleStr: kAppName, messageStr: error)
            self.emptyData()
        }
    }
    
    func emptyData()
    {
        
        Drift.logout()
        AppDefaults.shared.driftLogin = false
        AppDefaults.shared.serviceType = ""
        AppDefaults.shared.userID = "0"
        AppDefaults.shared.userTYPE = 0
        AppDefaults.shared.userName = ""
        AppDefaults.shared.userFirstName = ""
        AppDefaults.shared.userLastName = ""
        AppDefaults.shared.userImage = ""
        AppDefaults.shared.userEmail = ""
        AppDefaults.shared.userJWT_Token = ""
        AppDefaults.shared.firebaseVID = ""
        
        AppDefaults.shared.userPhoneNumber = ""
        AppDefaults.shared.userCountryCode = ""
        AppDefaults.shared.app_LATITUDE = "0.0"
        AppDefaults.shared.app_LONGITUDE = "0.0"
        
        AppDefaults.shared.userAddressType = ""
        AppDefaults.shared.userHomeAddress = ""
        AppDefaults.shared.userAddressID = ""
        AppDefaults.shared.userAddressAdded = ""
        AppDefaults.shared.companyID = ""
        AppDefaults.shared.userDOB = ""
        AppDefaults.shared.CartCompanyID = ""
        AppDefaults.shared.cartCount = 0
        AppDefaults.shared.showSplash = false
        AppDefaults.shared.isVegOnly = false
        AppDefaults.shared.isFirst = false
        AppDefaults.shared.MyReferralCode = ""
        //AppDefaults.shared.firebaseToken = ""
        // AppDefaults.shared.userDeviceToken = ""
        
        let cotntroller = Navigation.GetInstance(of: .LoginWithPhoneVC)as! LoginWithPhoneVC
        self.push_To_Controller(from_controller: self, to_Controller: cotntroller)
        
        // configs.kAppdelegate.setRootViewController()
    }
}

//MARK:- UITableViewDataSource
extension SideMenuVC : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sideMenu!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! SideMenuCell
        cell.lblName.text = sideMenu![indexPath.row]
        cell.lblName.textColor = Appcolor.kTextColorBlack
        cell.imgView.image = UIImage(named: sideMenuImg![indexPath.row])
        return cell
    }
}
