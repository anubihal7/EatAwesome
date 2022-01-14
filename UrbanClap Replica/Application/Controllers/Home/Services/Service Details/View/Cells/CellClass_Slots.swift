
//

import UIKit

class CellClass_Slots: UICollectionViewCell
{
    
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewBG: UIView!
    
    
    
    func hideAnimation()
    {
        [self.viewBG].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.viewBG].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
