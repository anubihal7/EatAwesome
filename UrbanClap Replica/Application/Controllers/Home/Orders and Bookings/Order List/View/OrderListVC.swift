
//

import UIKit

class OrderListVC: CustomController
{
    
    @IBOutlet var tableviewOrders: UITableView!
    @IBOutlet var btnDrawer: UIBarButtonItem!
    
    
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 2
    var apiData : [OrderData]?
    let cellID = "CellClass_OrderList"
    let cellIDCellTable = "CellClass_CellTable"
    var viewModel:OrderList_ViewModel?
    var approach = "orderList"
    var isFromSideMenu = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      //  self.viewModel = OrderList_ViewModel.init(Delegate: self, view: self)
        
        
        if isFromSideMenu == true
        {
            btnDrawer.target = self.revealViewController()
            btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
            
        }
        else
        {
            btnDrawer.image = UIImage(named: "btn_back_black")
            btnDrawer.target = self
            btnDrawer.action = #selector(backAction)
        }
        
        if (self.approach == "orderList")
        {
            self.title = DynamicTextHandler.ORDERS_TITLE
            self.viewModel?.getOrderList(status:"0,1,3,6,7,8,9,10",page:"1",limit:"100")//0,1,3
        }
        else
        {
            self.title = DynamicTextHandler.ORDERS_HISTORY_TITLE
            self.viewModel?.getOrderList(status:"2,4,5",page:"1",limit:"100")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        showNAV_BAR(controller: self)
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func cellAction_CancelOrder(_ sender: UIButton)
    {
        let obj = self.apiData![sender.tag]
        
        
        
        
        //   self.viewModel?.completeOrder(orderId:obj.id ?? "",stts:"5")
        
        
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
    
    
    @IBAction func actionHelp(_ sender: UIButton) {
        
        let controller = Navigation.GetInstance(of: .ChatVC) as! ChatVC
                 controller.orderId = self.apiData?[sender.tag].id ?? ""
                    self.push_To_Controller(from_controller: self, to_Controller: controller)
        
    }
    
    
    
    @IBAction func cellAction_tapOnCell(_ sender: UIButton)
    {
        if AllUtilies.isConnectedToInternet
        {
            let controller = Navigation.GetInstance(of: .OrderDetailVC)as! OrderDetailVC
            controller.orderId = self.apiData?[sender.tag].id ?? ""
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        else
        {
            self.showToastSwift(alrtType:.info,msg:"Internet appears to be offline!",title:kOops)
        }
    }
    
    
    @IBAction func cellAcnRateOrder(_ sender: UIButton)
    {
        let obj = apiData?[sender.tag]
        let ctrlr = Navigation.GetInstance(of: .AddOrderRatings) as! AddOrderRatings
        ctrlr.orderID = obj?.id ?? ""
        ctrlr.approach = "order"
        self.push_To_Controller(from_controller: self, to_Controller: ctrlr)
    }
    
    @IBAction func cellActionTrackOrder(_ sender: UIButton)
    {
        let obj = apiData?[sender.tag]
        
      //  let dropLAT = Double(obj?.address?.latitude ?? "0.0")
      //  let dropLONG = Double(obj?.address?.longitude ?? "0.0")
        
        
        //these object creating problems in parsing data. So I have desabled them for now
        // let strtLAT = Double(obj?.companyAddress.lat ?? "0.0")
        // let strtLONG = Double(obj?.companyAddress.long ?? "0.0")
        
     //   let orderID = obj?.id
        
        let controller = Navigation.GetInstance(of: .TrackOrderVC)as!TrackOrderVC
        
      //  controller.stop_lat = dropLAT ?? 0.0
      //  controller.stop_long = dropLONG ?? 0.0
        // controller.start_lat = strtLAT ?? 0.0
        // controller.start_long = strtLONG ?? 0.0
      //  controller.orderid = orderID ?? "0"
        
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}


extension OrderListVC : OrderListVCDelegate
{
    func getData (orders : [OrderData])
    {
        DispatchQueue.main.async
            {
                if (orders.count > 0)
                {
                    self.apiData = orders
                    self.isSkeleton_Service = false
                    self.tableviewOrders.restore()
                    self.tableviewOrders.animateReload()
                }
                else
                {
                    self.nothingFound()
                }
        }
    }
    
    func nothingFound()
    {
        self.isSkeleton_Service = false
        self.apiData = nil
        
        if (self.approach == "orderList")
        {
            // self.tableviewOrders.setEmptyMessage("Orders not available!")
            self.tableviewOrders.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        }
        else
        {
            //self.tableviewOrders.setEmptyMessage("Bookings not available!")
            self.tableviewOrders.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        }
        
        self.tableviewOrders.animateReload()
    }
    
}


extension OrderListVC : UITableViewDataSource,UITableViewDelegate
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
        
        let cellNew = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)as! CellClass_OrderList
        
        if let obj = apiData?[indexPath.row]
        {
            cellNew.btnCencel.tag = indexPath.row
            cellNew.btnRate.tag = indexPath.row
            cellNew.btnTrack.tag = indexPath.row
            cellNew.btnTapOnCell.tag = indexPath.row
            cellNew.btnhelp.tag = indexPath.row
            let intvals = self.strToDate_Bookings(strDate: obj.serviceDateTime ?? "")
            cellNew.lblServiceDate.text = intvals
            
            let createdTime = self.strToDate_Bookings(strDate: obj.createdAt ?? "")
            cellNew.lblBookedOn.text = createdTime
            
            cellNew.lblTotal.text = "\(AppDefaults.shared.currency)\(obj.totalOrderPrice ?? "0")"
            
            cellNew.cellCollectionView.tag = indexPath.row
            cellNew.cellCollectionView.delegate = self
            cellNew.cellCollectionView.dataSource = self
            cellNew.cellCollectionView.reloadData()
            
            self.setCollection_Layout(collc: cellNew.cellCollectionView, layouts: cellNew.cellCollectionHeight)
            let status = cellNew.getOrderStatus(status:obj.progressStatus ?? 0)
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
            
            
            //checking Order list or Booking History
            if (self.approach == "orderList")
            {
//                if(obj.trackStatus == 1)
//                {
//                    cellNew.btnTrack.isHidden = false
//                }
//                else
//                {
//                    cellNew.btnTrack.isHidden = true
//                }
                
                cellNew.btnCencel.isEnabled = true
            }
            else
            {
                cellNew.btnTrack.isHidden = true
                cellNew.btnCencel.isEnabled = false
                cellNew.btnCencel.setTitle(status, for: .normal)
            }
            
            cellNew.titleBookedOn.text = DynamicTextHandler.BOOKED_ON
            cellNew.titleServiceDate.text = DynamicTextHandler.SERVICE_DATE
            cellNew.titleServices.text = DynamicTextHandler.ORDER_TYPE
            cellNew.hideAnimation()
            //            let frame = CGRect(x: cellNew.btnCencel.frame.origin.x, y: cellNew.btnCencel.frame.origin.y, width: cellNew.btnCencel.frame.size.width+3, height: cellNew.btnCencel.frame.size.height)
            //            cellNew.btnCencel.frame = frame
        }
        else
        {
            cellNew.showAnimation()
        }
        
        return cellNew
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 302.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func setCollection_Layout(collc:UICollectionView,layouts:NSLayoutConstraint)
    {
        let height = collc.collectionViewLayout.collectionViewContentSize.height
        layouts.constant = height
        // self.view.setNeedsLayout()
    }
}





extension OrderListVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let count = apiData?[collectionView.tag].suborders?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_CellCollection", for: indexPath)as! CellClass_CellCollection
        
        let data = apiData?[collectionView.tag]
        let obj = data?.suborders
        if (obj?.count ?? 0 > 0)
        {
//            let serviceData = obj![indexPath.item]
//            //cellnew.lblSrviceName.text = serviceData.name
//            cellnew.lblSrviceName.text = serviceData.service?.name
//
//
//            //  cellnew.lblDate.text = data?.bookingDate
//            //  cellnew.lblTime.text = data?.timing
//
//            cellnew.lblQuantity.text = "Quantity: \(serviceData.quantity ?? "N/A")"
//            // cellnew.lblQuantity.text = "Quantity: N/A"
//
//            let img = serviceData.service?.icon ?? ""
//            // let img = serviceData.icon ?? ""
//            cellnew.iv.setImage(with: img, placeholder: kplaceholderImage)
//            cellnew.iv.CornerRadius(radius: 10.0)
        }
        
        
        return cellnew
    }
    
    
    
    
}

extension OrderListVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let wdth = collectionView.frame.size.width-2
        return CGSize(width: wdth, height: 96)
    }
}
