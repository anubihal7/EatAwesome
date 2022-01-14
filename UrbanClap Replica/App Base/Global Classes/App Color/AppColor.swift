
//

import Foundation
import UIKit


class Appcolor : UIViewController
{
    
    static let kButtonBackgroundColor = UIColor.init(red: 247.0/255.0, green: 84.0/255.0, blue: 105.0/255.0, alpha: 1.0)//Saffron for now
    static let kButtonBackgroundColorWhite = UIColor.init(red: 255.0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let kButtonBackgroundColorGreen = UIColor.init(red: 52.0/255.0, green: 199/255.0, blue: 89/255.0, alpha: 1.0)
    
    static let kTextFieldBackgroundColor = UIColor.init(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)//Gray
    
    static let kLabelBackgroundColor = UIColor.init(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)//white
    
    static let kImageBackgroundColor = UIColor.init(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)//white
    
    static let kTextColorWhite = UIColor.init(red: 255.0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let kTextColorBlack = UIColor.init(red: 0.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    static let kTextColorGrayDark = UIColor.init(red: 67.0/255.0, green: 67/255.0, blue: 67/255.0, alpha: 1.0)
    static let kTextColorGray = UIColor.init(red: 154.0/255.0, green: 154/255.0, blue: 154/255.0, alpha: 1.0)
    
    static let kViewBackgroundColorWhite = UIColor.init(red: 255.0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)//white
    static let kViewBackgroundColor = UIColor.init(red: 255.0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)//white
    
    static let kNavBarColor = UIColor.init(red: 247.0/255.0, green: 84.0/255.0, blue: 105.0/255.0, alpha: 1.0)//Saffron for now
    
    static let kDefaultTintColorBlue = UIColor.init(red: 2.0/255.0, green: 190.0/255.0, blue: 170.0/255.0, alpha: 1.0)//blue default
    
    static var kTheme_Color = AppDefaults.shared.categoryTheme
    
    static var kCyan = UIColor.init(red: 17.0/255.0, green: 193.0/255.0, blue: 192.0/255.0, alpha: 1.0)//blue default
    
    static let kTheme_ColorOrange = UIColor.init(red: 243.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1.0)//orange for now
    static let kGray = UIColor.init(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: 1.0)
    
    
    class func update_ThemeColor()
    {
        kTheme_Color = AppDefaults.shared.categoryTheme
    }
    
    class func get_category_theme()-> UIColor
    {
        return kpurpleTheme
       // return kTheme_Color
    }
    
    static let colorsArray = [
       // UIColor(red: 255/255.0, green: 133/255.0, blue: 255/255.0, alpha: 1.0), //teal color
       // UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1.0), //yellow color
        UIColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1.0), //red color
        UIColor(red: 255/255.0, green: 122/255.0, blue: 0/255.0, alpha: 1.0), //orange color
        UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0), //dark color
        UIColor(red: 175/255.0, green: 82/255.0, blue: 222/255.0, alpha: 1.0), //purple color
       // UIColor(red: 0/255.0, green: 165/255.0, blue: 89/255.0, alpha: 1.0), //green color
    ]
}


//NEW THEME
let kpurpleTheme = UIColor.init(red: 183.0/255.0, green: 124/255.0, blue: 180/255.0, alpha: 1.0)
let korangeTheme = UIColor.init(red: 247.0/255.0, green: 186/255.0, blue: 105/255.0, alpha: 1.0)
let kpinkTheme = UIColor.init(red: 248.0/255.0, green: 155/255.0, blue: 148/255.0, alpha: 1.0)



class colorHandler
{
    class func set_button_image_with_color_change(imgName:String,button:UIButton,colorApproach:UIColor)
    {
        let origImage = UIImage(named: imgName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = colorApproach
    }
    
    class func set_button_BG_image_with_color_change(imgName:String,button:UIButton,colorApproach:UIColor)
    {
        let origImage = UIImage(named: imgName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setBackgroundImage(tintedImage, for: .normal)
        button.tintColor = colorApproach
    }
    
    class func set_image_with_color_change(imgName:String,imgView:UIImageView,colorApproach:UIColor) -> UIImageView
    {
        if let myImage = UIImage(named: imgName)
        {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            imgView.image = tintableImage
            imgView.tintColor = colorApproach
            return imgView
        }
        return UIImageView()
    }
}

extension CGFloat
{
    static func random() -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor
{
    
    static func random() -> UIColor
    {
        let unsignedArrayCount = UInt32(Appcolor.colorsArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        return Appcolor.colorsArray[randomNumber]
    }
    
//    static func random() -> UIColor
//    {
//        return UIColor(
//           red:   .random(),
//           green: .random(),
//           blue:  .random(),
//           alpha: 1.0
//        )
//    }
}
