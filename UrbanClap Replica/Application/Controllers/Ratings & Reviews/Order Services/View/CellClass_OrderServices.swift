
//

import UIKit
import Cosmos

class CellClass_OrderServices: UITableViewCell
{
    
    @IBOutlet var rateView: CosmosView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var ivService: UIImageView!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var viewTapToRate: CustomUIView!
    @IBOutlet var lblRated: UILabel!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

    }

    
    func hideAnimation()
    {
        [self.rateView,self.ivService].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.rateView,self.ivService].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
}
