
//

import UIKit
import GMStepper


class CartListVC: CustomController
{
    
    @IBOutlet var viewAddOnes: ShadowView!
    @IBOutlet var viewAddonHeight: NSLayoutConstraint!
    @IBOutlet var collcnAddones: UICollectionView!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var btnClearAll: UIBarButtonItem!
    @IBOutlet var viewCheckOut: UIView!
    @IBOutlet var viewItems: UIView!
    @IBOutlet var tableViewCartList: UITableView!
    @IBOutlet var lblTotal_Items: UILabel!
    @IBOutlet var lblTotal_Price: UILabel!
    @IBOutlet var lblFinal_Price: UILabel!
    @IBOutlet var btnCheckout: UIButton!
    
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 1
  //  var apiData : [CartListResult]?
    
    var apiData = NSArray()
    var apiDataAddones = NSArray()
    var apiDataLPoints = NSDictionary()
    
  //  var apiDataAddones : [AddOn]?
    
   // var apiDataLPoints :lPointsDec?
    let cellID = "CellClass_CartList"
    var viewModel:CartList_ViewModel?
    var sumTotal = 0.0
    var sumItems = 0
    var collCell = "CellClass_Addones"
    var width = 0.0
    var currentADD_ON_ID = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUI()
        self.viewModel = CartList_ViewModel.init(Delegate: self, view: self)
        self.viewModel!.getCartList()
        width = Double(self.view.bounds.width)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.hideNAV_BAR(controller: self)
        self.viewModel!.getCartList()
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    @IBAction func actionStepper(_ sender: GMStepper)
    {
        let val = Int(sender.value)
        let obj = apiData.object(at: sender.tag)as? NSDictionary
        
        let id = obj?.value(forKey: "id") as? String ?? ""
        
        if (val == 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to remove this service from your cart?", Target: self)
            { (actn) in
                if (actn == KYes)
                {
                    self.viewModel?.deleteCartItem(cartID: id)
                }
            }
        }
        else
        {
            self.UpdateToCart( Quantity: "\(val)", index: sender.tag, cartId: id )
        }
    }
    
    
    
    func UpdateToCart(Quantity:String, index: Int, cartId : String)
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
                        let tqntity = dic?["totalQunatity"] as? Int
                        let orderTotalPrice = dic?["sum"] as? Double
                        if orderTotalPrice != nil
                        {
                            self.lblFinal_Price.text = "\(AppDefaults.shared.currency)\(String(describing: orderTotalPrice!))"
                            print(quantity as Any)
                            
                        }
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
                        
                        self.sumTotal = orderTotalPrice ?? 0.0
                        self.sumItems = tqntity ?? 0
                        
                        let dic1 = self.apiData.object(at: index)as! NSDictionary
                        let dic2 = NSMutableDictionary(dictionary: dic1)
                        
                        dic2.setValue(quantity ?? "", forKey: "quantity")
                        
                        let arr: NSMutableArray = NSMutableArray(array: self.apiData)
                        arr.replaceObject(at: index, with: dic2)
                        
                        self.apiData = arr
                        
                       // self.apiData?[index].quantity = quantity ?? ""
                        self.tableViewCartList.reloadData()
                        
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
    
    @IBAction func actionClearCart(_ sender: Any)
    {
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to clear your cart?", Target: self)
        { (actn) in
            if (actn == KYes)
            {
                self.viewModel?.ClearCartList()
            }
        }
    }
    
    
   
    
    
    @IBAction func cellAction_DeleteItem(_ sender: UIButton)
    {
        let obj = apiData.object(at: sender.tag)as? NSDictionary
        let id = obj?.value(forKey: "id") as? String ?? ""
        
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to remove this service from your cart?", Target: self)
        { (actn) in
            if (actn == KYes)
            {
                self.viewModel?.deleteCartItem(cartID: id )
            }
        }
    }
    
    
    
