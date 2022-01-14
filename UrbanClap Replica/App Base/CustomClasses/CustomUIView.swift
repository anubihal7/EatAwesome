
//

import Foundation
import UIKit

@IBDesignable public class CustomUIView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowColor: UIColor
        {
        get
        {
            return layer.shadowColor as! UIColor
        }
        set {
            
            layer.shadowColor = newValue.cgColor
            
        }
    }
    
    @IBInspectable var shadowOffset: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            
            layer.shadowOffset = CGSize(width: newValue,height: newValue)
            layer.masksToBounds = false
            
        }
    }
    
}

