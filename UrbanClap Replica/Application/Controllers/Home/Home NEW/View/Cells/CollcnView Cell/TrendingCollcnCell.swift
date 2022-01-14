
//

import UIKit

class TrendingCollcnCell: UICollectionViewCell
{
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var iv: UIImageView!
    @IBOutlet var btnTapOnCell: UIButton!
    
    
   func hideAnimation()
    {
        [self.iv,lblName].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.iv,lblName].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}
