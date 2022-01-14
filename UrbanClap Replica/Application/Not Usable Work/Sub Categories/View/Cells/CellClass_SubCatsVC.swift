//

//

import UIKit
import SkeletonView
import Cosmos

class CellClass_SubCatsVC: UICollectionViewCell
{
    
    @IBOutlet var ivCat: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var ratingView: CosmosView!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
      //  self.btnAdd.backgroundColor = Appcolor.kTheme_Color
      //  self.btnAdd.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }

    
    
    func hideAnimation()
    {
        [self.ivCat,self.ratingView].forEach
        {
            $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ivCat,self.ratingView].forEach
        {
            $0?.showAnimatedGradientSkeleton()
        }
    }

}
