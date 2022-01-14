//


import UIKit
import Cosmos
import GMStepper

class CellClass_CartList: UITableViewCell
{
    
    @IBOutlet var iv: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblQuantity: UILabel!
    

    @IBOutlet weak var viewStepper: GMStepper!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
       // self.viewBG.layer.cornerRadius = 10
       // self.viewBG.layer.borderColor = Appcolor.kTextColorGrayDark.cgColor
       // self.viewBG.layer.borderWidth = 0.5
        // Initialization code
        
         viewStepper.labelFont = UIFont.systemFont(ofSize: 15)
         viewStepper.layer.borderColor = UIColor.lightGray.cgColor
         viewStepper.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

    
    func hideAnimation()
    {
        [self.iv,self.btnDelete].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.iv,self.btnDelete].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
