//
//  ChangeNameViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 22/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class ChangeDisplayNameViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let changeNameMessageLabel: UILabel = {
           let label = UILabel()
           label.text = "THIS IS WHAT OTHER USERS WILL SEE YOU AS"
           label.textColor = .gray
           label.font = .systemFont(ofSize: 12, weight: .medium)
           return label
       }()
    
    private let newNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.layer.borderColor = UIColor.lightGray.cgColor
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
//        field.leftViewMode = .always
        field.placeholder = "..."
        field.setPadding()
        field.setBottomBorder()
        field.setOtherLeftView(image: UIImage(systemName: "at")!)
        field.backgroundColor = .systemGroupedBackground
        return field
    }()
    
    private let usernameConditionsLabel: UILabel = {
        let label = UILabel()
        label.text =
            """
Some of our Username Guidelines are:

\u{2022} Usernames can contain letters (a-z), numbers (0-9), periods (.) and underscores (_)
\u{2022} Contain a minimum of 3 characters
\u{2022} Usernames must be no longer than 20 characters
\u{2022} Do not defame, abuse, harass, stalk, threaten or otherwise violate the legal rights (such as rights of privacy and publicity) of others
"""
        label.numberOfLines = -1
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let learnMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Learn more"
        label.textColor = .link
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let changeNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Username", for: .normal)
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func changeButtonTapped() {
        guard let usernameValue = newNameField.text?.count else { return }
        
        if 3 <= usernameValue && usernameValue <= 20 {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child("Users").child(safeEmail)
            guard let key = ref.child("name").key else { return }
            
            let childUpdates = ["\(key)": newNameField.text,
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
            self.newNameField.text = ""
            navigationController?.popViewController(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func learnMore() {
        guard let url = URL(string: "https://favrapp.weebly.com/faqs.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "FAQs"
        present(vc, animated: true, completion: {self.selectView()})
         
    }
    
    private func selectView(){
        present(ChangeDisplayNameViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Username"
        
        learnMoreLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(learnMore))
        
        learnMoreLabel.addGestureRecognizer(gesture)
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
        let ref = Database.database().reference().child("Users").child(safeEmail)
        ref.child("name").observe(.value, with: { [weak self]
            snapshot in
            let currentDisplayName = snapshot.value as? String
            self?.newNameField.placeholder = currentDisplayName
        })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(changeButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")

        // Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(newNameField)
        scrollView.addSubview(changeNameMessageLabel)
        scrollView.addSubview(changeNameButton)
        scrollView.addSubview(usernameConditionsLabel)
        scrollView.addSubview(learnMoreLabel)
        
        newNameField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        changeNameMessageLabel.frame = CGRect(x: 10,
                                              y: 30,
                                              width: scrollView.width,
                                              height: 15)
        newNameField.frame = CGRect(x: 30,
                                    y: changeNameMessageLabel.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)
        usernameConditionsLabel.frame = CGRect(x: 30,
                                               y: newNameField.bottom+10,
                                               width: view.width-60,
                                               height: 200)
        learnMoreLabel.frame = CGRect(x: 30,
                                      y: usernameConditionsLabel.bottom,
                                      width: view.width-60,
                                      height: 14)
    }

}

extension ChangeDisplayNameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz._"
        let allowedCharactersSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        if allowedCharactersSet.isSuperset(of: typedCharacterSet) == false {
            textField.shake()
            textField.tintColor = .systemRed
        }
        else {
            textField.tintColor = .lightGray
        }
        return true
    }
    
}

extension UITextField {
  func setOtherLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 12.5, width: 20, height: 20)) // set your Own size
    iconView.image = image
    iconView.contentMode = .scaleAspectFill
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
  }
}
