
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var bottomLineColor: UIColor? {
        didSet {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - 1, width: UIScreen.main.bounds.width - 32, height: 1.0);
            bottomBorder.backgroundColor = bottomLineColor!.cgColor
            self.layer.addSublayer(bottomBorder)
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            
            self.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
            imageView.image = leftImage
            imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor =  .black
            imageView.backgroundColor = .clear
            imageView.contentMode = .left
            self.leftView = imageView
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            
            self.rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
            imageView.image = rightImage
            imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor =  .black
            imageView.backgroundColor = .clear
            imageView.contentMode = .center
            self.rightView = imageView
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor!])
        }
    }
    
}

