
//

import UIKit
import PayUMoneyCoreSDK
import PlugNPlay
import CryptoSwift
import Foundation

class MembershipVC: CustomController {
    
    @IBOutlet weak var viewpopUp: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var scroll_View: UIScrollView!
    @IBOutlet weak var tblViewList: UITableView!
    var viewModel:MembershipViewModel?
    var apiData : [MemList]?
    var subscriptionPlan : [SubscriptionDuration]?
    @IBOutlet weak var collectionViewPlans: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    var user_Subscription: UserSubscription?
    var merchantKey = "7001862"
    var salt = "hlAIVpWKGy"
    var PayUBaseUrl = "https://test.payu.in"
    var date = Date()
    var formatter = DateFormatter()
    var endDates = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM dd, yyyy"
        self.viewModel = MembershipViewModel.init(Delegate: self, view: self)
        tblViewList.tableFooterView = UIView()
        tblViewList.separatorColor = UIColor.clear
        collectionViewPlans.layer.cornerRadius = 20
        collectionViewPlans.clipsToBounds = true
        viewpopUp.layer.cornerRadius = 20
        viewpopUp.clipsToBounds = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        // btnBack.addTarget(self, action:#selector(self.revealViewController().revealToggle(self)), for: .touchUpInside)
        
        getdata()
        setDates()
        
        
        
        
    }
    
    
    @IBAction func actiontap(_ sender: UIButton)
    {
        viewBack.isHidden = true
        viewpopUp.isHidden = true
    }
    
    func setDates() {
        guard let dateMonth = NSCalendar.current.date(byAdding: .month, value: 6, to: NSDate() as Date) else { return  }  //dateByAddingUnit(.Month, value: 1, toDate: NSDate(), options: [])
        let result = formatter.string(from: dateMonth)
        endDates.append(result)
        
        guard let dateMonth1 = NSCalendar.current.date(byAdding: .month, value: 1, to: NSDate() as Date) else { return  }  //dateByAddingUnit(.Month, value: 1, toDate: NSDate(), options: [])
        let result1 = formatter.string(from: dateMonth1)
        endDates.append(result1)
        
        guard let dateMonth2 = NSCalendar.current.date(byAdding: .month, value: 12, to: NSDate() as Date) else { return  }  //dateByAddingUnit(.Month, value: 1, toDate: NSDate(), options: [])
        let result2 = formatter.string(from: dateMonth2)
        endDates.append(result2)
        
        
    }
    
    //MARK:-Tap gesture for swrevealcontroller
    override func setTapGestureOnSWRevealontroller(view: UIView,controller: UIViewController)
    {
        view.endEditing(true)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: self.view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
        let revealController: SWRevealViewController? = revealViewController()
        let tap: UITapGestureRecognizer? = revealController?.tapGestureRecognizer()
        tap?.delegate = controller as? UIGestureRecognizerDelegate
        self.revealViewController().panGestureRecognizer().isEnabled = false
        self.revealViewController().tapGestureRecognizer().isEnabled = true
        view.addGestureRecognizer(tap!)
        
    }
    
    func getdata()
    {
        self.viewModel?.getPlans()
    }
    
    
    @IBAction func actionPayNow(_ sender: UIButton)
    {
        let alradyBuy = self.checkIfUserAlreadyBoughtPlan()
        if(alradyBuy == true)
        {
            self.showAlertMessage(titleStr: kOops, messageStr: "Sorry, You already have an active plan, In order to change the plan you must wait for its expiration date!")
        }
        else
        {
            makePayment(sendertag: sender.tag)
        }
    }
    
    
    
    @IBAction func actionBack(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)
        
    }
    
    
    
    
    
    
    @IBAction func actionMyPlan(_ sender: UIButton)
    {
        viewBack.isHidden = false
        viewpopUp.isHidden = false
        
    }
    
    
    func makePayment(sendertag : Int)
    {
        let trscnID = self.generateRandomString()
        PlugNPlay .setMerchantDisplayName("Payment")
        
        //Customize UI of PayuMoney
        
        PlugNPlay .setButtonTextColor(UIColor.white)
        PlugNPlay .setButtonColor(Appcolor.get_category_theme())
        PlugNPlay .setTopTitleTextColor(UIColor.white)
        PlugNPlay .setTopBarColor(Appcolor.get_category_theme())
        PlugNPlay .setDisableCompletionScreen(true)
        PlugNPlay.setExitAlertOnBankPageDisabled(true)
        PlugNPlay.setExitAlertOnCheckoutPageDisabled(true)
        
        let txnParam = PUMTxnParam()
        txnParam.phone = "9992364445"
        txnParam.email = "cerebrumdev3@gmail.com"
        // txnParam.amount = self.couponDetails?.payableAmount
        txnParam.amount = subscriptionPlan?[sendertag].price
        // txnParam.environment = PUMEnvironment.test
        txnParam.environment = PUMEnvironment.test
        txnParam.firstname = "Salon App"
        txnParam.key = "vnlMA5F0"
        txnParam.merchantid = "7001862"
        txnParam.txnID = trscnID
        txnParam.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        txnParam.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        txnParam.productInfo = "Salon App"
        txnParam.udf1 = "as"
        txnParam.udf2 = "sad"
        txnParam.udf3 = "ud3"
        txnParam.udf4 = ""
        txnParam.udf5 = ""
        txnParam.udf6 = ""
        txnParam.udf7 = ""
        txnParam.udf8 = ""
        txnParam.udf9 = ""
        txnParam.udf10 = ""
        
        
        let hashSequence = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo! )|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)|\(txnParam.udf6!)|\(txnParam.udf7!)|\(txnParam.udf8!)|\(txnParam.udf9!)|\(txnParam.udf10!)|\(salt)"
        
        let data = hashSequence.data(using: .utf8)
        
        txnParam.hashValue = data?.sha512().toHexString()
        
        
        PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self)
        { (response, error, extraParam) in
            
            
            if (response != nil)
            {
                if let dict : Dictionary = response
                {
                    print(dict)
                    
                    let result = dict["result"]as? NSDictionary
                    let status  = result?.value(forKey: "status")as? String
                    
                    if (status == "success")
                    {
                        self.createOrder(sender_tag: sendertag)//creating order after payment successfull
                    }
                    else
                    {
                        let reason = self.get_transaction_failed_reason(dicnry: result ?? NSDictionary())
                        self.showAlertMessage(titleStr: kAppName, messageStr: reason)
                    }
                }
                else
                {
                    self.showAlertMessage(titleStr: kAppName, messageStr: kSomthingWrong)
                }
            }
            else
            {
                self.showAlertMessage(titleStr: "Sorry", messageStr: error?.localizedDescription ?? "Payment failed!")
            }
            
            print(error?.localizedDescription as Any)
        }
        
    }
    
    
    func createOrder(sender_tag : Int)
    {
        var obj : [String:Any]?
        if let dix = subscriptionPlan?[sender_tag]
        {
            obj = ["subscriptionId": apiData?[0].id!,
                   "amount": dix.price!,
                   "durationId": dix.id!]
        }
        
        WebService.Shared.PostApi(url: APIAddress.PaymentMem, parameter: obj! , Target: self, completionResponse: { response in
            Commands.println(object: response)
            self.StopIndicator()
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    self.getdata()
                    self.showToastSwift(alrtType: .success, msg: "Thanks for the payment. Now you are a paid member of \(kAppName)", title: "")
                    
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
    
    func checkIfUserAlreadyBoughtPlan()-> Bool
    {
        var isAlreadyBuy = Bool()
        
        if(apiData?.count ?? 0 > 0)
        {
            for obj in self.apiData!
            {
                let plan = obj.userSubscription?.amount
                
                if(plan != nil)
                {
                    isAlreadyBuy = true
                    break
                }
            }
        }
        
        return isAlreadyBuy
    }
}

extension MembershipVC: MembershipVCDelegate
{
    func getData(list: [MemList]) {
        if list.count > 0 {
            apiData = list
            user_Subscription = apiData?[0].userSubscription
            subscriptionPlan = apiData?[0].subscriptionDurations
            self.collectionViewPlans.reloadData()
            self.tblViewList.delegate = self
            self.tblViewList.dataSource = self
            self.tblViewList.animateReload()
            
        }
        
    }
    
    func nothingFound() {
        
    }
    
    
}


//MARK:- CollectionView Delegate

extension MembershipVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return subscriptionPlan?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! MemCell
        cell.lblTitle.text = subscriptionPlan?[indexPath.row].duration
        
        cell.btnPay.layer.cornerRadius = 16
        cell.btnPay.clipsToBounds = true
        cell.btnPay.tag  = indexPath.row
        let result = formatter.string(from: date)
        
        cell.lblStartDate.text = "Starts on" + " " + result
        
        if subscriptionPlan?[indexPath.row] != nil {
            if let dic = subscriptionPlan?[indexPath.row] {
                cell.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(String(describing: dic.price!))" }}
        cell.lblBenefits.text = apiData?[0].features?[0]
        for (index, value) in (apiData?[0].features?.enumerated())! {
            if index == 0 {
                cell.lblBenefits.text =  value
            }
            else {
                cell.lblBenefits.text = (cell.lblBenefits.text ?? "") + ", " + value
                
            }
            
            cell.lblEndDate.text = "Expires on" + " " + endDates[indexPath.row]
        }
        
        //  cell.lblStartDate.text = apiData?[indexPath.row].subscriptionDuration.
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->
        CGSize {return CGSize(width: self.collectionViewPlans.frame.origin.x + self.collectionViewPlans.frame.size.width - 20, height: 385.00)}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
extension MembershipVC : UICollectionViewDelegateFlowLayout{
    
}
extension MembershipVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! MyPlanCell
        
        if user_Subscription != nil
        {
            cell.lblPrice.text = user_Subscription?.amount
            if let dic = user_Subscription {
                
                if dic.duration == 1 {
                    cell.lblPlanName.text = "For \(String(describing: dic.duration!)) month"
                }
                else {
                    cell.lblPlanName.text = "For \(String(describing: dic.duration!)) months"
                    
                }
                cell.lblStartDate.text = "Starts from \(String(describing: dic.startDate!))"
                cell.lblEndDate.text = "Expires on \(String(describing: dic.endDate!))"
                
            }
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 175
    }
    
    
}
