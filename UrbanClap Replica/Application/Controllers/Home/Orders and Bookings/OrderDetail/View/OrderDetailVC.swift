
//

import UIKit
import SDWebImage
import Lottie

class OrderDetailVC: CustomController {
    
    @IBOutlet var btnReOrder: ButtonWithShadowAndRadious!
    @IBOutlet var lblPVotes: UILabel!
    @IBOutlet var btnComplete: ButtonWithShadowAndRadious!
    @IBOutlet var btnTrackOrder: ButtonWithShadowAndRadious!
    @IBOutlet weak var imgViewBanner: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var AnimView: UIView!
    @IBOutlet weak var lblStarus: UILabel!
    @IBOutlet weak var tblViewOrderItems: UITableView!
    @IBOutlet weak var LblServiceDate: UILabel!
    @IBOutlet weak var lblBookedDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var scroll_View: UIScrollView!
    @IBOutlet weak var imgDeliverDetail: UIImageView!
    @IBOutlet weak var imgDeliverName: UILabel!
    @IBOutlet weak var RatingCount: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var orderDelivered: UILabel!
    
    @IBOutlet weak var viewBGG: UIView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    
    var orderCompleted = false
    
    @IBOutlet weak var lblPayStatus: UILabel!
    var viewModel:OrderDetailViewModel?
    var orderId : String = ""
    var orderStatus : String = "pending"
    var OrderDetailData : OrderDetail?
    @IBOutlet weak var heightViewBG: NSLayoutConstraint!
    
    //var  animationView  =   AnimationView(name: orderStatus)//
    
    @IBOutlet weak var lblOrderDeliveredCountDD: UILabel!
    var animationView = AnimationView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showNAV_BAR(controller: self)
        self.viewModel = OrderDetailViewModel.init(Delegate: self, view: self)
        self.viewModel?.getOrderDetail(id: orderId)
        tblViewOrderItems.allowsSelection = false
        
        
        self.btnTrackOrder.backgroundColor = Appcolor.get_category_theme()
        self.btnComplete.backgroundColor = Appcolor.get_category_theme()
        self.btnReOrder.backgroundColor = Appcolor.get_category_theme()
        self.btnTrackOrder.updateLayerProperties()
        self.btnComplete.updateLayerProperties()
      //  self.btnReOrder.updateLayerProperties()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        //animationView.center = self.viewLottie.center
        
        startAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func actionTrackOrder(_ sender: Any)
    {
        
        let dropLAT = Double(OrderDetailData?.body.address?.latitude ?? "0.0")
        let dropLONG = Double(OrderDetailData?.body.address?.longitude ?? "0.0")
        
        
        //these object creating problems in parsing data. So I have desabled them for now
        let strtLAT = Double(OrderDetailData?.body.company?.latitude ?? 0.0)
        let strtLONG = Double(OrderDetailData?.body.company?.longitude ?? 0.0)
        
        let orderID = OrderDetailData?.body.id
        
        let controller = Navigation.GetInstance(of: .TrackOrderVC)as!TrackOrderVC
        
        controller.stop_lat = dropLAT ?? 0.0
        controller.stop_long = dropLONG ?? 0.0
        controller.start_lat = strtLAT
        controller.start_long = strtLONG 
        controller.orderid = orderID ?? "0"
        
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @IBAction func acnReOrder(_ sender: Any)
    {
        self.AlertMessageWithOkCancelAction(titleStr: "Reminder", messageStr: "Do you want to reorder it?", Target: self)
        { (actn) in
            if (actn == KYes)
            {
                self.viewModel?.OrderAgain(orderID: self.OrderDetailData?.body.id ?? "")
            }
        }
    }
    
    
    func setData() {
        //OrderDetailData?.body.
        if let imgProfileUrl = OrderDetailData?.body.company?.logo1 {
            let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            imgViewBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgViewBanner.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                if error == nil
                {
                    self.imgViewBanner.contentMode = .scaleToFill
                    self.imgViewBanner.image = img
                }
                else
                {
                    self.imgViewBanner.image = UIImage(named: "bgFood")
                }
            }
        }
        lblName.text = OrderDetailData?.body.company?.companyName
        
        let rateD = Double(OrderDetailData?.body.company?.rating ?? "0.0") ?? 0.0
        let rate = CGFloat(rateD)
        
        lblRating.text = "\(rate.cleanValue)"
        lblLocation.text = OrderDetailData?.body.company?.address1
        lblStarus.text = OrderDetailData?.body.orderStatus?.statusName
        
        if OrderDetailData?.body.refundType == 1
        {
            lblStarus.text = "Refunded"
        }
        
        let intvals = self.strToDate_Bookings(strDate: OrderDetailData?.body.createdAt ?? "")
        lblBookedDate.text = intvals
        if  OrderDetailData?.body.paymentType == 2
        {
            lblPayStatus.text = "Cash On Delivery"
        }else {
            lblPayStatus.text = "Paid"
        }
        
        
        let intvalss = self.strToDate_Bookings(strDate: OrderDetailData?.body.serviceDateTime ?? "")
        LblServiceDate.text = intvalss
        if OrderDetailData?.body.orderStatus?.status == 5 {
            self.btnComplete.isHidden = true
            
        }else
        {
            if(orderCompleted == false)
            {
               self.btnComplete.isHidden = false
            }
            else
            {
               self.btnComplete.isHidden = true
            }
            
        }
        //lblBookedDate.text = OrderDetailData?.body.
        lblTotal.text = "\(AppDefaults.shared.currency)" + (OrderDetailData?.body.totalOrderPrice ?? "")
        
        lblPVotes.text = "(\(OrderDetailData?.body.company?.totalRatings ?? "0") Votes)"
        
        if OrderDetailData?.body.assignedEmployees.count ?? 0 > 0
        {
            if let imgProfileUrl = OrderDetailData?.body.assignedEmployees[0].employee?.image
            {
                let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                imgViewBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgViewBanner.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                    if error == nil
                    {
                        self.imgDeliverDetail.contentMode = .scaleToFill
                        self.imgDeliverDetail.image = img
                    }
                    else
                    {
                        self.imgDeliverDetail.image = UIImage(named: "Profile")
                    }
                }
            }
            
            if OrderDetailData?.body.assignedEmployees != nil
            {
                imgDeliverName.text = (OrderDetailData?.body.assignedEmployees[0].employee?.firstName ?? "") + " " + (OrderDetailData?.body.assignedEmployees[0].employee?.lastName ?? "" )
                RatingCount.text = (OrderDetailData?.body.assignedEmployees[0].employee?.totalRatings ?? "0") + " " + "Ratings"
                lblVotes.text =  "0" + " " + "Votes"
                lblPhoneNumber.text = OrderDetailData?.body.assignedEmployees[0].employee?.phoneNumber
                lblOrderDeliveredCountDD.text = (OrderDetailData?.body.assignedEmployees[0].employee?.totalOrders ?? "0") + " " + "orders delivered" }
            
        }
        else
        {
            imgDeliverName.text = "Not assigned yet"
            // RatingCount.text = "NA"
            // lblVotes.text = "NA"
            lblPhoneNumber.text = "NA"
            //lblOrderDeliveredCountDD.text = "NA"
            self.btnTrackOrder.isHidden = true
            self.imgDeliverDetail.image = UIImage(named: "Profile")
        }
        
        
        
        
        
        if OrderDetailData?.body.suborders.count ?? 0 > 0 {
            heightTable.constant = CGFloat((OrderDetailData?.body.suborders.count)! * 100) + 10
            //tblViewOrderItems.frame.size.height = CGFloat((OrderDetailData?.body.suborders.count)! * 100)
            
            tblViewOrderItems.animateReload()
            scroll_View.contentSize = CGSize(width: scroll_View.frame.size.width, height: scroll_View.frame.size.height + heightTable.constant +  heightTable.constant + 30)
            //heightViewBG.constant = 2000
        }
        
