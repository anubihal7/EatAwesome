
//

import UIKit
import Cosmos
import MarqueeLabel


class VendorsNewTableCell: UITableViewCell
{
    
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblRatingas: UILabel!
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var ivDish: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var lblCurrentOffer: UILabel!
    @IBOutlet var offerView: UIView!
    @IBOutlet var lblMarquee: MarqueeLabel!
    @IBOutlet var viewBottomLeftCorner: UIView!
    @IBOutlet var pastOrders: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
       // self.offerView.backgroundColor = Appcolor.get_category_theme()
        self.pastOrders.textColor = Appcolor.get_category_theme()
        self.lblMarquee.backgroundColor = UIColor.clear
        self.lblMarquee.textColor = UIColor.lightGray
       // self.lblName.textColor = self.lblMarquee.textColor
        self.viewBottomLeftCorner.roundCorners_BottomLeft(val: 10)
       // self.lblMarquee.roundCornersBOTTOMLEFT(val: 10)
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func hideAnimation()
    {
        [self.lblAddress,self.ivDish,lblName,lblTime,lblCurrentOffer].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblAddress,self.ivDish,lblName,lblTime,lblCurrentOffer].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
    
}

