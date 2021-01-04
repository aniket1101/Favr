//
//  RequireUserAttentionAnimation.swift
//  Favr
//
//  Created by Aniket Gupta on 14/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

class Animations {
    
    static func requireUserAttention(on onView: UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: onView.center.x-10, y: onView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: onView.center.x+10, y: onView.center.y))
        
        onView.layer.add(animation, forKey: "position")
    }
    
}
