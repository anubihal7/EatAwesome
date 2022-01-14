
//

import UIKit

class CellClass_Categories: UICollectionViewCell
{
    
    @IBOutlet var lblViewAll: UILabel!
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var ivCat: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func hideAnimation()
    {
        [self.lblName,self.ivCat].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblName,self.ivCat].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
}
