//
//  ForgotPasswordViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 18/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit
import Lottie

class ForgotPasswordViewController: UIViewController {
    
    private let animationView = AnimationView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Hey, did you forget your password?"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let secondForgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = """
No worries! Enter your email and we'll set you
up with a new one in no time.
"""
        label.font = UIFont(name: "Montserrat", size: 12)
        label.numberOfLines = -1
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        field.setLeftView(image: UIImage(systemName: "envelope.fill")!)
        field.attributedPlaceholder = NSAttributedString(string: "Your Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Email", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func sendButtonTapped() {
        
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailField.text!) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            func setUpPasswordAttributes() -> EKAttributes {
                var attributes = EKAttributes.topFloat
                attributes.displayDuration = 3.5
                attributes.roundCorners = .all(radius: 50)
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                attributes.displayMode = .inferred
                attributes.statusBar = .dark
                attributes.precedence = .enqueue(priority: .normal)
                attributes.screenInteraction = .dismiss
                attributes.entryInteraction = .absorbTouches
                attributes.positionConstraints.verticalOffset = 10
                return attributes
            }
            
            SwiftEntryKit.display(entry: forgotPasswordView(), using: setUpPasswordAttributes())
            self.emailField.text = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Forgot Password"
        
        startAnimation()
        
        // Subviews
        view.addSubview(scrollView)
        
        // Core
        scrollView.addSubview(animationView)
        scrollView.addSubview(forgotPasswordLabel)
        scrollView.addSubview(secondForgotPasswordLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(sendButton)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("4245-views")
        animationView.play()
        animationView.loopMode = .loop
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        animationView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: -30,
                                 width: size,
                                 height: size)
        forgotPasswordLabel.frame = CGRect(x: 0,
                                           y: animationView.bottom+15,
                                           width: scrollView.width,
                                           height: 25)
        secondForgotPasswordLabel.frame = CGRect(x: 0,
                                                 y: forgotPasswordLabel.bottom+5,
                                                 width: scrollView.width,
                                                 height: 30)
        emailField.frame = CGRect(x: 30,
                                  y: secondForgotPasswordLabel.bottom+20,
                                  width: scrollView.width-60,
                                  height: 52)
        sendButton.frame = CGRect(x: ((scrollView.width)/2)-(scrollView.width-250)/2,
                                  y: emailField.bottom+20,
                                  width: scrollView.width-250,
                                  height: 52)
    }
    
    
}

extension UINavigationController {
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
