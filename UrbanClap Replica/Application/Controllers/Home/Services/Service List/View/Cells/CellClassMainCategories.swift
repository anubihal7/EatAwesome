
//

import UIKit

class CellClassMainCategories: UICollectionViewCell
{
    @IBOutlet var iv: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    
    func hideAnimation()
    {
        [self.lblName,iv].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblName,iv].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
}
