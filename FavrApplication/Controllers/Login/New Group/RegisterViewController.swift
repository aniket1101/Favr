//
//  RegisterViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import SafariServices

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
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
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .words
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.textContentType = .givenName
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "signature")!)
        field.backgroundColor = .systemBackground
        field.attributedPlaceholder = NSAttributedString(string: "First Name...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .words
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.textContentType = .familyName
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "signature")!)
        field.backgroundColor = .systemBackground
        field.attributedPlaceholder = NSAttributedString(string: "Last Name...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.textContentType = .emailAddress
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "envelope.fill")!)
        field.backgroundColor = .systemBackground
        field.attributedPlaceholder = NSAttributedString(string: "Email Address...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.textContentType = .password
        field.borderStyle = .none
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "eye.slash.fill")!)
        field.backgroundColor = .systemBackground
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let termsAndPrivacyTextView: UITextView = {
       let textView = UITextView()
        let termsAndPrivacyAttributedString = NSMutableAttributedString(string: "By clicking Register, you agree to our Terms and Conditions and that you have read our Privacy Policy. Check your email to verify your account.")
        termsAndPrivacyAttributedString.addAttribute(.link, value: "https://favrapp.weebly.com/terms-and-conditions.html", range: NSRange(location: 39, length: 20))
        termsAndPrivacyAttributedString.addAttribute(.link, value: "https://favrapp.weebly.com/privacy-policy.html", range: NSRange(location: 87, length: 15))
        textView.attributedText = termsAndPrivacyAttributedString
        textView.textColor = .gray
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 10, weight: .semibold)
        return textView
    }()
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "https://favrapp.weebly.com/terms-and-conditions.html" {
            presentTerms()
        }
        else if URL.absoluteString == "https://favrapp.weebly.com/privacy-policy.html" {
            presentPrivacy()
        }
        
        return false
    }
    
    @objc private func presentTerms() {
        guard let url = URL(string: "https://favrapp.weebly.com/terms-and-conditions.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Terms and Conditions"
        present(vc, animated: true, completion: {self.selectRegisterView()})
    }
    
    @objc private func presentPrivacy() {
        guard let url = URL(string: "https://favrapp.weebly.com/privacy-policy.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Privacy Policy"
        present(vc, animated: true, completion: {self.selectRegisterView()})
    }
    
    func selectRegisterView(){
        present(RegisterViewController(), animated: true)
    }
    
//    private let loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Already have an account?", for: .normal)
//        button.setTitleColor(.lightGray, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
//        button.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
//        button.addTarget(self, action: #selector(loginView), for: .touchUpInside)
//        return button
//    }()
    
    @objc private func loginView() {
        let vc = LoginViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backBarPressed() {
    navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.backBarButtonItem?.action = #selector(backBarPressed)
        navigationController?.navigationBar.tintColor = nil
        
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //Subviews
        view.addSubview(scrollView)
        scrollView.keyboardDismissMode = .interactive
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(termsAndPrivacyTextView)
//        scrollView.addSubview(loginButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self ,
                                             action: #selector(didTapChangeProfilePicture))
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePicture() {
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        registerButton.frame = CGRect(x: ((scrollView.width)/2)-(scrollView.width-250)/2,
                                      y: passwordField.bottom+20,
                                      width: scrollView.width-250,
                                      height: 52)
        termsAndPrivacyTextView.frame = CGRect(x: ((scrollView.width)/2)-(scrollView.width-50)/2,
                                            y: registerButton.bottom+10,
                                            width: scrollView.width-50,
                                            height: 50)
//        loginButton.frame = CGRect(x: 0,
//                                   y: scrollView.bottom-100,
//                                   width: scrollView.width,
//                                   height: 40)
    }
    
    @objc private func registerButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            password.count >= 8 else {
                alertUserLoginError()
                return
        }
        
        spinner.show(in: view)
        
        // Firebase Log In
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                //User already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    let alert = UIAlertController(title: "Whoops!",
                                                  message: "A user with that email already exists",
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay",
                                                  style: .default, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                
                let chatUser = ChatAppUser(firstName: firstName,
                                           lastName: lastName,
                                           emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                    if success {
                        // Upload image
                        guard let image = strongSelf.imageView.image,
                            let data = image.pngData() else {
                                return
                        }
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
                    }
                })
                
                // Choosing where to move
                let vc = UserVerificationViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present (nav, animated: true)
                
                // Email Verification
                guard let person = Auth.auth().currentUser else {
                    return
                }
                
                person.reload { (error) in
                    switch person.isEmailVerified {
                    case true:
                        print("User is verified: \(person)")
                    case false:
                        
                        person.sendEmailVerification { (error) in
                            
                            guard let error = error else {
                                return print("User email verification sent.")
                            }
                            
                            self?.handleError(error: error)
                            
                        }
                        
                        print("Verify user now: \(person)")
                    }
                    
                }
            })
        })
    }
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .tooManyRequests:
            print("Oops! Too many requests.")
        default: fatalError("Error not supported here.")
        }
    }
    
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Whoops!",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension RegisterViewController: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameField {
            textField.resignFirstResponder()
            lastNameField.becomeFirstResponder()
        }
        if textField == lastNameField {
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        
        return true
    }
    
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a photo?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


