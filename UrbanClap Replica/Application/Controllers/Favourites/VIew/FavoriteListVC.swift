//
/
//

import UIKit

class FavoriteListVC: CustomController
{
    
    
    @IBOutlet var viewNac: UIView!
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var favTableView: UITableView!
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 4
    var apiData : [FavoriteListResult]?
    let cellIDs = "CellClass_FavList"
    var viewModel:FavoriteList_ViewModel?
    
    var catID =  "0"
    var subCatID =  "0"
    var selctdIDS = [String]()
    var dynamicDurationText = "Duration"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewNac.backgroundColor = kpurpleTheme
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
        self.dynamicDurationText = DynamicTextHandler.ITEM_DURATION_TEXT
        btnDrawer.target = self.revealViewController()
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        
        self.viewModel = FavoriteList_ViewModel.init(Delegate: self, view: self)
        
        
        
        
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
       // self.moveBACK(controller: self)
   self.revealViewController().revealToggle(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.viewModel?.getFavList()
        hideNAV_BAR(controller: self)

    }
    
    @IBAction func cellAction_RemoveFav(_ sender: UIButton)
    {
        let obj = apiData![sender.tag]
        
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Do you want to remove this service from your Favorites?", Target: self)
        { (actn) in
            if (actn == KYes)
            {
                self.viewModel?.Set_UNFavorite(serviceId:obj.id ?? "0")
            }
        }
    }
    
    @IBAction func cellAction_OrderAgain(_ sender: UIButton)
    {
        
    }
    
    @IBAction func actionTapOnCell(_ sender: UIButton)
    {
        let obj = apiData?[sender.tag]
        let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
        
        let cartCompanyID = obj?.cartCategoryCompany ?? ""
        let CompanyID = obj?.service.category.companyID ?? ""
        let cartCategoryType = obj?.cartCategoryType ?? ""
        
        if(cartCategoryType.count > 0)
        {
            if(cartCompanyID == CompanyID)
            {
                controller.catID = obj?.serviceID ?? "0"
                self.push_To_Controller(from_controller: self, to_Controller: controller)
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
        else
        {
            controller.catID = obj?.serviceID ?? "0"
            controller.itmName = obj?.service.name ?? "Details"
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
    
}

extension FavoriteListVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSkeleton_Service == true
        {
            return skeletonItems_Service
        }
        
        return apiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIDs, for: indexPath)as! CellClass_FavList
        
        
        if let obj = apiData?[indexPath.row]
        {
            cell.btnDelete.tag = indexPath.item
            cell.btnTapOnCell.tag = indexPath.item
            cell.btnOrderAgain.tag = indexPath.item
          //  cell.btnOrderAgain.setTitle(DynamicTextHandler.BUYorADD_BUTTON, for: .normal)
            cell.lblDuration.text = "\(self.dynamicDurationText): \(obj.service.duration ?? "")"
            let img = obj.service.thumbnail
            cell.ivCat.setImage(with: img ?? "", placeholder: kplaceholderImage)
            cell.ivCat.CornerRadius(radius: 15.0)
            cell.lblName.text! = obj.service.name ?? ""
            cell.lblPrice.text! = "\(AppDefaults.shared.currency)\(obj.service.price ?? 0)"
            
            
           // cell.ratingView.rating = Double(obj.service.rating ?? 0)
            
            cell.hideSkeleton()
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }
    
}



extension FavoriteListVC : FavoriteListVCDelegate
{
    
    func getData(subcats: [FavoriteListResult])
    {
        DispatchQueue.main.async
            {
                if (subcats.count > 0)
                {
                    self.apiData = subcats
                    self.isSkeleton_Service = false
                    self.favTableView.restore()
                    self.favTableView.animateReload()
                }
                else
                {
                    self.nothingFound()
                }
        }
    }
    
    func nothingFound()
    {
        self.apiData = nil
        self.isSkeleton_Service = false
       // self.favTableView.setEmptyMessage("Favorites not available!")
        self.favTableView.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        self.favTableView.animateReload()
    }
    
}

