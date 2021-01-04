//
//  UserVerificationViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 14/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import UIView_Shake
import Firebase
import Lottie

class UserVerificationViewController: UIViewController {
        
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UserVerification")
        return imageView
    }()
    
    private let verifyEmailLabel: UILabel = {
       let label = UILabel()
        label.text = "Verify your email"
        label.textColor = UIColor(named: "LightAccent")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let emailMessageLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        A verification email has been sent to:
        \(Auth.auth().currentUser?.email ?? "your email")
        """
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 4
        label.textColor = UIColor(named: "Accent")
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let resendVerificationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resend Email", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrOrange")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(didTapResendVerification), for: .touchUpInside)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrBlue")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let notVerifiedLabel: UILabel = {
        let label = UILabel()
        label.text = "Verification failed"
        label.textColor = UIColor(named: "FavrLightShade")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let animationView = AnimationView()

    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .tooManyRequests:
            print("Oops! Too many requests.")
        default: fatalError("Error not supported here.")
        }
    }
    
    @objc private func didTapResendVerification() {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            
            guard let error = error else {
                return print("User email verification sent.")
            }
            
            self.handleError(error: error)
        }
    }
    
    @objc private func confirmButtonPressed() {
        if Auth.auth().currentUser!.isEmailVerified {
            dismiss(animated: true, completion: nil)
        }
        else {
            notVerifiedLabel.isHidden = false
            // Shake with the default speed
            view.shake(10,              // 10 times
                withDelta: 5.0   // 5 points wide
            )
        }
    }
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FavrOrange")
        
        startAnimation()
        
        // Add Subviews
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(verifyEmailLabel)
        scrollView.addSubview(emailMessageLabel)
        scrollView.addSubview(resendVerificationButton)
        scrollView.addSubview(confirmButton)
        scrollView.addSubview(notVerifiedLabel)
        scrollView.addSubview(animationView)
        
        notVerifiedLabel.isHidden = true
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("emailAnimation")
        animationView.play()
        animationView.loopMode = .loop
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/1.75
        
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 70,
                                 width: size,
                                 height: size)
        verifyEmailLabel.frame = CGRect(x: 20,
                                        y: imageView.bottom+40,
                                        width: scrollView.width,
                                        height: 22)
        emailMessageLabel.frame = CGRect(x: 20,
                                         y: verifyEmailLabel.bottom+20,
                                         width: scrollView.width,
                                         height: 40)
        animationView.frame = CGRect(x: 20,
                                     y: emailMessageLabel.bottom+10,
                                     width: scrollView.width-40,
                                     height: 180)
        resendVerificationButton.frame = CGRect(x: 20,
                                                y: emailMessageLabel.bottom+200,
                                                width: scrollView.width-40,
                                                height: 40)
        confirmButton.frame = CGRect(x: 40,
                                     y: resendVerificationButton.bottom+10,
                                     width: scrollView.width-80,
                                     height: 52)
        notVerifiedLabel.frame = CGRect(x: 40,
                                        y: confirmButton.bottom+20,
                                        width: scrollView.width-80,
                                        height: 20)
    }

}
