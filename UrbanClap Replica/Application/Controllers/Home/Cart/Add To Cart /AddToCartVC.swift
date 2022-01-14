
//

import UIKit
import BottomPopup
import GMStepper
import Lottie

protocol UpdateViewAfterAddCart_Delegate
{
    func refreshController(text:String)
}

class AddToCartVC: BottomPopupViewController
{
    
    @IBOutlet var viewCart: UIView!
    @IBOutlet var stepper: GMStepper!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnContinue: CustomButton!
    
    var delegateInstructions: UpdateViewAfterAddCart_Delegate?
    var previousValueStepper = 0
    var originalPrice = 0
    var price = 0
    var serviceID = ""
    var compID = ""
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(500) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(20) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.6 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.6 }
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    let animationView = AnimationView(name: "orderSuccess")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.originalPrice = self.price
        self.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(self.price)"
        self.btnContinue.backgroundColor = Appcolor.get_category_theme()
        self.stepper.buttonsBackgroundColor = Appcolor.get_category_theme()
        
        // Do any additional setup after loading the view.
    }
    
    func playAnimation()
    {
        animationView.frame = viewCart.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        viewCart.addSubview(animationView)
    }
    
    func startAnimating()
    {
        //orderSuccess
        UIView.transition(with: self.viewCart, duration: 1.0,
                options: .curveEaseInOut,
                animations: {
                    self.viewCart.isHidden = false
                    self.animationView.play()
                    self.hideViewAuto()
            })
    }
    
    @IBAction func acnHideView(_ sender: Any)
    {
        self.delegateInstructions?.refreshController(text: kSaved)
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideViewAuto()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
        {
            self.delegateInstructions?.refreshController(text: kSaved)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
       playAnimation()
    }
    
    @IBAction func actionStepper(_ sender: GMStepper)
    {
        let val = Int(sender.value)
        
        if (val == 0)
        {
            self.price = originalPrice
            self.lblPrice.text = ""
            self.previousValueStepper = 0
            self.showToastSwift(alrtType: .statusOrange, msg: "Minimum quantity should be one", title: "")
        }
        else
        {
            if (val > 5)
            {
                   self.showToastSwift(alrtType: .statusOrange, msg: "You cant add more than 5 items.", title: "")
            }else
            {
                self.handlePrice()
            }
            
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any)
    {
        let qnty = Int(stepper.value)
        self.AddServiceToCart(serviceID: serviceID, Price: "\(self.originalPrice)", Quantity: "\(qnty)", TotalPrice: "\(self.price)")
    }
    
    func handlePrice()
    {
        if Int(stepper.value) > previousValueStepper
        {
            if (Int(stepper.value) == 1)
            {
                self.price = originalPrice
                self.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(self.price)"
            }
            else  if (Int(stepper.value) == 0)
            {
                self.price = originalPrice
                self.lblPrice.text = ""
            }
            else
            {
                self.price = self.price + originalPrice
                self.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(self.price)"
            }
        }
        else
        {
            if (Int(stepper.value) == 1)
            {
                self.price = originalPrice
                self.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(self.price)"
            }
            else  if (Int(stepper.value) == 0)
            {
                self.price = originalPrice
                self.lblPrice.text = ""
            }
            else
            {
                self.price = self.price - originalPrice
                self.lblPrice.text = "Price: \(AppDefaults.shared.currency)\(self.price)"
            }
        }
        
        previousValueStepper = Int(stepper.value)
    }
    
    
    func AddServiceToCart(serviceID:String,Price:String,Quantity:String,TotalPrice:String)
    {
        let status = self.getDeliveryTypeStatus()
        let obj : [String:Any] = ["serviceId":serviceID,"orderPrice":Price,"quantity":Quantity,"orderTotalPrice":TotalPrice,"deliveryType":status,"companyId":self.compID,"vendorType":kvendorType]
        
        
        WebService.Shared.PostApi(url: APIAddress.ADD_TO_CART, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? "success"
                
                if (code == 200)
                {
                   // self.showToastSwift(alrtType: .success, msg: msg, title: "")
                    var cartCount = AppDefaults.shared.cartCount
                    cartCount = cartCount+1
                    AppDefaults.shared.cartCount = cartCount
                    
                    self.delegateInstructions?.refreshController(text: kSaved)
                    self.startAnimating()
                   // self.dismiss(animated: true, completion: nil)
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
