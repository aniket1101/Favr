//
//  ChangeNameViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 22/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase

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
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = UserDefaults.standard.string(forKey: "name")
        field.setPadding()
        field.setBottomBorder()
        field.setLeftView(image: UIImage(systemName: "person.fill")!)
        field.backgroundColor = .systemGroupedBackground
        return field
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
        if newNameField.text == "" {
            navigationController?.popViewController(animated: true)
        }
        else {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
        let ref = Database.database().reference().child(safeEmail)
        guard let key = ref.child("Name").key else { return }
        
        let childUpdates = ["\(key)": newNameField.text,
        ]
        ref.updateChildValues(childUpdates as [AnyHashable : Any])
//        let reference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
//        guard let keys = reference.child("name").key else { return }
//        let childUpdated = ["\(keys)": newNameField.text,
//        ]
//        reference.updateChildValues(childUpdated as [AnyHashable : Any])
//            UserDefaults.standard.setValue(newNameField.text, forKey: "displayName")
        self.newNameField.text = ""
        navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Display Name"
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
        let ref = Database.database().reference().child(safeEmail)
        ref.child("Name").observe(.value, with: { [weak self]
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
    }

}

extension UITextField {
  func setOtherLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 12.5, width: 20, height: 20)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
  }
}
