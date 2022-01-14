//
//  String.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/22/18.
//  Copyright © 2018 UnionGoods All rights reserved.
//

import Foundation
import UIKit

//MARK: - String Extnesion


extension String
{
    
    func toDouble() -> Double?
    {
        return Double.init(self)
    }
    func toFloat() -> Float?
    {
        return Float.init(self)
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidURL: Bool
    {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset))
            {
                // it is a link, if the match covers the whole string
                return match.range.length == self.endIndex.encodedOffset
            }
            else
            {
                return false
            }
        }
    
    
    func MinimumRangeofTextFieldValue(minCharCount : Any, value: Any?) -> Bool
    {
        if let str = value as? String
        {
            let intCount = minCharCount as! Int
            
            if str.underestimatedCount < intCount
            {
                print("character is less then the count")
                return false
            }
            else
            {
                print("character is greater then the count")
                return true
            }
            
        }
        else if let intvalue = value as? Int
        {
            let intCount = minCharCount as! Int
            
            if intvalue.nonzeroBitCount < intCount
            {
                print("int is less then the count")
                return false
            }
            else
            {
                print("int is greater then the count")
                return true
            }
            
            
        }
        else if let floatvalue = value as? Float
        {
            print("This is the float value \(floatvalue)")
            
            if floatvalue.isLessThanOrEqualTo(floatvalue)
            {
                print("Value is less")
                return false
            }
            else
            {
                print("value is grater")
                return true
            }
        }
        return false
    }
    
    var nameMinLength : Bool
    {
        if self.count>1
        {
            return true
        }
        return false
    }
    var passwordMinLength : Bool
    {
        if self.count>7
        {
            return true
        }
        return false
    }
    var postalCodeMinLength : Bool
    {
        if self.count>3
        {
            return true
        }
        return false
    }
    
    func checkTextSufficientComplexity() -> Bool{
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        print("\(numberresult)")

        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialSymbolresult = texttest2.evaluate(with: self)
        print("\(numberresult)")

        return capitalresult && numberresult && specialSymbolresult
        
    }
}


