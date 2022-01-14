
//

import UIKit

class CellClass_Details: UITableViewCell
{
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetails: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
