//
//  AvatarImage.swift
//  Drift
//
//  Created by Brian McDonald on 19/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import UIKit
import AlamofireImage

class AvatarView: UIView {
    
    var cornerRadius: CGFloat = 3{
        didSet{
            setUpCorners()
        }
    }
    
    var imageView = UIImageView()
    var initialsLabel = UILabel()
    
    var wiggleAnimation: CAKeyframeAnimation{
        let wiggleAnimation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle: CGFloat = 0.06
        
        let valLeft = NSValue(caTransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 1))
        let valRight = NSValue(caTransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0, 1))
        
        wiggleAnimation.values = [valLeft, valRight]
        wiggleAnimation.autoreverses = true
        wiggleAnimation.duration = 0.125
        wiggleAnimation.repeatCount = Float.infinity
        
        return wiggleAnimation
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.isUserInteractionEnabled = true
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewleadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let imageViewtrailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let imageViewtopConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let imageViewbottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        self.addConstraints([imageViewleadingConstraint, imageViewtrailingConstraint, imageViewtopConstraint, imageViewbottomConstraint])
        
        self.addSubview(initialsLabel)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        layer.masksToBounds = true
        backgroundColor = ColorPalette.subtitleTextColor
        initialsLabel.isHidden = true
        
        setUpCorners()
    }
    
    func setUpCorners(){
        layer.cornerRadius = cornerRadius
    }
    
    func setUpForAvatarURL(avatarUrl: String?){
        if let avatarUrl = avatarUrl{
            if let url = URL(string: avatarUrl){
                
                initialsLabel.isHidden = true
 
                imageView.backgroundColor = UIColor.clear
                imageView.isHidden = false
                imageView.layer.add(wiggleAnimation, forKey: "wiggle")
                
                let placeholder = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
                
                imageView.af_setImage(withURL: url, placeholderImage: nil, filter: nil, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: { result in
                    
                    self.initialsLabel.text = ""
                    switch result.result {
                    case .success(let image):
                        self.imageView.image = image
                        self.initialsLabel.isHidden = true
                    case .failure(_):
                        self.imageView.image = placeholder
                        
                    }
                    self.imageView.layer.removeAllAnimations()
                    
                })
            }
        }else{
            let placeholder = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
            self.imageView.image = placeholder
        }
    }
    
    func setupForBot(embed: Embed?){
        imageView.image = UIImage(named: "robot", in: Bundle(for: Drift.self), compatibleWith: nil)
        if let backgroundColorString = embed?.backgroundColorString {
            let color = UIColor(hexString: "#\(backgroundColorString)")
            imageView.backgroundColor = color
        }else{
            imageView.backgroundColor = ColorPalette.driftBlue
        }
    }
    
    func setupForUser(user: User?) {
        if let user = user {
            if user.bot {
                setupForBot(embed: DriftDataStore.sharedInstance.embed)
            } else {
                setUpForAvatarURL(avatarUrl: user.avatarURL)
            }
        } else {
            let placeholder = UIImage(named: "placeholderAvatar", in: Bundle(for: Drift.self), compatibleWith: nil)
            self.imageView.image = placeholder
        }
    }
    
}
