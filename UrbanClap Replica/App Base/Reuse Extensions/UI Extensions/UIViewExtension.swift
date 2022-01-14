//
//  UIViewExtension.swift
//  Fleet Management
//
//  Copyright © 2020 UnionGoods. All rights reserved.
//

import Foundation
import UIKit

class RoundShadowView: UIView
{
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 1.0
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}

class ShadowView: UIView
{
    
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if shadowLayer == nil
        {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0.0).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.6)
            shadowLayer.shadowOpacity = 1.0
            shadowLayer.shadowRadius = 0.6
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}


class RoundView: UIView
{
    
    private var cornerRadius: CGFloat = 10.0
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
    }

}