        self.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        startAnimation()
    }
    
    func startAnimation()
    {
        let status =  OrderDetailData?.body.orderStatus?.status
        if status == 0
        {
            animationView = AnimationView(name: "pending")
            self.btnTrackOrder.isHidden = true
        }
        else if status == 1
        {
            animationView = AnimationView(name: "confirmed")
            self.btnTrackOrder.isHidden = true
        }
            else if status == 4
            {
                animationView = AnimationView(name: "processing")
                self.btnTrackOrder.isHidden = true
            }
        else if status == 2
        {
            animationView = AnimationView(name: "order_cancel")
            self.btnTrackOrder.isHidden = true
            self.btnReOrder.isHidden = false
        }
        else if status == 3
        {
            animationView = AnimationView(name: "cooking")
            self.btnTrackOrder.isHidden = true
        }
        else if status == 6
        {
            animationView = AnimationView(name: "cooking")
            self.btnTrackOrder.isHidden = true
        }
        else if status == 7
        {
            animationView = AnimationView(name: "packed")
            self.btnTrackOrder.isHidden = false
        }
        else if status == 8
        {
            animationView = AnimationView(name: "on_the_way")
            self.btnTrackOrder.isHidden = false
        }
        else if status == 5
        {
            animationView = AnimationView(name: "confirmed")
            self.btnReOrder.isHidden = false
            self.btnTrackOrder.isHidden = true
        }
        else if status == 9
        {
            animationView = AnimationView(name: "waiting")
            self.btnTrackOrder.isHidden = true
        }
        
        // animationView.frame = CGRect(x: AnimView.frame.origin.x, y: AnimView.frame.origin.y, width: 100, height: 113)
        animationView.frame = self.AnimView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        AnimView.addSubview(animationView)
        animationView.play()
        
        // self.btnTrackOrder.isHidden = false
    }
    
    @IBAction func completeOrder(_ sender: CustomButton) {
        // checking status pending,processing,confirmed for complete order
        if (OrderDetailData?.body.orderStatus?.status == 7 || OrderDetailData?.body.orderStatus?.status == 9 || OrderDetailData?.body.orderStatus?.status == 10 || OrderDetailData?.body.orderStatus?.status == 8)
        {
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Do you want to complete this order?", Target: self)
            { (actn) in
                if (actn == KYes)
                {
                    //   if let aa  = self.OrderDetailData?.body.orderStatus.status {
                    self.viewModel?.completeOrder(orderId: self.orderId,stts:  "5") }
                //}
            }
        }
        else
        {
            self.showAlertMessage(titleStr: "Sorry", messageStr: "This order cannot be updated for this time!")
        }
    }
    
    @IBAction func makeCall(_ sender: Any)
    {
        if(lblPhoneNumber.text == "NA" || lblPhoneNumber.text?.count == 0 || lblPhoneNumber.text == "N/A")
        {
            self.showToastSwift(alrtType: .info, msg: "Driver not available", title: kOops)
        }
        else
        {
            var txt = lblPhoneNumber.text ?? ""
            txt = txt.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
            
            
            if let url = URL(string: "tel://\(txt)"),UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10, *)
                {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                }
                else
                {
                    UIApplication.shared.openURL(url)
                }
            }
            else
            {
                // add error message here
            }
        }
    }
    
}


extension OrderDetailVC: OrderDetailVCDelegate {
    func getData(data: OrderDetail) {
        OrderDetailData = data
        setData()
    }
    
    func nothingFound() {
        
    }
    
}



extension OrderDetailVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if OrderDetailData?.body.suborders.count ?? 0 > 0{
            return (OrderDetailData?.body.suborders.count ?? 0)
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        cell.itemName.text = OrderDetailData?.body.suborders[indexPath.row].service?.name
        cell.qauitity.text = "Quantity :" + " " + (OrderDetailData?.body.suborders[indexPath.row].quantity ?? "")
        if let imgProfileUrl = OrderDetailData?.body.suborders[indexPath.row].service?.thumbnail {
            let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgView.sd_setImage(with: URL.init(string: url)) { (img, error, cacheType, url) in
                if error == nil {
                    cell.imgView.contentMode = .scaleToFill
                    cell.imgView.image = img
                }else{
                }
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

