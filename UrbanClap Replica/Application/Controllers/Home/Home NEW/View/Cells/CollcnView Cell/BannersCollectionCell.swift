
//

import UIKit

class BannersCollectionCell: UICollectionViewCell
{
    
    @IBOutlet var ivBanners: UIImageView!
    
    
    func hideAnimation()
    {
        [self.ivBanners].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivBanners].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}
