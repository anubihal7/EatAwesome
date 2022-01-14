
//

import UIKit
import GMStepper


class CatServiceListVC: CustomController
{
    //CartView
    @IBOutlet var viewNav: UIView!
    @IBOutlet var viewCart: UIView!
    @IBOutlet var lblCartCount: CustomUILabel!
    
    
    @IBOutlet var btnSwitch: UISwitch!
    @IBOutlet var filterViewHeight: NSLayoutConstraint!
    @IBOutlet var filterView: UIView!
    @IBOutlet var collMainCats: UICollectionView!
    
    @IBOutlet var tableViewServices: UITableView!
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 4
    
    var apiData : [ServiceListResult]?
   // var apiData = NSArray()
    let cellID_cats = "CallClass_ServiceList"
    var viewModel:ServiceList_ViewModel?
    var servicesList: [subcats]? = nil
    var headersFound = false
    var delegateInstructions: UpdateViewAfterAddCart_Delegate?
    
    var selctdIDS = [String]()
    var selectedIndx = 0
    var fromViewDidLoad = false
    var dynamicButtonText = "Buy"
    var dynamicDurationText = "Duration"
    var vegOnly = String("")
    var previousValueStepper = 1
    var currentValueStepper = 0
    var price = 0
    var lblVegOrNonVeg = UILabel()
    var customSwitch = UISwitch()
    var mainSelectedCatIndex = 0
    
    var vendrCatID = "0"
    var selectedMainCatID = "0"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewNav.backgroundColor = kpinkTheme
        self.setStatusBarColor(view: self.view, color:kpinkTheme)
        self.title = DynamicTextHandler.SERVICELIST_TITLE
        self.dynamicButtonText = DynamicTextHandler.BUYorADD_BUTTON
        self.dynamicDurationText = DynamicTextHandler.ITEM_DURATION_TEXT
        
        self.fromViewDidLoad = true
        self.viewModel = ServiceList_ViewModel.init(Delegate: self, view: self)
        self.viewModel?.getCategoryList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if (AppDefaults.shared.isVegOnly == true)
        {
            self.customSwitch.setOn(true, animated: true)
            self.vegOnly = "0"
            lblVegOrNonVeg.text = "VEG"
        }
        else
        {
            self.customSwitch.setOn(false, animated: true)
            self.vegOnly = ""
            lblVegOrNonVeg.text = "VEG"
        }
        
