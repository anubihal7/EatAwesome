
//

import UIKit
import SkeletonView

class CellClass_AddressList: UITableViewCell
{
    
    @IBOutlet var ivMarker: UIImageView!
    @IBOutlet var btnDefault: UIButton!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

    
    func hideAnimation()
    {
        [self.lblType,self.lblLocation,self.btnDelete,self.btnDefault].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblType,self.lblLocation,self.btnDelete,self.btnDefault].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
