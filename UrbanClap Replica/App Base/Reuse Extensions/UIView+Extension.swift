////
////  UIView+Extension.swift
////  BaseProject
////
////  Created by Aj Mehra on 09/03/17.
////  Copyright © 2017 openkey. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//extension String
//{
//    var isValidEmail: Bool
//    {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
//    }
//    var isValidPassword: Bool
//    {
//        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
//    }
//    var RemoveWhiteSpace : String
//    {
//        let trimmedString = self.trimmingCharacters(in: .whitespaces)
//        return trimmedString
//    }
//
//    //Convert Base4 image into UIImage
//    func base64ToImage() -> UIImage?
//    {
//        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data)
//        {
//            return image
//        }
//        return nil
//    }
//
//    var localized: String
//    {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//
//    }
//
//}
//
//
//
//
//
//extension UIView
//{
//
//    @IBInspectable
//    var cornerRadius: CGFloat
//    {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    @IBInspectable
//    var borderWidth: CGFloat
//    {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            let color = UIColor.init(cgColor: layer.borderColor!)
//            return color
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowColor = UIColor.black.cgColor
//            layer.shadowOffset = CGSize(width: 0, height: 2)
//            layer.shadowOpacity = 0.4
//            layer.shadowRadius = newValue
//        }
//    }
//
//
//    // OUTPUT 1
//    func dropShadow(scale: Bool = true)
//    {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        layer.shadowRadius = 1
//
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//
//    // OUTPUT 2
//    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowOffset = offSet
//        layer.shadowRadius = radius
//
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//
//
//    //MARK: BOUNCE YOUR VIEW USING LAYER ANIMATION
//    func explicitBounceAnimation()
//    {
//        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
//        var values = [Double]()
//        let e = 2.71
//
//        for t in 1..<100
//        {
//            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
//            values.append(value)
//        }
//
//        bounceAnimation.values = values
//        bounceAnimation.duration = TimeInterval(0.5)
//        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
//
//        layer.add(bounceAnimation, forKey: "bounceAnimation")
//    }
//
//
//    //MARK: FADE OUT UIVIEW
//    func fadeOut(duration: TimeInterval)
//    {
//        UIView.animate(withDuration: duration) {
//            self.alpha = 0.0
//        }
//    }
//
//    //MARK: FADE IN UIVIEW
//    func fadeIn(duration: TimeInterval)
//    {
//        UIView.animate(withDuration: duration) {
//            self.alpha = 1.0
//        }
//    }
//
//
//    enum animDirection
//    {
//        case top
//        case left
//        case right
//        case bottom
//    }
//
//    func animateView(from: animDirection)
//    {
//
//        guard let window = UIApplication.shared.keyWindow else {return}
//        let originalFrame = self.frame
//        var tempFrame = originalFrame
//
//        switch from
//        {
//        case .top:
//            tempFrame.origin.y = -window.bounds.height
//        case .bottom:
//            tempFrame.origin.y = window.bounds.height
//        case .left:
//            tempFrame.origin.x = -window.bounds.width
//        case .right:
//            tempFrame.origin.x = window.bounds.width
//        }
//
//        self.frame = tempFrame
//
//        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
//            self.frame = originalFrame
//        }) { _ in
//        }
//
//    }
//
//
//}
//
//
//
//@IBDesignable
//extension UITextField
//{
//    @IBInspectable var paddingLeftCustom: CGFloat {
//        get {
//            return leftView!.frame.size.width
//        }
//        set {
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
//            leftView = paddingView
//            leftViewMode = .always
//        }
//    }
//
//    @IBInspectable var paddingRightCustom: CGFloat {
//        get {
//            return rightView!.frame.size.width
//        }
//        set {
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
//            rightView = paddingView
//            rightViewMode = .always
//        }
//    }
//}
//
//extension Dictionary
//{
//
//    func convertToJson() -> String
//    {
//        do
//        {
//            let data = self
//            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
//            var string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? ""
//            string = string.replacingOccurrences(of: "\n", with: "") as NSString
//            print(string)
//            string = string.replacingOccurrences(of: "\\", with: "") as NSString
//            print(string)
//            //            string = string.replacingOccurrences(of: "\"", with: "") as NSString
//            string = string.replacingOccurrences(of: " ", with: "") as NSString
//            print(string)
//            return string as String
//        }
//        catch let error as NSError
//        {
//            print(error.description)
//            return ""
//        }
//    }
//
//    func convertToJSONObject() -> Any?
//    {
//        do
//        {
//            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//
//            return decoded
//
//        }
//        catch let error as NSError
//        {
//            print(error.description)
//            return nil
//
//        }
//    }
//
//}

extension UIView
{
    
    
    func roundCorners_TOPLEFT_TOPRIGHT(val:Int)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func roundCorners_BottomLeft(val:Int)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func dropShadow(radius:CGFloat)
    {
        layer.masksToBounds = false
        layer.cornerRadius = radius
     
        // set the shadow properties
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
    }
    
    //MARK:- Remove shadow
    func removeShadow()
    {
           layer.masksToBounds = false
           layer.shadowOffset = CGSize(width: 0, height: 0)
           layer.shadowOpacity = 0.0
       }
    
}