        self.hideNAV_BAR(controller: self)
        self.checkCartBadge()
        
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    @IBAction func acnSwitchVeg(_ sender: UISwitch)
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
        self.viewModel?.getServiceList(catID: selectedMainCatID)
    }
    
    @IBAction func actionMoveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func acnGotoCart(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
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
        self.viewModel?.getServiceList(catID: selectedMainCatID)
    }
    
    @IBAction func moveToCartList(_ sender: UIButton)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func cellAction_SetFav(_ sender: UIButton)
    {
        let obj = apiData![sender.tag]
        
        if (obj.favourite?.count ?? 0 > 0)
        {
            self.viewModel?.Set_UNFavorite(serviceId: obj.favourite ?? "0")
        }
        else
        {
            self.viewModel?.Set_Favorite(serviceId: obj.id ?? "0")
        }
        
    }
    
    
    @IBAction func CellAction_AddToCart(_ sender: UIButton)
    {
        if(apiData?.count ?? 0 > 0)
        {
            
            let obj = apiData?[sender.tag]
            
            if(obj?.cart == nil)
            {
                
                
                if (AppDefaults.shared.CartCompanyID.count == 0)
                {
                    self.AddServiceToCart(serviceID: obj?.id ?? "", Price: "\(obj?.price ?? 0)", Quantity: "1", TotalPrice: "\(obj?.price ?? 0)", index: sender.tag)
                }
                else
                {
                    if(AppDefaults.shared.CartCompanyID == AppDefaults.shared.companyID)
                    {
                        self.AddServiceToCart(serviceID: obj?.id ?? "", Price: "\(obj?.price ?? 0)", Quantity: "1", TotalPrice: "\(obj?.price ?? 0)", index: sender.tag)
                    }
                    else
                    {
                        self.AlertMessageWithOkCancelAction(titleStr: "Items already in cart", messageStr: "Your cart contains items from a different restaurant. Would you like to reset your cart before adding this item?", Target: self)
                        { (actn) in
                            if (actn == KYes)
                            {
                                self.viewModel?.clearCart(serviceid:obj?.id ?? "",price:Int(obj?.price ?? 0), Index: sender.tag)
                            }
                        }
                    }
                }
                
                
            }
            else
            {
                self.viewModel?.deleteCartItem(cartID:obj?.cart?.id ?? "0", Index: sender.tag)
            }
        }
    }
    
    
    @IBAction func actionAddQuantity(_ sender: GMStepper) {
        let val = Int(sender.value)
        let obj = apiData?[sender.tag]
        currentValueStepper = Int(sender.value)
        
        
        if (val == 0)
        {
            
            self.viewModel?.deleteCartItem(cartID:obj?.cart?.id ?? "0" , Index: sender.tag)
            
        }
            
            
        else
        {
            
            self.UpdateToCart(serviceID: obj?.id ?? "", Price: "\(obj?.price ?? 0)", Quantity: "\(val)", TotalPrice: "\(obj?.price ?? 0)", index: sender.tag, cartId: obj?.cart?.id ?? "0" )
            
        }
        
    }
    
    func AddServiceToCart(serviceID:String,Price:String,Quantity:String,TotalPrice:String, index: Int)
    {
        let status = self.getDeliveryTypeStatus()
        let obj : [String:Any] = ["serviceId":serviceID,"orderPrice":Price,"quantity":Quantity,"orderTotalPrice":TotalPrice,"deliveryType":status,"companyId":AppDefaults.shared.companyID,"vendorType":kvendorType]
        
        
        WebService.Shared.PostApi(url: APIAddress.ADD_TO_CART, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                if (code == 200)
                {
                    DispatchQueue.main.async {
                        let dic = responseData.value(forKey: "body") as? [String : Any]
                        let quantity = dic?["quantity"] as? String
                        let orderTotalPrice = dic?["orderTotalPrice"] as? String
                        let id = dic?["id"] as? String
                        self.apiData?[index].previousValue_Stepper = 1
                        var cartCount = AppDefaults.shared.cartCount
                        cartCount = cartCount+1
                        AppDefaults.shared.cartCount = cartCount
                        self.checkCartBadge()
                        var dic2 = Cart()
                        dic2.id = id
                        dic2.quantity = quantity
                        self.apiData?[index].cart = dic2
                        self.tableViewServices.reloadData()
                        
                    }
                    
                }
                else
                {
                    self.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        }, completionnilResponse: {(error) in
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
    func UpdateToCart(serviceID:String,Price:String,Quantity:String,TotalPrice:String, index: Int, cartId : String)
    {
        let obj : [String:Any] = ["quantity":Quantity, "cartId":cartId]
        
        
        WebService.Shared.PutApi(url: APIAddress.UPDATE_TO_CART, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                
                if (code == 200)
                {
                    DispatchQueue.main.async {
                        
                        let dic = responseData.value(forKey: "body") as? [String : Any]
                        let quantity = dic?["quantity"] as? String
                        let orderTotalPrice = dic?["orderTotalPrice"] as? String
                        
                        print(quantity as Any)
                        /*   var cartCount = AppDefaults.shared.cartCount
                         self.previousValueStepper =   self.apiData?[index].previousValue_Stepper ?? 1
                         if self.currentValueStepper > self.previousValueStepper {
                         cartCount = cartCount+1
                         }
                         else{
                         if cartCount != 0 {
                         cartCount = cartCount-1
                         }
                         }
                         
                         AppDefaults.shared.cartCount = cartCount
                         self.updateCartBadge(target:self) */
                        //self.viewModel?.getServiceList(catID: self.subCatID)
                        self.apiData?[index].cart?.quantity = quantity
                        self.apiData?[index].previousValue_Stepper = Int(quantity ?? "1")!
                        self.tableViewServices.reloadData()
                        
                    }
                }
                else
                {
                    
                    self.showToastSwift(alrtType: .error, msg: msg, title: "")
                }
            }
            else
            {
                self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        }, completionnilResponse: {(error) in
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    
}


extension CatServiceListVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return servicesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClassMainCategories", for: indexPath)as! CellClassMainCategories
        
        let data = servicesList?[indexPath.row]
        
        let img = data?.thumbnail ?? ""
        cell.iv.setImage(with: img, placeholder: kplaceholderImage)
        cell.iv.CornerRadius(radius: 15.0)
        cell.lblName.text = data?.name
        
        if(indexPath.row == mainSelectedCatIndex)
        {
            cell.lblName.textColor = kpurpleTheme
        }
        else
        {
            cell.lblName.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let data = servicesList?[indexPath.row]
        self.selectedMainCatID = data?.id ?? "0"
        self.mainSelectedCatIndex = indexPath.row
        self.collMainCats.reloadData()
        self.viewModel?.getServiceList(catID: self.selectedMainCatID)
    }
    
    func checkSelectedItems(id:String) -> Bool
    {
        var istrue = false
        if (self.selctdIDS.count > 0)
        {
            for i in 0...self.selctdIDS.count-1
            {
                let filtered = self.selctdIDS[i]
                if (filtered == id)
                {
                    istrue = true
                    break
                }
            }
        }
        else
        {
            istrue = false
        }
        return istrue
    }
    
    func removeSelectedID(id:String)
    {
        if (self.selctdIDS.count > 0)
        {
            for i in 0...self.selctdIDS.count
            {
                let filtered = self.selctdIDS[i]
                if (filtered == id)
                {
                    self.selctdIDS.remove(at: i)
                    break
                }
            }
        }
    }
    
    
    func checkCartBadge()
    {
        self.lblCartCount.text = self.getCartCount()
    }
}

extension CatServiceListVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 90, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
}


extension CatServiceListVC : UITableViewDelegate,UITableViewDataSource
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID_cats, for: indexPath)as! CallClass_ServiceList
        
        if let obj = apiData?[indexPath.row]
        {
            cell.btnLike.tag = indexPath.item
            cell.btnAdd.tag = indexPath.item
            cell.viewStepper.tag = indexPath.item
            
            let img = obj.thumbnail ?? ""
            cell.ivCat.setImage(with: img, placeholder: kplaceholderImage)
            cell.ivCat.CornerRadius(radius: 10.0)
            
            cell.lblName.text! = obj.name ?? ""
            cell.lblPrice.text! = "\(AppDefaults.shared.currency)\(obj.price ?? 0)"
            cell.lblDuration.text = "\(self.dynamicDurationText): \(obj.duration ?? "")"
            
            if (obj.favourite?.count ?? 0 > 0)
            {
                cell.btnLike.setImage(UIImage(named: "fav"), for: .normal)
            }
            else
            {
                cell.btnLike.setImage(UIImage(named: "unfav"), for: .normal)
            }
            
            let discnt = obj.originalPrice
            if(discnt != 0 && discnt != nil)
            {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(AppDefaults.shared.currency)\(String(describing: discnt!))")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.lblDiscount.attributedText = attributeString
            }
            else
            {
                cell.lblDiscount.attributedText = NSAttributedString(string: "")
            }
            
            if(obj.cart == nil)
            {
                cell.btnAdd.isHidden = false
                cell.viewStepper.isHidden = true
                // cell.btnAdd.backgroundColor = Appcolor.get_category_theme()
            }
            else
            {
                //                cell.btnAdd.setTitle("Remove", for: .normal)
                //                cell.btnAdd.backgroundColor = UIColor.red
                cell.btnAdd.isHidden = true
                cell.viewStepper.isHidden = false
                cell.viewStepper.value =  Double(obj.cart?.quantity ?? "0")!
                
                
            }
            
            //            if apiData?[indexPath.row].showSlider == "show" {
            //                cell.btnAdd.isHidden = true
            //                cell.viewStepper.isHidden = false
            //            }
            //            else {
            //                cell.btnAdd.isHidden = false
            //                cell.viewStepper.isHidden = true
            //            }
            
            if(obj.itemType == "0")
            {
                cell.ivVeg.image = UIImage(named: "veg")
            }
            else
            {
                cell.ivVeg.image = UIImage(named: "nonveg")
            }
            
            cell.hideAnimation()
            // cell.btnAdd.updateLayerProperties()
        }
        else
        {
            cell.showAnimation()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let obj = apiData?[indexPath.row]
        let controller = Navigation.GetInstance(of: .ServiceDetailVC)as! ServiceDetailVC
        controller.catID = obj?.id ?? "0"
        controller.itmName = obj?.name ?? "Details"
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0
    }
}


