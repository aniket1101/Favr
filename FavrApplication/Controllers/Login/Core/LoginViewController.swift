//
//  LoginViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD
import SpriteKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let spinner: JGProgressHUD = {
        let spinner = JGProgressHUD(style: .dark)
        spinner.square = true
        spinner.cornerRadius = 12
        return spinner
    }()

    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreenLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.setLeftView(image: UIImage(systemName: "envelope.fill")!)
        field.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        field.setLeftView(image: UIImage(systemName: "eye.slash.fill")!)
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    
    private let lineOneLabel: UILabel = {
       let onelabel = UILabel()
        onelabel.text = "—"
        onelabel.textColor = .orange
        onelabel.textAlignment = .left
        return onelabel
    }()
    
    private let lineTwoLabel: UILabel = {
       let twolabel = UILabel()
        twolabel.text = "—"
        twolabel.textColor = .orange
        twolabel.textAlignment = .right
        return twolabel
    }()
    
    private let registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("Don't have an account?", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        button.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        return button
    }()
    
    @objc private func forgotPassword() {
        let vc = ForgotPasswordViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
// MARK:- Facebook Button
    private let fbLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fb"), for: .normal)
        button.addTarget(self, action: #selector(facebookLoggingIn), for: .touchUpInside)
        // Circular button
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        return button
    }()
    
    @objc private func facebookLoggingIn() {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile" ]
        button.setImage(UIImage(named: "fb"), for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK:- Google Button
    private let googleLoginButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "google"), for: .normal)
        button.addTarget(self, action: #selector(googleSignInPressed), for: .touchUpInside)
        // Circular button
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        return button
    }()
    
    @objc private func googleSignInPressed() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK:- Twitter Button
    private let twitterLoginButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
//        button.addTarget(self, action: #selector(twitterSignInPressed), for: .touchUpInside)
        // Circular button
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        return button
    }()
    
//    @objc private func twitterSignInPressed() {
//
//    }

    // MARK:- Apple Button
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "apple"), for: .normal)
//        button.addTarget(self, action: #selector(appleSignInPressed), for: .touchUpInside)
        // Circular button
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        return button
    }()
    
//    @objc private func appleSignInPressed() {
//
//    }
    
    // MARK:- Continuing Login Code
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        title = ""
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(didTapRegister))
        
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        facebookLoginButton.delegate = self
        
        //Subviews
        view.addSubview(scrollView)
        // Core
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        // Additional stylistic pieces
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(lineOneLabel)
        scrollView.addSubview(orLabel)
        scrollView.addSubview(lineTwoLabel)
        // Login Services
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(googleLoginButton)
//        scrollView.addSubview(twitterLoginButton)
        scrollView.addSubview(appleLoginButton)
    }
    
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        forgotPasswordButton.frame = CGRect(x: (scrollView.width/2)+10,
                                            y: passwordField.bottom+20,
                                            width: scrollView.width/2,
                                            height: 12)
        registerButton.frame = CGRect(x: 0,
                                      y: scrollView.bottom-135,
                                      width: scrollView.width,
                                      height: 50)
        loginButton.frame = CGRect(x: ((scrollView.width)/2)-(scrollView.width-250)/2,
                                   y: forgotPasswordButton.bottom+20,
                                   width: scrollView.width-250,
                                   height: 50)
        orLabel.frame = CGRect(x: (scrollView.width-size)/2,
                               y: loginButton.bottom+20,
                               width: size,
                               height: 30)
        lineOneLabel.frame = CGRect(x: 30,
                                    y: loginButton.bottom+20,
                                    width: scrollView.width/2,
                                    height: 30)
        lineTwoLabel.frame = CGRect(x: (scrollView.width/2)-30,
                                    y: loginButton.bottom+20,
                                    width: scrollView.width/2,
                                    height: 30)
        googleLoginButton.frame = CGRect(x: 30,
                                   y: orLabel.bottom+10,
                                   width: 52,
                                   height: 52)
        fbLoginButton.frame = CGRect(x: ((scrollView.width)/2)-26,
                                     y: orLabel.bottom+10,
                                     width: 52,
                                     height: 52)
        appleLoginButton.frame = CGRect(x: scrollView.width-82,
                                        y: orLabel.bottom+10,
                                        width: 52,
                                        height: 52)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 8 else {
                alertUserLoginError()
                self.passwordField.text = ""
                return
        }
        
        spinner.show(in: view)
        
        // Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            
            guard let result = authResult, error == nil else {
                self?.alertUserLoginDoesNotExist()
                self?.passwordField.text = ""
                print("Failed to log in user with email: \(email)")
                return
            }
            
            
            let user = result.user
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    
                    print("Failed to read data with error \(error)")
                    
                }
            })
            
            UserDefaults.standard.set(email, forKey: "email")
            
            print("Logged in user: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            

        })
        
    }
    
    
    func alertUserLoginDoesNotExist() {
        let alert = UIAlertController(title: "Whoops! Those Favr details don't check out!", message: "Your email or password is incorrect. Don't have an account? Sign up below.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .default, handler: nil))
        present(alert, animated: true)
        
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Cannot Sign In", message: "There is no account with the email \(emailField.text!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
         let vc = RegisterViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginViewController: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Not applicable for Favr as this view will not be shown to log out
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with Facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String: Any],
                error == nil else {
                print("Failed to make Facebook graph request")
                return
            }
            
            print(result)
            
            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let pictureUrl = data["url"] as? String else {
                    print("Failed to get name and email from Facebook result")
                    return
            }
            
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                        if success {
                            
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            
                            print("Downloading data from Facebook image...")
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else{
                                    print("Failed to get data from Facebook")
                                    return
                                }
                                
                                print("Got data from Facebook, uploading...")
                                
                                // Upload image
                                let filename = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")
                                    }
                                })
                            }).resume()
                        }
                    })
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    return
                }
                
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}

extension UITextField {
  func setLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 15, width: 25, height: 15)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
  }
}

