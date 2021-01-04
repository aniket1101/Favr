//
//  DeleteAccountViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn

class DeleteAccountViewController: UIViewController {
    
    private let database = Database.database().reference().child("\(DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!))")
    
    
    let imageRef = Storage.storage().reference(withPath: "images/\(DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!))_profile_picture.png")
    
//    let uidRef = Database.database().reference().child("users").child("\(Auth.auth().currentUser?.uid ?? "No Uid")")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Warning")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let deletingYourAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Deleting your account will:"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let deletingConditionsOne: UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Delete your account and profile picture"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let deletingConditionsTwo: UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Delete all your messages"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let deletingConditionsThree: UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Delete your history on this phone"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "ENTER YOUR EMAIL:"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let emailField: UITextField = {
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
        field.isSecureTextEntry = false
        field.setLeftView(image: UIImage(systemName: "envelope.fill")!)
        field.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(deleteAccountNow), for: .touchUpInside)
        return button
    }()
    
    @objc private func deleteAccountNow() {
        let user = Auth.auth().currentUser
        if emailField.text == Auth.auth().currentUser?.email {
            let actionSheet = UIAlertController(title: "Delete Account Forever?", message: "Are you sure you want to delete your account? You will not be able to undo this action. Note that it will take a few minutes to fully purge your data.", preferredStyle: .alert)
                    actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [ weak self] _ in
                        self?.emailField.text = ""
                        self?.database.removeValue()
                        self?.logOut()
                        self?.deleteAccountAgain()
                        user?.delete { error in
                            if let error = error {
                                print("Unable to delete account: \(error)")
                            }
                            else {
                                print("Account deleted")
                            }
                        }
                        self?.imageRef.delete { error in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("Profile picture deleted: \(Auth.auth().currentUser?.email ?? "")")
                            }
                        }
//                        self?.uidRef.removeValue()
                    }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                self?.emailField.text = ""
            }))
                    present(actionSheet, animated: true)
                }
        else {
            let actionSheet = UIAlertController(title: "Incorrect Email", message: "Your email does not match the one in our database.", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(actionSheet, animated: true)
        }
        }
    
    func deleteAccountAgain() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Unable to delete account: \(error)")
            }
            else {
                print("Account deleted")
            }
        }
    }
    
    func logOut() {
        
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "name")
        
        // Log out from Facebook
        FBSDKLoginKit.LoginManager().logOut()
        
        // Sign out from Google
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true)
        }
        catch {
            print("Failed to log out")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.title = "Delete Account"
        navigationItem.largeTitleDisplayMode = .never
        scrollView.keyboardDismissMode = .interactive
        
        // Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(deletingYourAccountLabel)
        scrollView.addSubview(deletingConditionsOne)
        scrollView.addSubview(deletingConditionsTwo)
        scrollView.addSubview(deletingConditionsThree)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(deleteButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: ((scrollView.width)/2)-50,
                                 y: 30,
                                 width: 100,
                                 height: 100)
        deletingYourAccountLabel.frame = CGRect(x: 10,
                                                y: imageView.bottom+10,
                                                width: scrollView.width,
                                                height: 20)
        deletingConditionsOne.frame = CGRect(x: 10,
                                          y: deletingYourAccountLabel.bottom+10,
                                          width: scrollView.width,
                                          height: 20)
        deletingConditionsTwo.frame = CGRect(x: 10,
                                             y: deletingConditionsOne.bottom+5,
                                             width: scrollView.width,
                                             height: 20)
        deletingConditionsThree.frame = CGRect(x: 10,
                                             y: deletingConditionsTwo.bottom+5,
                                             width: scrollView.width,
                                             height: 20)
        passwordLabel.frame = CGRect(x: 10,
                                     y: deletingConditionsThree.bottom+20,
                                     width: scrollView.width,
                                     height: 20)
        emailField.frame = CGRect(x: 10,
                                     y: passwordLabel.bottom+5,
                                     width: scrollView.width-20,
                                     height: 52)
        deleteButton.frame = CGRect(x: 0,
                                    y: emailField.bottom+30,
                                    width: scrollView.width,
                                    height: 52)
    }
}


