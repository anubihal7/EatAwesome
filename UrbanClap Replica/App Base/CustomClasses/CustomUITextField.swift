
//

import Foundation
import UIKit

private var __maxLengths = [UITextField: Int]()
@IBDesignable public class CustomUITextField: UITextField {
    
  //  var pdng = CGFloat()
  // let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);

    
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
    
//    @IBInspectable var borderWidth: CGFloat = 2.0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
    
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
         border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: self.frame.size.height)
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
    
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds,padding)
//    }
    
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
    
    // Provides left padding for images
    @IBInspectable var rightImage : UIImage? {
        
        
        didSet {
            updateRightView()
            //layer.masksToBounds = true
        }
    }
    
    @IBInspectable var rightPadding : CGFloat = 0 {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var leftPadding : CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadiusOfField : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadiusOfField
        }
    }
    
    
    
    func updateView()
    {
        if let image = leftImage
        {
            leftViewMode = .always
            
            // assigning image
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            
            var width = leftPadding + 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20)) // has 5 point higher in width in imageView
            view.addSubview(imageView)
            
            
            leftView = view
            
        } else {
            // image is nill
            leftViewMode = .never
        }
    }
    
    func updateRightView()
    {
        if let image = rightImage
        {
            rightViewMode = .always
            
            // assigning image
            let imageView = UIImageView(frame: CGRect(x: rightPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            
            var width = rightPadding - 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width -= 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20)) // has 5 point higher in width in imageView
            view.addSubview(imageView)
            
            
            rightView = view
            
        } else {
            // image is nill
            rightViewMode = .never
        }
    }
    
    
    //gagan
    //For bottom layer
    
    let border = CALayer()
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            setup()
        }
    }
    
    func setup() {
        border.borderColor = self.borderColor?.cgColor
        
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
 @IBInspectable var bottomLineColor: UIColor? {
        didSet {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - 1, width: UIScreen.main.bounds.width - 32, height: 1.0);
            bottomBorder.backgroundColor = bottomLineColor!.cgColor
            self.layer.addSublayer(bottomBorder)
        }
    }
    
    @IBInspectable var leftImageTextfield: UIImage? {
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
    
    @IBInspectable var rightImageTextfield: UIImage? {
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
    
    
    
}
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
//    func addRightImageToTextField(imageName: UIImage){
//         var imageView = UIImageView();
//         imageView.image = imageName;
//         self.rightView = imageView;
//     }
//    func addbottomLineToTextField(color:UIColor){
//
//    }
    
    
}
extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    func isPasswordValid() -> Bool{
          let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
          return passwordTest.evaluate(with: self)
      }
      
      var isPasswordLengthValid : Bool   {
          if self.count < 15  &&  self.count > 7 {
              
              return true
          }
          else{
              return false
          }
      }
    
    
 
}
