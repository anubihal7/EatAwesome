//
//  UILabel.swift
//  BidJones
//
//  Created by Rakesh Kumar on 5/3/18.
//  Copyright © 2018UnionGoodsll rights reserved.
//

import Foundation
import UIKit
extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 2000))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
    
    func roundCorners_BOTTOM_LEFT_BOTTOM_RIGHT(val:Int)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func roundCornersBOTTOMLEFT(val:Int)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
