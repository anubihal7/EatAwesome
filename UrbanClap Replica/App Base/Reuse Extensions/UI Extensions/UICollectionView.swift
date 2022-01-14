//

//

import Foundation
import UIKit
import Lottie

extension UICollectionView
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
        // self.separatorStyle = .none;
    }
    
    func restore()
    {
        self.backgroundView = nil
        // self.separatorStyle = .singleLine
    }
    
    func setEmptyImage(imgName: String)
    {
        let messageImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageImage.image = UIImage(named: imgName)
        messageImage.contentMode = .scaleAspectFit
        self.backgroundView = messageImage;
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
    }
    
    func roundCorners_TOP_LEFT_TOP_RIGHT(val:Int)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
