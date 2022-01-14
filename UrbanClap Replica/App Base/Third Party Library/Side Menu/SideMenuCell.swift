
//

import UIKit

class SideMenuCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet var imgView: UIImageView!
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

}
