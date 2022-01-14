//

//

import UIKit

class CellClass_Addones: UICollectionViewCell
{
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var btnAdd: ButtonWithShadowAndRadious!
    @IBOutlet var ivAddones: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
       // self.backgroundColor = kpinkTheme
        self.layer.masksToBounds = true
    }
    
    
    func hideAnimation()
    {
        [self.ivAddones,self.lblName,lblQuantity].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivAddones,self.lblName,lblQuantity].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
}
