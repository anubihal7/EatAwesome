//
//  TextHelper.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 01/02/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit

open class TextHelper {
            
    open class func attributedTextForString(text: String) -> NSAttributedString {
        
        let sanitizedText = sanitizeHTMLString(text)
        
        guard let htmlStringData = sanitizedText.data(using: String.Encoding.utf8) else {
            return NSAttributedString(string: text)
        }
        
        do {
            let attributedHTMLString = try NSMutableAttributedString(data: htmlStringData, options: [.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let font = UIFont(name: "AvenirNext-Regular", size: 16)!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 0.0
            attributedHTMLString.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedHTMLString.length))
            return attributedHTMLString
            
        }catch{
            //Unable to format HTML body, in this scenario the raw html will be shown in the message cell
            return NSAttributedString(string: text)
        }
    }
    
    private class func sanitizeHTMLString(_ text: String) -> String {
        
        var response = text

        let range = response.startIndex..<response.endIndex
        let newRange = NSRange(range, in: response)
        
        if let regex = try? NSRegularExpression(pattern: "<img[^>]+\\>", options: .caseInsensitive) {
            response = regex.stringByReplacingMatches(in: response, options: [], range: newRange, withTemplate: "")
        }
        
        return response
    }
    
    
    open class func wrapTextInHTML(text: String) -> String {
        
        let whiteSpaceEscaped = text.trimmingCharacters(in: .whitespaces)
        
        let strippedString = whiteSpaceEscaped.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        let detector =  try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let range = strippedString.startIndex..<strippedString.endIndex
        //Get Range of test as Range
        let newRange = NSRange(range, in: strippedString)
        //Convert to NSRange for methods
        let matches = detector.matches(in: strippedString, options: [], range: newRange)
        
        var newStr = strippedString
        //Reversed so the ranges in strippedString will be ok to reference and wont need to be updates as we mutate values
        for match in matches.reversed() {
            //Convert back to swift Range
            if let swiftRange = Range(match.range, in: strippedString) {
                //Get URLString
                let urlString = String(strippedString[swiftRange])
                let hrefString: String
                
                //If we have http: before string leave it be otherwise prepend http://
                if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
                    hrefString = URL(string: urlString)?.absoluteString ?? urlString
                } else {
                    hrefString = URL(string: "http://\(urlString)")?.absoluteString ?? urlString
                }
                newStr = newStr.replacingCharacters(in: swiftRange, with: "<a href='\(hrefString)'>\(urlString)</a>")
            }
        }
        
        newStr = newStr.replacingOccurrences(of: "\n", with: "<br />")
        return newStr
    }
}

