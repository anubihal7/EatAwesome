//

//

import UIKit
import PayUMoneyCoreSDK
import PlugNPlay
import CryptoSwift

class HomeServiceCheckOutVC: CustomController
{
    
    @IBOutlet var ivMarker: UIImageView!
    @IBOutlet var lblAddressType: UILabel!
    @IBOutlet var btnChangeAddress: CustomButton!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblItmes: UILabel!
    @IBOutlet var btnCheckOut: CustomButton!
    
    var totalItems = 0
    var payPrice = "0"
    var addrssID = ""
    
    var merchantKey = "7001862"
    var salt = "hlAIVpWKGy"
    var PayUBaseUrl = "https://test.payu.in"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func changeAddress(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .ChooseAddressVC) as! ChooseAddressVC
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegateCheckout = self
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func actionCheckOut(_ sender: UIButton)
    {
        if (self.lblAddress.text == "Select Address" || self.lblAddress.text == "")
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Please select your address to proceed")
            sender.shake()
        }
        else
        {
            self.makePayment()
        }
    }
    
    
    
    func makePayment()
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
        txnParam.amount = "1"
        // txnParam.environment = PUMEnvironment.test
        txnParam.environment = PUMEnvironment.production
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
                        self.createOrder()//creating order after payment successfull
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
    
    
    func createOrder()
    {
        let obj : [String:Any] = ["addressId":AppDefaults.shared.userAddressID]
        
        WebService.Shared.PostApi(url: APIAddress.CREATE_ORDER, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                    AppDefaults.shared.serviceType = "" //setting service type refresh for new entries
                    let controller = Navigation.GetInstance(of: .OrderReceivedVC)as! OrderReceivedVC
                    controller.delegateOrderRecvd = self
                    self.present(controller, animated: true, completion: nil)
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
    
    func setUI()
    {
        self.btnCheckOut.backgroundColor = Appcolor.get_category_theme()
        self.btnCheckOut.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        self.lblPrice.textColor = Appcolor.get_category_theme()
        
        self.btnChangeAddress.backgroundColor = Appcolor.get_category_theme()
        self.btnChangeAddress.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        self.lblItmes.text = "\(totalItems)"
        self.lblPrice.text = payPrice
        
        self.addressFound(addrss: AppDefaults.shared.userHomeAddress, type: AppDefaults.shared.userAddressType, adrssID: AppDefaults.shared.userAddressID)
    }
    
}


extension HomeServiceCheckOutVC : UpdateAddressOnCheckout_Delegate
{
    func addressFound(addrss:String,type:String,adrssID:String)
    {
        self.lblAddress.text = addrss
        self.lblAddressType.text = type
        self.addrssID = adrssID
        
        if (self.lblAddressType.text == "" || self.lblAddress.text == "")
        {
            self.lblAddressType.text = "Select Address"
            self.lblAddress.text = ""
        }
        
        if (type == "Home")
        {
            self.ivMarker.image = UIImage(named:"home")
        }
        else if (type == "Work")
        {
            self.ivMarker.image = UIImage(named:"work")
        }
        else
        {
            self.ivMarker.image = UIImage(named:"other")
        }
    }
    
    func goToAddNewAddress()
    {
        let controller = Navigation.GetInstance(of: .AddNewAddressVC) as! AddNewAddressVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
}


extension HomeServiceCheckOutVC : UpdateViewAfterSuccess_Delegate
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
