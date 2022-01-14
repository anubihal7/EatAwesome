//

//

import UIKit
import Cosmos

class CellClass_CartDetails: UITableViewCell
{
    
    @IBOutlet var iv: UIImageView!
    @IBOutlet var lblNamer: UILabel!
    @IBOutlet var viewRatings: CosmosView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var viewBG: UIView!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.viewBG.layer.cornerRadius = 10
        self.viewBG.layer.borderColor = Appcolor.kTextColorGrayDark.cgColor
        self.viewBG.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
