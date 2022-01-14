
//

import UIKit
import MarqueeLabel

class TableVendors: UITableViewCell
{

    @IBOutlet var viewBG: UIView!
    @IBOutlet var ivVendor: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblOff: UILabel!
    @IBOutlet var ivRate: UIImageView!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTags: MarqueeLabel!
    @IBOutlet var lblPastOrders: UILabel!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.viewBG.layer.cornerRadius = 15
        self.viewBG.layer.masksToBounds = true
        self.viewBG.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBG.layer.borderWidth = 0.5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
