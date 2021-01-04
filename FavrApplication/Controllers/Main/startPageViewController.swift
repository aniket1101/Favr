//
//  startPageViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 04/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Hue
import Pastel

class startPageViewController: UIViewController {
    
    private let favrLabel: UILabel = {
        let label = UILabel()
        label.text = "Favr"
        label.font = UIFont(name: "Montserrat-Regular", size: 72)
        label.textColor = UIColor(named: "FavrLightShade")
        label.textAlignment = .center
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(UIColor(named: "FavrLightShade"), for: .normal)
        button.backgroundColor = UIColor(named: "FavrDarkOrange")
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func logInButtonPressed() {
        let vc = LoginViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(UIColor(named: "FavrLightShade"), for: .normal)
        button.layer.borderColor = UIColor(named: "FavrLightShade")?.cgColor
        button.layer.borderWidth = 2
//        button.backgroundColor = UIColor(named: "FavrOnboardingOrange")
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func registerButtonPressed() {
        let vc = RegisterViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pastelView = PastelView(frame: view.bounds)

            // Custom Direction
            pastelView.startPastelPoint = .bottomLeft
            pastelView.endPastelPoint = .topRight

            // Custom Duration
            pastelView.animationDuration = 3.0

            // Custom Color
        pastelView.setColors([UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0),
                              UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0)])
        
            pastelView.startAnimation()
            view.insertSubview(pastelView, at: 0)
        
        navigationItem.backButtonTitle = "Home"
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.isHidden = true

        view.addSubview(favrLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/2
        favrLabel.frame = CGRect(x: (view.width-size)/2,
                                 y: 81,
                                 width: size,
                                 height: 88)
        loginButton.frame = CGRect(x: 40,
                                   y: view.bottom-150,
                                   width: view.width-80,
                                   height: 52)
        registerButton.frame = CGRect(x: 40,
                                      y: loginButton.bottom+10,
                                      width: view.width-80,
                                      height: 52)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
