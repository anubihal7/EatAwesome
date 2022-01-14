//
//  tebaleView.swift
//  IGetHappy
//
//  Created by Gagan on 12/5/19.
//  Copyright © 2019 UnionGoods. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import TableViewReloadAnimation

extension UITableView
{
    
    func setEmptyMessage(_ message: String)
    {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func setEmptyImage(imgName: String)
    {
        let messageImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageImage.contentMode = .scaleAspectFit
        messageImage.image = UIImage(named: imgName)
        self.backgroundView = messageImage;
        self.separatorStyle = .none;
    }
    
    func setAnimatingImage(fileName: String ,msg :String)
    {
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: -50, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let animationView = AnimationView(name: fileName)
        animationView.frame = bgView.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(1.0)
        
        let X = bgView.frame.size.width/4 + 5
        let Y = bgView.frame.size.height/2
        
        let messageLabel = UILabel(frame: CGRect(x: X, y: Y, width: self.bounds.size.width, height: 50))
        messageLabel.text = msg
        messageLabel.textColor = Appcolor.get_category_theme()
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        
        bgView.addSubview(animationView)
        bgView.addSubview(messageLabel)
        self.backgroundView = bgView
        animationView.play()
        self.separatorStyle = .none;
    }
    
    func animateReload()
    {
//        self.reloadData(
//        with: .simple(duration: 0.75, direction: .rotation3D(type: .ironMan),
//        constantDelay: 0))
//
        
        self.reloadData(
        with: .simple(duration: 0.75, direction: .left(useCellsFrame: true),
        constantDelay: 0))
    }
    
    func restore()
    {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
