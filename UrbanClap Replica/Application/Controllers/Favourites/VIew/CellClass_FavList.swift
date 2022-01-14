
//

import UIKit
import SkeletonView
import Cosmos


class CellClass_FavList: UITableViewCell
{
    
    @IBOutlet var ivVeg: UIImageView!
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnOrderAgain: CustomButton!
    @IBOutlet var ivCat: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var lblPrice: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
//        self.layer.cornerRadius = 10
//        self.layer.borderColor = UIColor.gray.cgColor
//        self.layer.borderWidth = 1
//
        self.btnOrderAgain.backgroundColor = Appcolor.get_category_theme()
        self.btnOrderAgain.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
    }
    
    
    func hideAnimation()
    {
        [self.ratingView,self.btnDelete].forEach
        {
                $0?.hideSkeleton()
        }
    }
    
    func showAnimation()
    {
        [self.ratingView,self.btnDelete].forEach
        {
                $0?.showAnimatedGradientSkeleton()
        }
    }
}

