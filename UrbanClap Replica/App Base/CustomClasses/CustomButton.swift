
//

import Foundation
import UIKit


@IBDesignable public class CustomButton: UIButton
{
    
    var corRadius = CGFloat()
    
    @IBInspectable var borderColor: UIColor = UIColor.white
        {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0
        {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet{
            self.layer.cornerRadius = cornerRadius
            corRadius = cornerRadius
        }
    }

    override public func layoutSubviews()
    {
        super.layoutSubviews()

        updateCornerRadius()
    }
    

    @IBInspectable var rounded: Bool = false
        {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius()
    {
        layer.cornerRadius = rounded ? frame.size.height / 2 : corRadius
    }
    
    @IBInspectable var addShadow: Bool = false
        {
        didSet
        {
            addshadow()
        }
    }
    
    func addshadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
    }
   
}
