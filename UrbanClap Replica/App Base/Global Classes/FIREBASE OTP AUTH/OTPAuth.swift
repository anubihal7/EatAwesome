

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class FirbaseOTPAuth:NSObject
{
    class func get_otp_from_firebase(controller:UIViewController,phoneNumber:String, completionHandler: @escaping (String) -> Void)
    {
        controller.StartIndicator(message: kLoading_Getting_OTP)
       
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error
            {
                Commands.println(object: error.localizedDescription as Any)
                controller.StopIndicator()
                controller.showToastSwift(alrtType: .error, msg: error.localizedDescription, title: "Firebase Error")
                return
            }
            else
            {
                controller.StopIndicator()
                completionHandler(verificationID ?? "")
            }
        }
    }
    
    class func verify_number_from_firebase(controller:UIViewController,verifID:String,OTP:String, completionHandler: @escaping (String) -> Void)
    {
        controller.StartIndicator(message: kVerifying)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifID,verificationCode: OTP)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error
            {
                controller.StopIndicator()
                controller.showToastSwift(alrtType: .error, msg: error.localizedDescription, title: kFailed)
                return
            }
            else
            {
               controller.StopIndicator()
               completionHandler("verified")
            }
        }
    }
}