    @IBAction func cellActionAddones(_ sender: UIButton)
    {
        if(self.apiDataAddones.count > 0)
        {
            let obj = apiDataAddones.object(at: sender.tag)as? NSDictionary
            let id = obj?.value(forKey: "id") as? String ?? ""
            let price = "\(obj?.value(forKey: "price") ?? "")"
            self.currentADD_ON_ID = id
            
          //  self.viewModel?.AddServiceToCart(serviceID:id,Price:price,Quantity:"1",TotalPrice:"\(self.sumTotal)",cmpId:AppDefaults.shared.companyID,isAddone:true)
            self.viewModel?.AddServiceToCart(serviceID:id,Price:price,Quantity:"1",TotalPrice:"\(price)",cmpId:AppDefaults.shared.companyID,isAddone:true)
        }
    }
    
    
    @IBAction func applyCoupon(_ sender: Any)
    {
        
    }
    
    
    @IBAction func actionRemoveCoupon(_ sender: Any)
    {
        
    }
    
    
    @IBAction func actionCheckout(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CheckAvailabilityVC)as! CheckAvailabilityVC
        controller.finalPRICE = "\(self.sumTotal)"
        controller.items = self.apiData.count
        
        controller.myLoaylty = self.apiDataLPoints
        
        if(self.apiData.count > 0)
        {
            let obj = apiData.object(at: 0)as? NSDictionary
            let id = obj?.value(forKey: "companyId") as? String ?? ""
            controller.compnyID = id
        }
        
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    
    
    func setUI()
    {
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
        self.viewCheckOut.isHidden = true
        self.btnCheckout.backgroundColor = Appcolor.get_category_theme()
        self.btnCheckout.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
       // self.lblFinal_Price.textColor = Appcolor.get_category_theme()
    }
    
    func checkCouponApplied()
    {
        self.handleCoupon_Removal()
    }
    
    
    func handleCoupon_Removal()
    {
        //        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
        //            self.ivArrowCoupon.isHidden = false
        //            self.lblStrikeThru.attributedText = NSAttributedString(string: "")
        //            self.view.layoutIfNeeded()
        //        }, completion: nil)
    }
    
    func removeAddedAddonesFromAvailableList(addonID:String)
    {
        if(self.apiDataAddones.count > 0)
        {
            for i in 0...self.apiDataAddones.count-1
            {
                let obj = self.apiDataAddones.object(at: i)as! NSDictionary
                let id = obj.value(forKey: "id") as? String ?? ""
                
                if(addonID == id)
                {
                    self.deleteAddone(indx:i)
                    break
                }
            }
        }
        else
        {
            currentADD_ON_ID = ""
        }
    }
    
    func deleteAddone(indx:Int)
    {
        let arr = NSMutableArray(array: self.apiDataAddones)
        
        if(arr.count > indx)
        {
            arr.removeObject(at: indx)
            let narr = NSArray(array: arr)
            self.apiDataAddones = narr
            self.collcnAddones.reloadData()
        }
        else
        {
            Commands.println(object: "Index not found for deleting addones")
        }
    }
    
}

extension CartListVC : CartListVCDelegate
{
   
    func setupViewAfterGettingData()
    {
        if (self.apiData.count > 0)
        {
            self.navigationItem.rightBarButtonItem = self.btnClearAll
            self.viewCheckOut.isHidden = false
            
            
            self.isSkeleton_Service = false
            self.tableViewCartList.restore()
            self.tableViewCartList.animateReload()
            self.collcnAddones.reloadData()
            self.lblTotal_Price.text = "\(self.apiData.count)"
            self.lblFinal_Price.text = "\(AppDefaults.shared.currency)\(self.sumTotal)"
            self.checkCouponApplied()
            self.handleViewHeight()
        }
        else
        {
            self.nothingFound()
        }
        
        if (self.apiDataAddones.count > 0)
        {
            self.collcnAddones.reloadData()
            self.viewAddonHeight.constant = 160
            self.viewAddOnes.isHidden = false
        }
        else
        {
            self.viewAddonHeight.constant = 0
            self.viewAddOnes.isHidden = true
            self.viewDidLayoutSubviews()
        }
        
        
       // self.removeAddedAddonesFromAvailableList(addonID: currentADD_ON_ID)
        
    }
    
    
    
    
    func nothingFound()
    {
        //self.navigationItem.rightBarButtonItem = nil
        self.viewCheckOut.isHidden = true
        self.isSkeleton_Service = false
        self.apiData = NSArray()
        self.tableViewCartList.setEmptyImage(imgName: "empCart")
        self.tableViewCartList.animateReload()
        self.viewAddonHeight.constant = 0
        self.viewAddOnes.isHidden = true
        self.tblHeight.constant = 300
        self.viewDidLayoutSubviews()
    }
    
}

