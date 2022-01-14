//

//

import UIKit
import SkeletonView

class CellClass_HomeVC : UITableViewCell
{
    @IBOutlet var ivCat: UIImageView!
    @IBOutlet var lblCatNamme: UILabel!
    
    
    func hideAnimation()
    {
        [self.lblCatNamme,self.ivCat].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.lblCatNamme,self.ivCat].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    
}
