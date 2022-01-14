
//

import UIKit

class ServiceHelpCollectionCell: UICollectionViewCell
{
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    
    //MARK:- other Functions
    func setView(data: ServiceNew,view:UIViewController,path:Int)
    {
        let hexColor = data.colorCode ?? "#F75469"
        
        self.viewBack.layer.borderWidth = 0.5
        self.viewBack.layer.borderColor = UIColor.init(netHex: 0xD9D4D4).cgColor
        
        self.viewBack.dropShadow(radius:20.0)
        let color : UIColor = view.hexStringToRGB(hexString: hexColor)
        self.viewBack.backgroundColor = color
       // self.viewBack.backgroundColor = UIColor.init(netHex: 0xFFA400)
        
        //setData
        if let url = data.icon
        {
//            if (path == 0 || path == 1 || path == 5 || path == 6 || path == 8 || path == 9 || path == 10)
//            {
//
//            }
//            else
//            {
              self.imageView.setImage(with: url, placeholder: "image")
           // }
            
        }
        
        self.imageView.CornerRadius(radius: 7)
        lblServiceName.text = data.name
      //  self.lblServiceName.roundCorners_BOTTOM_LEFT_BOTTOM_RIGHT(val:20)
    }
    @IBAction func BtnACtion(_ sender: Any)
    {
        print("Selected")
    }
}
