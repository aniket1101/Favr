//
//  logOutView.swift
//  Favr
//
//  Created by Aniket Gupta on 11/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import NotificationCenter
import Lottie

class logOutView: UIView {
    
    @objc func logOut() {
        
                    UserDefaults.standard.set(nil, forKey: "email")
                    UserDefaults.standard.set(nil, forKey: "name")
        
                    // Log out from Facebook
                    FBSDKLoginKit.LoginManager().logOut()
        
                    // Sign out from Google
                    GIDSignIn.sharedInstance()?.signOut()
        
                    do {
                        try FirebaseAuth.Auth.auth().signOut()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("logOut"), object: nil)
                    }
                    catch {
                        print("Failed to log out")
                        
                    }
    }
    
    private let animationView = AnimationView()
    
    func startAnimation() {
        animationView.animation = Animation.named("35105-follow-ball")
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
    }
    
    private let logOutMessage: UILabel = {
        let label = UILabel()
        label.text = "See you soon! Make sure to close Favr from the Task Switcher to log out fully."
        label.textColor = .darkGray
        label.font = UIFont(name: "Monstserrat-Bold", size: 6)
        label.numberOfLines = -1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrOrange")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        startAnimation()
        
        addSubview(logOutButton)
        logOutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        logOutButton.topAnchor.constraint(equalTo: topAnchor, constant: 248).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        logOutButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(logOutMessage)
        logOutMessage.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        logOutMessage.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        logOutMessage.bottomAnchor.constraint(equalTo: logOutButton.topAnchor, constant: -10).isActive = true
        
        addSubview(animationView)
        animationView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        animationView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        animationView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
//        animationView.bottomAnchor.constraint(equalTo: logOutMessage.topAnchor, constant: -24).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
