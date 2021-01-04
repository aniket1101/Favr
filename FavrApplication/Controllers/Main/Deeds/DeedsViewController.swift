//
//  DeedsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 21/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class DeedsViewController: UIViewController {
        
    private let spinner: JGProgressHUD = {
        let spinner = JGProgressHUD(style: .dark)
        spinner.square = true
        spinner.cornerRadius = 12
        return spinner
    }()
    
    lazy var popUpAlert: CustomPopUpAlert = {
        let view = CustomPopUpAlert()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.popUpAlertDelegate = self
        return view
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            print("No user")
            view.addSubview(visualEffectView)
        }
        else {
            title = "Favrs"
            tabBarController?.tabBar.isHidden = false
        }
        
        let person = Auth.auth().currentUser
        
        let reference = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: person?.email ?? "email"))
            
            reference.child("onboardingComplete").observeSingleEvent(of: .value, with: {
                snapshot in
                let onboardingStatus = snapshot.value as? String
                
                if onboardingStatus == "false" {
                    self.view.addSubview(self.popUpAlert)
                    // MARK: - popUpAlert
                    self.popUpAlert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
                    self.popUpAlert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.popUpAlert.heightAnchor.constraint(equalToConstant: self.view.frame.width - 64).isActive = true
                    self.popUpAlert.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32).isActive = true
                    
                    self.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.popUpAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5) { [weak self] in
                        self?.visualEffectView.alpha = 1
                        self?.popUpAlert.alpha = 1
                        self?.popUpAlert.transform = CGAffineTransform.identity
                    }
                }
            })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Auth.auth().currentUser == nil {
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.dismiss()
        validateAuth()
        validateVerification()
    }
    
    private func validateVerification() {
        
        if Auth.auth().currentUser?.isEmailVerified == false {
            let vc = UserVerificationViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present (nav, animated: true)

        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = startPageViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present (nav, animated: false)
        }
    }
}

// MARK: - Pop Ups

extension DeedsViewController: userVerificationPopUpDelegate {
        @objc func dismissingNav() {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    func handlingSuccess() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            let vc = UserVerificationViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true)
            print("Success: Did remove pop up window")
        }
    }

}

    extension DeedsViewController: popUpDelegate {
        @objc func dismissNav() {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpAlert.removeFromSuperview()
            print("Dismissal: Did remove pop up window")
            let person = Auth.auth().currentUser
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            guard let key = ref.child("onboardingComplete").key else { return }
            
            let childUpdates = ["\(key)": "true",
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
        }
    }
    func handleSuccess() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            let vc = OnboardingViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true)
            let person = Auth.auth().currentUser
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            guard let key = ref.child("onboardingComplete").key else { return }
            
            let childUpdates = ["\(key)": "true",
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
            print("Success: Did remove pop up window")
        }
    }

}
