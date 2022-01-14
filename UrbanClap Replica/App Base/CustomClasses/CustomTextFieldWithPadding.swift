
//

import Foundation
import UIKit


@IBDesignable public class CustomUITextFieldWithPadding: UITextField {
    
    //  var pdng = CGFloat()
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    //    @IBInspectable var Padding: CGFloat = 0{
    //        didSet{
    //            pdng = Padding
    //        }
    //    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return frame.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right))
          //  return UIEdgeInsetsInsetRect(bounds, padding)
        }
    
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return frame.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right))
        }
    
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return frame.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right))
        }
    
    @IBInspectable var isPasteEnabled: Bool = true
    
    @IBInspectable var isSelectEnabled: Bool = true
    
    @IBInspectable var isSelectAllEnabled: Bool = true
    
    @IBInspectable var isCopyEnabled: Bool = true
    
    @IBInspectable var isCutEnabled: Bool = true
    
    @IBInspectable var isDeleteEnabled: Bool = true
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
             #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
             #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
             #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
             #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
             #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
            return false
        default:
            //return true : this is not correct
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

