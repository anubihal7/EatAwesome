
//

import UIKit

class CollectionMenu: UICollectionViewCell
{
    
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblName.layer.cornerRadius = 15
        self.lblName.layer.masksToBounds = true
        self.lblName.textColor = UIColor.white
        // Initialization code
    }
    
}
