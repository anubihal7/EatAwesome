//
//  ColourPallette.swift
//  Drift
//
//  Created by Eoin O'Connell on 26/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//


import UIKit

struct ColorPalette {
    static let titleTextColor: UIColor = {
        
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        }
    }()
    
    static let subtitleTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor(red:0.6, green:0.6, blue:0.6, alpha:1.00)
        }
    }()
    
    static let backgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
    
    static let lighterBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemBackground
        } else {
            return UIColor(red:0.88, green:0.93, blue:0.96, alpha:1.00)
        }
    }()
    
    static let shadowViewBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.init { (collection) -> UIColor in
                if collection.userInterfaceStyle == .dark {
                    return UIColor.secondarySystemBackground
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }()
    
    static let placeholderColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.placeholderText
        } else {
            return UIColor(red:0.6, green:0.6, blue:0.6, alpha:1.00)
        }
    }()
    
    static let borderColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.opaqueSeparator.withAlphaComponent(0.4)
        } else {
            return UIColor(white: 0, alpha: 0.2)
        }
    }()
    
    
    static let dividerColor: UIColor = {
       if #available(iOS 13.0, *) {
           return UIColor.separator
       } else {
           return UIColor(white: 0, alpha: 0.25)
       }
    }()
            
    static let driftBlue = UIColor(red:0.00, green:0.46, blue:1.00, alpha:1.00)
    static let driftGreen = UIColor(red:0.07, green:0.80, blue:0.43, alpha:1.00)
}
