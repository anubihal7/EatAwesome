
//

import UIKit

class CellClass_Offers: UICollectionViewCell
{
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var ivOffers: UIImageView!
    @IBOutlet var lblOff: UILabel!
    @IBOutlet var lblOffCode: UILabel!
    
    func hideAnimation()
    {
        [self.ivOffers].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivOffers].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    
    
}
