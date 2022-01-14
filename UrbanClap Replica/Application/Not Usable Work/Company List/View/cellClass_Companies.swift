//
//
//

import UIKit

class cellClass_Companies: UICollectionViewCell
{
    @IBOutlet var lblName: UILabel!
    @IBOutlet var ivImg: UIImageView!
    
    
    func setUI(lbl:UILabel)
    {
        lbl.layer.cornerRadius = 10
        lbl.layer.borderColor = Appcolor.kTextColorWhite.cgColor
        lbl.layer.borderWidth = 1
        lbl.textColor = Appcolor.kTextColorWhite
    }
}
