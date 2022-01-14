
//


import Foundation
import UIKit
import AVFoundation
import Photos
import Alamofire


@available(iOS 10.0, *)
class AllUtilies
{
    //MARK: - Validation functions
    static var isAnimating = false
    static var isSocketConnected = false
    static var isConnectedToInternet:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    static func checkTextSufficientComplexity( text : String) -> Bool
    {
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        return capitalresult || numberresult || specialresult
    }
    
    //MARK: -    Check Location
    static func LocationAccess()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                Location.shared.InitilizeGPS()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                fatalError()
            }
        }
        else
        {
            print("Location services are not enabled")
        }
        
    }
    
    //MARK: - Gallary permission Functions
    
    static  func CameraGallaryPrmission()
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response
            {
                //access granted
            }
            else
            {
                
            }
        }
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined
        {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized
                {
                    
                }
                else
                {
                    
                }
            })
        }
    }
    
    //Set Attributed text for btn open link
    static func setAttributedStringInBtnOpenLink(button: UIButton)
    {
        let attributedStringProperties = [NSAttributedString.Key.foregroundColor : UIColor.blue,NSAttributedString.Key.underlineStyle : 1,NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 14.0) ?? false] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Would you like to secure your original work through blockchain technology?", attributes:attributedStringProperties)
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
}



public class CommonVc: UIViewController
{
    
    public class AllFunctions
    {
        class func GetTopController()-> UIViewController
        {
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while let presentedViewController = topController.presentedViewController
                {
                    topController = presentedViewController
                }
                
                return topController
            }
            
            return   UIApplication.shared.keyWindow!.rootViewController!
        }
    }
}
