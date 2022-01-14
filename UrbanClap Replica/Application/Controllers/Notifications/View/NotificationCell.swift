//
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var llblDescription: UILabel!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowRadius = 5
                self.layer.shadowOpacity = 0.40
                self.layer.masksToBounds = false;
                self.clipsToBounds = false;
               
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