extension CartListVC : UpdateViewAfterSuccess_Delegate
{
    func refreshController(approach: String)
    {
        if (approach == "home")
        {
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
    }
}

extension CartListVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return apiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)as! CellClass_CartList
        
        if let obj = self.apiData.object(at: indexPath.row)as? NSDictionary
        {
            cell.viewStepper.tag = indexPath.row
            
            
            let objService = obj.object(forKey: "service") as? NSDictionary
            
            let img = objService?.value(forKey: "thumbnail") as? String ?? ""
          //  let img = obj.service.thumbnail ?? ""
            
            
            cell.iv.setImage(with: img, placeholder: kplaceholderImage)
            cell.btnDelete.tag = indexPath.row
            
            cell.lblName.text = objService?.value(forKey: "name") as? String ?? ""
           // cell.lblName.text = obj.service.name
            
            let price = obj.value(forKey: "orderPrice") ?? ""
            let qntity : Double = Double("\(obj.value(forKey: "quantity") ?? "0")")!
            
            
            cell.lblPrice.text = "\(AppDefaults.shared.currency)\(price)"
            
            cell.viewStepper.value = qntity
            cell.iv.CornerRadius(radius: 10.0)
            
            cell.hideAnimation()
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    
    func handleViewHeight()
    {
        if(self.apiData.count > 0)
        {
            self.tblHeight.constant = CGFloat((self.apiData.count )*130)
        }
        else
        {
            self.tblHeight.constant = 150
        }
        self.viewDidLayoutSubviews()
    }
}


extension CartListVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return apiDataAddones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCell, for: indexPath)as! CellClass_Addones
        
        if (apiDataAddones.count > 0)
        {
            let obj = self.apiDataAddones.object(at: indexPath.row)as? NSDictionary
            
            let img = obj?.value(forKey: "thumbnail")as? String ?? ""
            
            cell.ivAddones.setImage(with: img, placeholder: kplaceholderImage)
            cell.btnAdd.tag = indexPath.row
            cell.lblName.text = obj?.value(forKey: "name")as? String ?? ""
            
            let price = "\(obj?.value(forKey: "price") ?? "0")"
            
            cell.lblQuantity.text = "\(AppDefaults.shared.currency)\(price)"
            cell.ivAddones.CornerRadius(radius: 10)
            
            cell.hideAnimation()
        }
        else
        {
            cell.showAnimation()
        }
        
        
        return cell
    }
    
    
    
}

extension CartListVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        let obj = self.apiDataAddones.object(at: indexPath.row)as? NSDictionary
        
        let name = obj?.value(forKey: "name")as? String ?? "    "
        
        label.text = name
        label.sizeToFit()
        let ww = label.frame.width
        return CGSize(width: ww+140, height: 110)
    }
}


extension CartListVC:UpdateViewAfterAddCart_Delegate
{
    //updating view after adding quantity and add to cart
    func refreshController(text: String)
    {
        self.apiDataAddones = NSArray()
        self.apiData = NSArray()
        self.tableViewCartList.animateReload()
        self.collcnAddones.reloadData()
        self.viewModel?.getCartList()
    }
}
