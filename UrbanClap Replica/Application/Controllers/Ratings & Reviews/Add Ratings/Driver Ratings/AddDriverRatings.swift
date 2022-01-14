
//

import UIKit
import BottomPopup
import Lottie
import Cosmos
import KMPlaceholderTextView

class AddDriverRatings: BottomPopupViewController
{
    
    @IBOutlet var animVIEW: UIView!
    @IBOutlet var ivDriver: UIImageView!
    @IBOutlet var lblDriver: UILabel!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var txtView: KMPlaceholderTextView!
    
    var driverJSon : CompletedorderDEC?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(500) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(20) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.6 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.6 }
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    let animationView = AnimationView(name: "waiting")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtView.layer.cornerRadius = 15
        self.txtView.layer.masksToBounds = true
        self.txtView.layer.borderWidth = 0.6
        self.txtView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        playAnimation()
    }
    
    func playAnimation()
    {
        animationView.frame = animVIEW.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animVIEW.addSubview(animationView)
        animationView.play()
    }
    
    func setData()
    {
        //let img = self.driverJSon?.image ?? ""
       // self.ivDriver.setImage(with: img, placeholder: kplaceholderFood)
      //  self.ivDriver.CornerRadius(radius: 15)
      //  self.lblDriver.text = "\(self.driverJSon?.firstName ?? "Driver") \(self.driverJSon?.lastName ?? "")"
    }
    
    @IBAction func acnSubmit(_ sender: Any)
    {
        if(self.viewRate.rating == 0)
        {
            self.showToastSwift(alrtType: .error, msg: "Please add some ratings", title: kOops)
        }
        else
        {
          self.callAPI_ADD_REVIEWS()
        }
        
    }
    
    
    
    
  func callAPI_ADD_REVIEWS()
    {
        let obj = ["rating":"\(self.viewRate.rating)","review":self.txtView.text ?? "","orderId":self.driverJSon?.orderID ?? "","companyId":self.driverJSon?.companyId ?? "","empId":self.driverJSon?.empID ?? ""] as [String : Any]
        
        WebService.Shared.PostApi(url: APIAddress.ADD_DRIVER_RATINGS, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            if let responseData = response as? NSDictionary
            {
                let code = responseData.value(forKey: "code") as? Int ?? 0
                let msg = responseData.value(forKey: "message") as? String ?? ""
                
                if (code == 200)
                {
                    self.showToastSwift(alrtType: .success, msg: msg, title: "")
                    self.dismiss(animated: true, completion: nil)
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
