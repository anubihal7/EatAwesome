//
//

import UIKit

class RecentReviewCollectionCell: UICollectionViewCell {
    //MARK:- Outlet And Variables
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var viewStar: UIView!
    @IBOutlet weak var btnBook: CustomButton!
    
   //MARK:- Actions
    @IBAction func BookAction(_ sender: Any)
    {
    }
}
