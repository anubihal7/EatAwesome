
//

import UIKit

class NotificationVC: CustomController
{
    
    var viewModel:NotificationListViewModel?
    var localModel : [NotificationResult]?
    @IBOutlet weak var tblViewNotificationList: UITableView!
   
    @IBOutlet var btnDrawer: UIButton!
    @IBOutlet weak var btnNotification: UIBarButtonItem!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        self.tblViewNotificationList.setEmptyMessage("Notifications not available!")
        fetchNotifications()
        hideNAV_BAR(controller: self)

        // Do any additional setup after loading the view.
    }
    
    func setUpView()
    {
        tblViewNotificationList.tableFooterView = UIView()
        self.viewModel = NotificationListViewModel.init(Delegate: self, view: self)
        self.tblViewNotificationList.isSkeletonable = true
        btnDrawer.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        self.setStatusBarColor(view: self.view, color: kpurpleTheme)
    }
    
    func fetchNotifications()
    {
        self.viewModel?.getNotificationList()
    }
    
    @IBAction func acnDeleteAll(_ sender: Any)
    {
        if (localModel?.count ?? 0 > 0)
        {
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to clear all notification?", Target: self)
            { (actn) in
                if (actn == "Yes")
                {
                    self.viewModel?.deleteNotificationList()
                }
            }
        }
        else
        {
            self.showAlertMessage(titleStr: "Sorry!", messageStr: "Notifications not available")
        }
    }
    
}


extension NotificationVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.localModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell")as! NotificationCell
        if (localModel != nil)
        {
            let obj = localModel![indexPath.row]
            cell.lblTitle.text = obj.notificationTitle
            cell.llblDescription.text = obj.notificationDescription
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
//    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
//
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
}



extension NotificationVC : NotificationVCDelegate
{
    func ShowResults(msg: String)
    {
        self.showAlertMessage(titleStr: kAppName, messageStr: msg)
        self.viewModel?.getNotificationList()
    }
    
    func getData(model: [NotificationResult])
    {
        if model.count > 0
        {
            localModel = model
            tblViewNotificationList.animateReload()
            self.tblViewNotificationList.restore()
        }
        else
        {
           // self.tblViewNotificationList.setEmptyMessage("Notifications not available!")
            self.tblViewNotificationList.setAnimatingImage(fileName: kLottieEmpData ,msg :"Notifications not available!")
        }
    }
    
    
}
