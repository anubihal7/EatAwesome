//
//

import UIKit

class EventsCollectionCell: UICollectionViewCell
{
    @IBOutlet var ivBannerBG: UIImageView!
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    
    func hideAnimation()
    {
        [self.ivBannerBG,lblEventName,lblDesc].forEach
            {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivBannerBG,lblEventName,lblDesc].forEach
            {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}
