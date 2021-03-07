//
//  changePasswordViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 11/11/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import SwiftEntryKit

class changePasswordViewController: UIViewController, UITextFieldDelegate {
    
    private let user = Auth.auth().currentUser
    var currentPassword: String?
    lazy var credential: AuthCredential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: currentPassword!)
    
    private let newPasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.borderStyle = .none
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "eye.slash.fill")!)
        field.backgroundColor = .systemGroupedBackground
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "New password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        return field
    }()
    
    private let newPasswordRepeatedField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.borderStyle = .none
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "eye.slash.fill")!)
        field.backgroundColor = .systemGroupedBackground
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "Re-enter new password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        return field
    }()
    
    @objc private func changePassword() {
        if newPasswordField.text == newPasswordRepeatedField.text {
            
            if let providerData = Auth.auth().currentUser?.providerData {
                    for userInfo in providerData {
                        switch userInfo.providerID {
                        case "facebook.com":
                            func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
                                guard let token = result?.token?.tokenString else {
                                    print("User failed to log in with Facebook")
                                    return
                                }
                                credential = FacebookAuthProvider.credential(withAccessToken: token)
                            }
                        case "google.com":
                            let googleUser = GIDGoogleUser()
                            guard let authentication = googleUser.authentication else {
                                print("Missing auth object off Google user")
                                return
                            }
                            credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
                        default:
                            print("user is signed in with \(userInfo.providerID)")
                        }
                    }
                }

            user?.reauthenticate(with: credential) { [weak self] AuthDataResult, error  in
                if let error = error {
                    // An error happened
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                else {
                    // User re-authenticated
                    if self?.newPasswordField.text == "" || self?.newPasswordRepeatedField.text == "" {
                        self?.view.shake(5, withDelta: 10)
                    }
                        else if self?.newPasswordField.text == self?.newPasswordRepeatedField.text {
                            self?.user?.updatePassword(to: (self?.newPasswordField.text)!, completion: { (error) in
                                if let error = error as NSError? {
                              switch AuthErrorCode(rawValue: error.code) {
                              case .userDisabled:
                                // Error: The user account has been disabled by an administrator.
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                              case .weakPassword:
                                // Error: The password must be 6 characters long or more.
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                              case .operationNotAllowed:
                                // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                              case .requiresRecentLogin:
                                // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                              default:
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                print("Error message: \(error.localizedDescription)")
                              }
                                }
                                else {
                                    print("The user's password has been updated successfully")
                                    func setUpPasswordAttributes() -> EKAttributes {
                                        var attributes = EKAttributes.centerFloat
                                        attributes.displayDuration = .infinity
                                        attributes.roundCorners = .all(radius: 25)
                                        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                        attributes.displayMode = .inferred
                                        attributes.entryBackground = .visualEffect(style: .standard)
                                        attributes.precedence = .enqueue(priority: .normal)
                                        attributes.entryInteraction = .absorbTouches
                                        attributes.positionConstraints.verticalOffset = 10
                                        return attributes
                                    }
                                    SwiftEntryKit.display(entry: passwordChangedView(), using: setUpPasswordAttributes())
                                }
                            })
                        }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField == newPasswordField {
            newPasswordRepeatedField.becomeFirstResponder()
        }
        else if textField == newPasswordRepeatedField {
            textField.resignFirstResponder()
            changePassword()
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Password"
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(changePassword))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
        
        newPasswordField.delegate = self
        newPasswordRepeatedField.delegate = self
        
        view.addSubview(newPasswordField)
        view.addSubview(newPasswordRepeatedField)
         
        NotificationCenter.default.addObserver(forName: NSNotification.Name("passwordChangedButtonTapped"), object: nil, queue: nil) { [weak self] (_)  in
            SwiftEntryKit.dismiss()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        newPasswordField.frame = CGRect(x: 10,
                                        y: 100,
                                        width: view.width-20,
                                        height: 52)
        newPasswordRepeatedField.frame = CGRect(x: 10,
                                                y: newPasswordField.bottom+10,
                                                width: view.width-20,
                                                height: 52)
    }

}
