//
//  forgotPasswordView.swift
//  Favr
//
//  Created by Aniket Gupta on 22/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Lottie

class forgotPasswordView: UIView {
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Sent"
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Montserrat", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let animationView = AnimationView()
    
    func startAnimation() {
        animationView.animation = Animation.named("emailSent")
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        backgroundColor = UIColor(named: "FavrOrange")
        layer.cornerRadius = 25
        startAnimation()

        
        addSubview(animationView)
        animationView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        animationView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        textLabel.leftAnchor.constraint(equalTo: animationView.rightAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
