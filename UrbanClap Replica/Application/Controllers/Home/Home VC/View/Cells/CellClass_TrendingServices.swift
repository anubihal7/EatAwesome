
//

import UIKit

class CellClass_TrendingServices: UICollectionViewCell
{
    
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var ivService: UIImageView!
    
    func hideAnimation()
    {
        [self.ivService].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivService].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
}
