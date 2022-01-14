

import UIKit

class NewOrderListVC: UIViewController
{
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewNav: UIView!
    @IBOutlet var btnSeg: UIButton!
    @IBOutlet var heightSegmentView: NSLayoutConstraint!
    @IBOutlet var tblOrders: UITableView!
    @IBOutlet var btnDrawer: UIButton!
    
    var apiData : [OrderData]?
    let cellID = "CellClass_NewOrderList"
    var approach = "orderList"
    
    
    var viewModel:OrderList_ViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewModel = OrderList_ViewModel.init(Delegate: self, view: self)
        
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
        self.viewNav.backgroundColor = kpurpleTheme
        self.hideNAV_BAR(controller: self)
        
        btnDrawer.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.hideNAV_BAR(controller: self)
        if (self.approach == "orderList")
        {
            self.heightSegmentView.constant = 0
            self.lblTitle.text = DynamicTextHandler.ORDERS_TITLE
            self.viewModel?.getOrderList(status:"0,1,3,6,7,8,9,10",page:"1",limit:"100")//0,1,3
        }
        else
        {
            self.heightSegmentView.constant = 65
            self.lblTitle.text = DynamicTextHandler.ORDERS_HISTORY_TITLE
            self.viewModel?.getOrderList(status:"5",page:"1",limit:"100")
            btnSeg.tag = 0
        self.btnSeg.setImage(UIImage(named: "compSeg"), for: .normal)
        }
    }
    
    
    @IBAction func acnSegmnt(_ sender: UIButton)
    {
        if(btnSeg.tag == 0)//cancelled
        {
            btnSeg.tag = 1
            self.btnSeg.setImage(UIImage(named: "cancelSeg"), for: .normal)
            self.viewModel?.getOrderList(status:"2,4",page:"1",limit:"100")//0,1,3
        }
        else if(btnSeg.tag == 1)
        {
            btnSeg.tag = 0
            self.btnSeg.setImage(UIImage(named: "compSeg"), for: .normal)
            self.viewModel?.getOrderList(status:"5",page:"1",limit:"100")//0,1,3
        }
    }
    
    
    @IBAction func cellActionRateOrder(_ sender: UIButton)
    {
        let obj = apiData?[sender.tag]
        let ctrlr = Navigation.GetInstance(of: .AddOrderRatings) as! AddOrderRatings
        ctrlr.orderID = obj?.id ?? ""
        ctrlr.approach = "order"
        self.push_To_Controller(from_controller: self, to_Controller: ctrlr)
    }
    
    @IBAction func cellActionOrderHelp(_ sender: UIButton)
    {
        let controller = Navigation.GetInstance(of: .ChatVC) as! ChatVC
        controller.orderId = self.apiData?[sender.tag].id ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    @IBAction func cellActionCancelOrder(_ sender: UIButton)
    {
        let obj = self.apiData![sender.tag]
        
        if (self.approach == "orderList")
               {
        if (sender.titleLabel?.text == "Cancel Order")
        {
            
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to cancel this order?", Target: self)
            { (actn) in
                if (actn == KYes)
                {
                    self.viewModel?.cancelOrder(orderId: obj.id ?? "",reason:"Other")
                }
            }
        }
        else
        {
            //checking status pending,processing,confirmed for complete order
            if (obj.progressStatus == 0 || obj.progressStatus == 1 || obj.progressStatus == 3)
            {
                self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Do you want to complete this order?", Target: self)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.viewModel?.completeOrder(orderId:obj.id ?? "",stts:"5")
                    }
                }
            }
            else
            {
                self.showAlertMessage(titleStr: "Sorry", messageStr: "This order cannot be updated for this time!")
            }
        }
        }
        
    }
    
    
    
}


extension NewOrderListVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return apiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellNew = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)as! CellClass_NewOrderList
        
        if let obj = apiData?[indexPath.row]
        {
            cellNew.btnCencel.tag = indexPath.row
            cellNew.btnRate.tag = indexPath.row
            cellNew.btnhelp.tag = indexPath.row
            
            let img = obj.company?.logo1 ?? ""
            cellNew.ivVendor.setImage(with: img, placeholder: kplaceholderImage)
            cellNew.ivVendor.CornerRadius(radius: 15.0)
            
            cellNew.lblVendrName.text = obj.company?.companyName ?? ""
            
            let intvals = self.strToDate_Bookings(strDate: obj.serviceDateTime ?? "")
            cellNew.lblDeliverdDate.text = "Delivered On: \(intvals)"
            
            let createdTime = self.strToDate_Bookings(strDate: obj.createdAt ?? "")
            cellNew.lblOrderDate.text = "Ordered On: \(createdTime)"
            
            let orderItmesb = obj.suborders?.count ?? 0
            cellNew.lblTotal.text = "\(AppDefaults.shared.currency)\(obj.totalOrderPrice ?? "0")   |   Items: \(orderItmesb)"
            
            let status = cellNew.getOrderStatus(status:obj.orderStatus?.status ?? 0)
            let color = cellNew.getStatusColor(status:obj.progressStatus ?? 0)
            if (obj.cancellable == true)
            {
                cellNew.btnCencel.setTitle("Cancel Order", for: .normal)
                cellNew.btnCencel.backgroundColor = UIColor.red
            }
            else
            {
                cellNew.btnCencel.setTitle(status, for: .normal)
                cellNew.btnCencel.backgroundColor = color
            }
            
            
            if (self.approach == "orderList")
            {
                cellNew.widthRateBtn.constant = 0
            }
            else
            {
                cellNew.btnCencel.isHidden = true
                if(obj.isRated == true)
                {
                    cellNew.widthRateBtn.constant = 0
                }
                else
                {
                    cellNew.widthRateBtn.constant = 74
                }
            }
        }
        
        return cellNew
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180.0
        
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return 180.0
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = Navigation.GetInstance(of: .OrderDetailVC)as! OrderDetailVC
        
        if (self.approach == "orderList")
        {
            controller.orderCompleted = false
        }
        else
        {
            controller.orderCompleted = true
        }
        
        controller.orderId = self.apiData?[indexPath.row].id ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}


extension NewOrderListVC : OrderListVCDelegate
{
    func getData (orders : [OrderData])
    {
        DispatchQueue.main.async
            {
                if (orders.count > 0)
                {
                    self.apiData = orders
                    self.tblOrders.restore()
                    self.tblOrders.animateReload()
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
        
        if (self.approach == "orderList")
        {
            self.tblOrders.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        }
        else
        {
            self.tblOrders.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        }
        
        self.tblOrders.animateReload()
    }
    
}
