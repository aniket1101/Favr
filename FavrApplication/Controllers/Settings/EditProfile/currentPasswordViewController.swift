//
//  currentPasswordViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 15/11/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import UIView_Shake

class currentPasswordViewController: UIViewController, UITextFieldDelegate {
    
    public var currentPassword: String
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
         label.text = "PLEASE MAKE SURE YOUR PASSWORD IS CORRECT!"
         label.textColor = .gray
         label.font = .systemFont(ofSize: 12, weight: .medium)
         return label
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("If you don't remember your password, click here", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let currentPasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.borderStyle = .none
        field.setPadding()
        field.setBottomBorder()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.setLeftView(image: UIImage(systemName: "eye.fill")!)
        field.backgroundColor = .systemGroupedBackground
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "Current password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        return field
    }()
    
    @objc private func forgotPassword() {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init() {
        self.currentPassword = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pushChangePassword() {
        if currentPasswordField.text == "" {
            view.shake(10,              // 10 times
                       withDelta: 5.0)   // 5 points wide
        }
        else {
            let vc = changePasswordViewController()
            vc.currentPassword = currentPasswordField.text
            currentPasswordField.text = ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        pushChangePassword()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Current Password"
        
        currentPasswordField.delegate = self

        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(pushChangePassword))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
        
        view.addSubview(passwordLabel)
        view.addSubview(currentPasswordField)
        view.addSubview(forgotPasswordButton)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        passwordLabel.frame = CGRect(x: 10,
                                     y: 100,
                                     width: view.width,
                                     height: 20)
        currentPasswordField.frame = CGRect(x: 10,
                                            y: passwordLabel.bottom+10,
                                        width: view.width-20,
                                        height: 52)
        forgotPasswordButton.frame = CGRect(x: 0,
                                            y: currentPasswordField.bottom+20,
                                            width: view.width,
                                            height: 22)
        
    }

}
