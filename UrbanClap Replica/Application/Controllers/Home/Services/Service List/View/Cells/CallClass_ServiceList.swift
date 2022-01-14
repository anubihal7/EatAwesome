
//

import UIKit
import SkeletonView
import Cosmos
import GMStepper

class CallClass_ServiceList: UITableViewCell
{
    
    @IBOutlet var viewBg: UIView!
    @IBOutlet var iv: UIImageView!
    @IBOutlet var ivVeg: UIImageView!
    @IBOutlet var ivCat: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnAdd: ButtonWithShadowAndRadious!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet weak var viewStepper: GMStepper!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
       // self.btnAdd.backgroundColor = Appcolor.get_category_theme()
        self.btnAdd.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
       // self.lblPrice.textColor = Appcolor.get_category_theme()
        viewStepper.labelFont = UIFont.systemFont(ofSize: 15)
       // self.layer.cornerRadius = 10
        viewStepper.layer.borderColor = UIColor.lightGray.cgColor
        viewStepper.layer.borderWidth = 0.5
        
        self.viewBg.layer.cornerRadius = 15
        self.viewBg.layer.masksToBounds = true
        self.viewBg.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBg.layer.borderWidth = 0.5
    }
    
    
    func hideAnimation()
    {
        [self.btnLike,iv].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.btnLike,iv].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
    
    
}
