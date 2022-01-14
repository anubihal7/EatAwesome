//

//

import UIKit
import BottomPopup
import GMStepper

protocol UpdateViewAfterCouponDetails_Delegate
{
    func refreshController(text:String)
}

class CouponDetailsVC: BottomPopupViewController
{
    
    @IBOutlet var btnOk: CustomButton!
    @IBOutlet var ivOffer: UIImageView!
    @IBOutlet var lblOfferName: UILabel!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblOff: UILabel!
    @IBOutlet var lblDetails: UILabel!
    
    var OfferImg = ""
    var offerName = ""
    var offerCode = ""
    var OfferOff = ""
    var OfferDetails = ""
    
    var delegateDetails: UpdateViewAfterCouponDetails_Delegate?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(500) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(20) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.6 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.6 }
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.btnOk.backgroundColor = Appcolor.get_category_theme()
        
        let data = Data(OfferDetails.utf8)
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        {
            self.lblDetails.attributedText = attributedString
        }
        
        self.lblOff.text = "\(OfferOff)% Off"
        self.lblCode.text = offerCode
        self.lblCode.layer.borderWidth = 2.0
        self.lblCode.layer.borderColor = Appcolor.get_category_theme().cgColor
        self.lblOfferName.text = "Offer Name: \(offerName)"

        self.ivOffer.setImage(with: OfferImg, placeholder: kplaceholderFood)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionDone(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

}
