//
//  ChangeEmailViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 10.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setOrangeBottomBorder() {
        self.layer.borderColor = UIColor(named: "FavrOrange")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 10.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = UIColor(named: "FavrOrange")?.cgColor
    }
}

class ChangeEmailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let changeEmailMessageLabel: UILabel = {
           let label = UILabel()
           label.text = "ENTER EMAIL ADDRESS"
           label.textColor = .gray
           label.font = .systemFont(ofSize: 12, weight: .medium)
           return label
       }()
    
    private let newEmailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.layer.borderColor = UIColor(named: "FavrOrange")?.cgColor
        field.setPadding()
        field.setBottomBorder()
        field.backgroundColor = .systemGroupedBackground
        field.setLeftView(image: UIImage(systemName: "envelope.fill")!)
        field.attributedPlaceholder = NSAttributedString(string: "New Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return field
    }()
    
//    private let updateButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Update Email", for: .normal)
//        button.backgroundColor = UIColor(named: "FavrOrange")
//        button.layer.cornerRadius = 25
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    @objc private func updateButtonTapped() {
            Auth.auth().currentUser?.updateEmail(to: newEmailField.text!) { (error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                self.newEmailField.text = ""
                self.navigationController?.popViewController(animated: true)
                return
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.title = "Change Email"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(updateButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
        
        // Subviews
        view.addSubview(scrollView)
        // Core
        scrollView.addSubview(newEmailField)
        scrollView.addSubview(changeEmailMessageLabel)
//        scrollView.addSubview(updateButton)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        changeEmailMessageLabel.frame = CGRect(x: 10,
                                               y: 30,
                                               width: scrollView.width,
                                               height: 15)
        newEmailField.frame = CGRect(x: 30,
                                     y: changeEmailMessageLabel.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
//        updateButton.frame = CGRect(x: ((scrollView.width)/2)-(scrollView.width-240)/2,
//                                    y: newEmailField.bottom+20,
//                                    width: scrollView.width-240,
//                                    height: 52)
    }
}
