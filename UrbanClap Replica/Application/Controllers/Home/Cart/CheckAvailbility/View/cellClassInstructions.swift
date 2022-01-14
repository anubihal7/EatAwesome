//

//

import UIKit

class cellClassInstructions: UITableViewCell
{

    @IBOutlet var ivTick: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTXT: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    func hideAnimation()
//    {
//        [self.ivTick,self.lblTitle,lblTXT].forEach
//            {
//                $0?.hideSkeleton()
//        }
//    }
//    
//    func showAnimation()
//    {
//        [self.ivTick,self.lblTitle,lblTXT].forEach
//            {
//                $0?.showAnimatedGradientSkeleton()
//        }
//    }

}
