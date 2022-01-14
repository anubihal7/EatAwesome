//
//  ViewControllerExtentions.swift

//
//  Created by Harpreet Singh on 15/09/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

//import LGSideMenuController
// OR
//import LGSideMenuController.LGSideMenuController
//import LGSideMenuController.UIViewController_LGSideMenuController


extension NSObject {
    
    func getCurrentTimeDateString() -> String
    {
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        formatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        
        // get the date time String from the date object
        let string = formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
        
        let edited = string.replacingOccurrences(of: "at", with: "")
        
        print(edited)
        
        return edited
    }
    
    func getTimeDateString(text:String) -> String {
        
        
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let date = formatter.date(from: text)
        
        // get the date time String from the date object
        let string = formatter.string(from: date!) // October 8, 2016 at 10:48:53 PM
        
        let edited = string.replacingOccurrences(of: "at", with: "")
        
        print(edited)
        
        return edited
    }
    
    func convertFromUTCtoLocal(dateToConvert:String) -> String {
    // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: dateToConvert)// create   date from string

    // change to a readable time format and change to local time zone
    dateFormatter.dateFormat = "EEE MMM d, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    func strToDate (strDate : String) -> Date {
         let now = Date()
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, yyyy h:mm a"
         dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.date(from: strDate) ?? now
        return timeStamp
        
    }
    
    
    func getCurrentTimeString() -> String {
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        
        formatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        // get the date time String from the date object
        let string = formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
        
        let edited = string.replacingOccurrences(of: "at", with: "")
        
        print(edited)
        
        return edited
    }
    
    
    
    
    func addEventToCalendar(title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    
    @objc func rotatedForLoader(){
        SwiftNotice.updateView()
        // self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    func setRootView(_ identifier:String,storyBoard:String)
    {
        let Storyboard: UIStoryboard = UIStoryboard(name:storyBoard, bundle: nil)
        let chooseCVC = Storyboard.instantiateViewController(withIdentifier: identifier)
        
        let navigationController = UINavigationController(rootViewController: chooseCVC)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func setRoot(identifier:String,storyBoard:String)
    {
//        let Storyboard: UIStoryboard = UIStoryboard(name:storyBoard, bundle: nil)
//        let chooseCVC = Storyboard.instantiateViewController(withIdentifier: identifier)
//        
//        let leftViewController = Navigation.GetInstance(of: .SideMenuVC)as! SideMenuVC
//
//        let navigationController = UINavigationController(rootViewController: chooseCVC)
//
//        let sideMenuController = LGSideMenuController(rootViewController: navigationController,
//                                                      leftViewController: leftViewController,
//                                                     rightViewController: nil)
//
//        sideMenuController.leftViewWidth = 250.0;
//        sideMenuController.leftViewPresentationStyle = .scaleFromBig;
//
//        sideMenuController.rightViewWidth = 100.0;
//        sideMenuController.leftViewPresentationStyle = .slideBelow;
//        
//        UIApplication.shared.windows.first?.rootViewController = sideMenuController
//       // navigationController.navigationBar.isHidden = true
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func CreateActivityIndicatorWithView(view:UIView) -> UIActivityIndicatorView
    {
        
        let constant = CGFloat(50)
        
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView.init(frame: CGRect.init(x:view.frame.size.width/2 - constant , y: view.frame.size.height/2 - constant, width: constant, height: constant))
        
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        
        return indicator
    }
    
    
    func findKeyForValue(value: String, dictionary: [String:String]) ->String?
    {
        for (key, value2) in dictionary
        {
            if (value == value2)
            {
                return key
            }
        }
        
        return nil
    }
    
    
    func compressImage(image:UIImage,compressionQuality:CGFloat) -> Data {
        
        let imageData2 = image.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(image, 1.0)
        
        // print((imageData2! as Data).count)
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64((imageData2! as Data).count))
        print(string)
        
        
        var actualHeight:CGFloat = CGFloat(image.size.height)
        var actualWidth:CGFloat = CGFloat(image.size.width)
        let maxHeight:CGFloat = 2000.0 * 0.8
        let maxWidth:CGFloat = 2000.0
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = maxWidth/maxHeight
        let compressionQuality:CGFloat = 1.0
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        
        //print((imageData! as Data).count)
        let string2 = bcf.string(fromByteCount: Int64((imageData! as Data).count))
        print(string2)
        
        
        UIGraphicsEndImageContext()
        
        return imageData!
    }
    

    
    
    /**
     setNavigationBarItem is used set navigation bar to a particular image.
     */
    /*
     func setNavigationBarItem() {
     
     self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
     self.slideMenuController()?.removeLeftGestures()
     self.slideMenuController()?.removeRightGestures()
     self.slideMenuController()?.addLeftGestures()
     }
     */
    /**
     removeNavigationBarItem is used remove navigationgat.
     */
    /*
     func removeNavigationBarItem() {
     self.navigationItem.leftBarButtonItem = nil
     self.navigationItem.rightBarButtonItem = nil
     self.slideMenuController()?.removeLeftGestures()
     self.slideMenuController()?.removeRightGestures()
     }
     */
    /**
     setRootView is used to set any view controller to root , So you do this only in half single line just sending an identifier.
     
     :param:  identifier View controller's storyboard identifier.
     
     func setRootView(_ identifier:String) {
     
     let chooseCVC = Global.macros.Storyboard.instantiateViewController(withIdentifier: identifier)
     
     let kappdelegate = UIApplication.shared.delegate // a shortcut to get Appdelegate reference.
     // Because self.window is an optional you should check it's value first and assign your rootViewController
     if let window = kappdelegate?.window {
     window!.rootViewController = chooseCVC
     }
     
     }*/
    
    /**
     getViewController is used to get any view controller from storyboard , So you do this only in half single line just sending an identifier.
     
     :param:  identifier View controller's storyboard identifier.
     
     
     func getViewController(_ identifier:String) -> UIViewController {
     
     let chooseCVC = Global.macros.Storyboard.instantiateViewController(withIdentifier: identifier)
     
     return chooseCVC
     }
     //MARK:Methods
     
     setAppDefaultNavigationBar is used to set Apps default Status bar color.
     :param:  identifier View controller's storyboard identifier.
     
     func setAppDefaultNavigationBar(_ navigationController:UINavigationController) {
     
     navigationController.navigationBar.barTintColor = UIColor(netHex:0xFF9933)
     navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
     navigationController.navigationBar.tintColor = UIColor.white
     } */
    
    
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
extension UIViewController
{
    func SetBackBarNavigationCustomButton()
    {
        //Back buttion
        let btnLeft: UIButton = UIButton()
        btnLeft.setImage(UIImage(named: "back"), for: .normal)
        btnLeft.addTarget(self, action: #selector(self.onClcikBack), for: .touchUpInside)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barLeftButton = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItem = barLeftButton
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.UbuntuType.bold.rawValue, size: 20)!,.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Ubuntu-Medium", size: 18)!]
    }
    
    @objc func onClcikBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
/*extension UITableViewCell{
 func getMonthNameFromNumber(monthNumber: Int) -> String {
 let dateFormatter: DateFormatter = DateFormatter()
 let monthName = (((dateFormatter.monthSymbols) as NSArray).object(at: monthNumber - 1))
 return monthName as! String
 }
 /**
 heightForView is used to calculate height for a label .
 func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
 
 let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
 label.numberOfLines = 0
 label.lineBreakMode = NSLineBreakMode.byWordWrapping
 label.font = font
 label.text = text
 label.sizeToFit()
 print(label.frame.height)
 return label.frame.height
 
 } */
 }*/

enum NoticeType{
    case success
    case error
    case info
}

/**
 SwiftNotice is used for various purpose like showing loaders , toasts etc
 */
class SwiftNotice: NSObject {
    
    static var mainViews = Array<UIView>()
    static let rv = UIApplication.shared.delegate!.window!!//(UIApplication.sharedApplication().keyWindow?.subviews.first)! as UIView
    
    static func clear() {
        for i in mainViews {
            i.removeFromSuperview()
        }
    }
    static func updateView(){
        for i in mainViews {
            i.center = rv.center
        }
        
    }
    static func wait() {
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 6000 , height: 6000))
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.4)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
        ai.startAnimating()
        ai.center = mainView.center
        mainView.addSubview(ai)
        mainView.center = rv.center
        rv.addSubview(mainView)
        mainViews.append(mainView)
    }
    
    static func showText(_ text: String) {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        mainView.addSubview(label)
        mainView.center = rv.center
        rv.addSubview(mainView)
        mainViews.append(mainView)
    }
    
    static func showNoticeWithText(_ type: NoticeType,text: String, autoClear: Bool) {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
            break
        case .error:
            image = SwiftNoticeSDK.imageOfCross
            break
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
            break
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        mainView.center = rv.center
        rv.addSubview(mainView)
        mainViews.append(mainView)
        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            self.perform(selector, with: mainView, afterDelay: 3)
        }
    }
    
    @objc static func hideNotice(_ sender: AnyObject) {
        if sender is UIView {
            sender.removeFromSuperview()
        }
    }
}


/**
 SwiftNoticeSDK is used to create loader.
 */

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    /**
     draw is used to create loader.
     
     :param:  type Notice type object.
     */
    
    class func draw(_ type: NoticeType)
    {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
            break
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
            break
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
            break
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    
    /**
     imageOfCheckmark is used to create Image used in loader.
     */
    
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        SwiftNoticeSDK.draw(NoticeType.success)
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    /**
     imageOfCross is used to create cross Image used in loader.
     */
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    /**
     imageOfInfo is used to create cross Image used in loader.
     */
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
    
}

extension NSString {
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    
    
    func checkwhiteSpace(string:String)-> Bool
    {
        let trimmedString = string.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if trimmedString.count == 0
        {
            return false
        }
        return true
    }
    
}

// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
