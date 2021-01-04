//
//  passwordChangedView.swift
//  Favr
//
//  Created by Aniket Gupta on 15/11/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Lottie
import NotificationCenter

class passwordChangedView: UIView {

    private let animationView = AnimationView()
    
    func startAnimation() {
        animationView.animation = Animation.named("tick")
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .playOnce
    }
    
    private let passwordMessage: UILabel = {
        let label = UILabel()
        label.text = "Your password has been changed"
        label.textColor = .darkGray
        label.font = UIFont(name: "Monstserrat-Bold", size: 6)
        label.numberOfLines = -1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Thanks!", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrOrange")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func passwordButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("passwordChangedButtonTapped"), object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        backgroundColor = .tertiarySystemGroupedBackground
        
        startAnimation()
        
        addSubview(passwordButton)
        passwordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        passwordButton.topAnchor.constraint(equalTo: topAnchor, constant: 248).isActive = true
        passwordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        passwordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(passwordMessage)
        passwordMessage.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        passwordMessage.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        passwordMessage.bottomAnchor.constraint(equalTo: passwordButton.topAnchor, constant: -10).isActive = true
        
        addSubview(animationView)
        animationView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        animationView.rightAnchor.constraint(equalTo: rightAnchor, constant: -36).isActive = true
        animationView.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
//        animationView.bottomAnchor.constraint(equalTo: passwordMessage.topAnchor, constant: -24).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
