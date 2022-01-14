
//

import UIKit
import Cosmos
import MarqueeLabel

class BestSellerTableCell: UITableViewCell
{

    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var ivDish: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblMarquee: MarqueeLabel!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var viewBottomCorner: UIView!
    @IBOutlet var lblPastOrders: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // self.lblMarquee.textColor = Appcolor.get_category_theme()
        
        self.lblMarquee.type = .continuous
        self.lblMarquee.backgroundColor = UIColor.clear
        self.lblPastOrders.textColor = Appcolor.get_category_theme()
        self.lblMarquee.textColor = UIColor.lightGray
       // self.lblName.textColor = self.lblMarquee.textColor
        self.viewBottomCorner.roundCorners_BottomLeft(val: 10)
       // self.lblMarquee.roundCornersBOTTOMLEFT(val: 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   func hideAnimation()
    {
        [self.lblAddress,self.ivDish,lblName,lblTime].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblAddress,self.ivDish,lblName,lblTime].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }

}
