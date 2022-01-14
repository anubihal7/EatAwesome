//

//

import UIKit
import Cosmos

class CellClass_RatingList: UITableViewCell
{

    @IBOutlet var ivUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewRating: CosmosView!
    @IBOutlet var lblDes: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

    func hideAnimation()
    {
        [self.viewRating,self.ivUser].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.viewRating,self.ivUser].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
