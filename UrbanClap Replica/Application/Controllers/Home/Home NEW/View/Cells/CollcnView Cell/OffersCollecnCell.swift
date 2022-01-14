
//

import UIKit

class OffersCollecnCell: UICollectionViewCell
{
    
    @IBOutlet var ivOffer: UIImageView!
    @IBOutlet var btnTapOnCell: UIButton!
    
    
    func hideAnimation()
    {
        [self.ivOffer].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivOffer].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}
