/
//

import UIKit

class TopPicksCollcnCell: UICollectionViewCell
{
    
    @IBOutlet var ivDish: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnTapOnCell: UIButton!
    
    
    func hideAnimation()
    {
        [self.ivDish,lblName].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivDish,lblName].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}