extension CatServiceListVC : ServiceListVCDelegate
{
    func removeItem(indx: Int)
    {
        //         apiData?[indx].showSlider = ""
        //               tableViewServices.reloadData()
    }
    
    func reloadTable(indx: Int)
    {
        //        apiData?[indx].showSlider = "show"
        //        tableViewServices.reloadData()
    }
    
    ////MAIN CATEGORIES ITEMS
    func getData(subcats: [ServiceListResult], tags:[subCategoryResult])
    {
        DispatchQueue.main.async
            {
                if (subcats.count > 0)
                {
                    self.apiData = subcats
                    self.isSkeleton_Service = false
                    self.tableViewServices.restore()
                    self.tableViewServices.animateReload()
                }
                else
                {
                    self.nothingFound()
                }
        }
    }
    
    //MAIN CATEGORIES
    func getData(services: [subcats])
    {
        DispatchQueue.main.async {
            
            self.servicesList = services
            
            //services
            if (self.servicesList?.count ?? 0 > 0)
            {
                self.collMainCats.setEmptyMessage("")
                self.collMainCats.delegate = self
                self.collMainCats.dataSource = self
                self.collMainCats.reloadData()
                self.selectedMainCatID = self.servicesList![0].id ?? "0"
                self.viewModel?.getServiceList(catID: self.selectedMainCatID)
            }
            else
            {
                self.collMainCats.setEmptyMessage(kDataNothingTOSHOW)
                self.collMainCats.delegate = self
                self.collMainCats.dataSource = self
                self.collMainCats.reloadData()
            }
        }
    }
    
    func nothingFound()
    {
        self.apiData = nil
        self.isSkeleton_Service = false
        self.tableViewServices.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        self.tableViewServices.animateReload()
    }
    
    func noMainCategory()
    {
        self.servicesList = nil
        self.isSkeleton_Service = false
        self.collMainCats.reloadData()
    }
    
    func handleCartAddOrRemove(status: String, sID: String)
    {
        if (status == "true")
        {
            self.selctdIDS.append(sID)
            self.tableViewServices.reloadData()
        }
        else
        {
            self.removeSelectedID(id: sID)
            self.tableViewServices.reloadData()
        }
    }
    
}

extension CatServiceListVC:UpdateViewAfterAddCart_Delegate
{
    //updating view after adding quantity and add to cart
    func refreshController(text: String)
    {
        self.viewModel?.getServiceList(catID: selectedMainCatID)
        AppDefaults.shared.CartCompanyID = AppDefaults.shared.companyID
        self.updateCartBadge(target:self)
    }
}
