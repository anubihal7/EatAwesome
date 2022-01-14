
//

import UIKit

class SeeAllRestaurantsVC: UIViewController
{
    
    
    @IBOutlet var cpnViewHeight: NSLayoutConstraint!
    @IBOutlet var couponsCollectionVie: UICollectionView!
    @IBOutlet var btnSwitch: UISwitch!
    @IBOutlet var btnCart: UIBarButtonItem!
    @IBOutlet var tblViewVendors: UITableView!
    
    var viewModel:SeeAllRestaurantsViewModel?
    
    var isSkeleton_Vendors = true
    var skeletonItems = 5
    var vendorsDATA: [BestSellerNEW]? = nil
    var bannersDATA: [RESTOfferDEC]? = nil
    let cellID_Vendors = "VendorsNewTableCell"
    let cellID_Banners = "BannersCollectionCell"
    
    var cartVendorID = ""
    var vegOnly = ""
    var discount = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.showNAV_BAR(controller: self)
        self.viewModel = SeeAllRestaurantsViewModel.init(Delegate: self, view: self)
        self.viewModel?.getRestaurantsList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.updateCartBadge(target:self)
        
        if (AppDefaults.shared.isVegOnly == true)
        {
            self.btnSwitch.setOn(true, animated: true)
            self.vegOnly = "0"
        }
        else
        {
            self.btnSwitch.setOn(false, animated: true)
            self.vegOnly = ""
        }
    }
    
    @IBAction func movebAck(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func moveToCart(_ sender: Any)
    {
        
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
        self.viewModel?.getRestaurantsList()
    }
    
    
    //MARK: HANDLING CELL TAP ACTIONS
    @IBAction func CellAction_TapOnVendors(_ sender: UIButton)
    {
        if(self.vendorsDATA?.count ?? 0 > 0)
        {
            let obj = self.vendorsDATA![sender.tag]
            
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.categoryID = mainID
            controller.Tittle = obj.companyName ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            // self.checkVendorIsSameForCartVendoer(cmpnyID:obj.id ?? "")
        }
    }
    
    func checkVendorIsSameForCartVendoer(cmpnyID:String)
    {
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        if (self.cartVendorID.count == 0)
        {
            AppDefaults.shared.companyID = cmpnyID
            controller.categoryID = mainID
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        else
        {
            if(self.cartVendorID == cmpnyID)
            {
                AppDefaults.shared.companyID = cmpnyID
                controller.categoryID = mainID
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            else
            {
                self.AlertMessageWithOkCancelAction(titleStr: "Items already in cart", messageStr: "Your cart contains items from a different restaurant. Would you like to reset your cart before browsing this restaurant?", Target: self)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.viewModel?.clearCart(compID:cmpnyID)
                    }
                }
            }
        }
    }
}

extension SeeAllRestaurantsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //    {
    //        let cellN = tableView.dequeueReusableCell(withIdentifier: cellID_Vendors, for: indexPath)as! VendorsNewTableCell
    //
    //        if let obj = self.vendorsDATA?[indexPath.row]
    //        {
    //            cellN.hideAnimation()
    //
    //            cellN.btnTapOnCell.tag = indexPath.row
    //            let img = obj.logo1 ?? ""
    //            cellN.ivDish.setImage(with: img, placeholder: kplaceholderImage)
    //
    //
    //            cellN.lblName.text! = obj.companyName ?? "N/A"
    //            cellN.lblAddress.text! = obj.address1 ?? "N/A"
    //            cellN.lblTime.text = "\(obj.startTime ?? "Timing :") - \(obj.endTime ?? "")"
    //            cellN.pastOrders.text = "\(obj.totalOrders24 ?? "No")"
    //
    //            let rateD = Double(obj.rating ?? "0.0") ?? 0.0
    //            let rate = CGFloat(rateD)
    //          //  cellN.lblRatingas.text = "\(rate.cleanValue)"
    //
    //            cellN.viewRate.rating = Double(rate.cleanValue) ?? 0.0
    //
    //            let distanec = CGFloat(obj.distance ?? 0.0)
    //           // cellN.lblDistance.text = "\(distanec.cleanValue) km"
    //            let time = self.convertDistanceIntoMinuts(distance: distanec)
    //            cellN.lblDistance.text = time
    //
    //            let offer = obj.coupan?.discount ?? "0"
    //            if(offer != "0")
    //            {
    //                cellN.offerView.isHidden = false
    //                cellN.lblCurrentOffer.text = "\(offer)% off"
    //            }
    //            else
    //            {
    //                cellN.offerView.isHidden = true
    //            }
    //
    //           // cellN.ivDish.roundCornersTopLEFTBottomLEFT()
    //            let txt = obj.tags
    //            if(txt.count > 0)
    //            {
    //                cellN.lblMarquee.text = txt.joined(separator: ", #")
    //                cellN.lblMarquee.restartLabel()
    //            }
    //            else
    //            {
    //                cellN.lblMarquee.text = ""
    //            }
    //        }
    //        else
    //        {
    //            cellN.showAnimation()
    //        }
    //
    //
    //        return cellN
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        let cellN = tableView.dequeueReusableCell(withIdentifier: "TableVendors", for: indexPath)as! TableVendors
        
        let obj = self.vendorsDATA?[indexPath.row]
        
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
        
        if(rate < 1)
        {
            cellN.ivRate.image = UIImage(named: "starGray")
        }
        else
        {
            cellN.ivRate.image = UIImage(named: "rate")
        }
        
        cell = cellN
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell:VendorsNewTableCell = tableView.dequeueReusableCell(withIdentifier: cellID_Vendors) as! VendorsNewTableCell
        cell.lblMarquee.restartLabel()
        
        if(self.vendorsDATA?.count ?? 0 > 0)
        {
            let obj = self.vendorsDATA![indexPath.row]
            
            let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
            AppDefaults.shared.companyID = obj.id ?? ""
            controller.categoryID = mainID
            controller.Tittle = obj.companyName ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            // self.checkVendorIsSameForCartVendoer(cmpnyID:obj.id ?? "")
        }
    }
}

extension SeeAllRestaurantsVC : SeeAllRestaurantsVCDelegate
{
    func getData(vendors : [BestSellerNEW])
    {
        
        DispatchQueue.main.async
            {
                self.vendorsDATA = vendors
                //  self.cartVendorID = allData.cartCompanyType ?? ""
                
                
                //VENDORS(REATAURANTS)
                if (vendors.count > 0)
                {
                    self.vendorsDATA = vendors
                    self.isSkeleton_Vendors = false
                    self.tblViewVendors.restore()
                    self.tblViewVendors.animateReload()
                }
                else
                {
                    self.isSkeleton_Vendors = true
                    self.tblViewVendors.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
                    self.tblViewVendors.animateReload()
                }
                
                
                //checking if cart is emoty or not
                if(self.cartVendorID.count > 0)
                {
                    self.addBadge(itemvalue: "1")
                }
                
                if(self.bannersDATA?.count ?? 0 > 0)
                {
                    self.cpnViewHeight.constant = 165
                    self.couponsCollectionVie.isHidden = false
                    self.couponsCollectionVie.reloadData()
                }
                else
                {
                    self.cpnViewHeight.constant = 0
                    self.couponsCollectionVie.isHidden = true
                }
        }
    }
    
    func nothingFound()
    {
        isSkeleton_Vendors = false
        self.tblViewVendors.animateReload()
        self.tblViewVendors.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
    }
    
}

