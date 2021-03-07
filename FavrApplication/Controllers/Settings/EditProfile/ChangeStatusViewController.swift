//
//  ChangeStatusViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 22/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase

class ChangeStatusViewController: UIViewController, UITextViewDelegate {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    private let newStatusLabel: UILabel = {
       let label = UILabel()
        label.text = "WHAT'S ON YOUR MIND?"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let newStatusField: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.returnKeyType = .continue
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.backgroundColor = .tertiarySystemFill
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    @objc private func changeButtonTapped() {

            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
        let ref = Database.database().reference().child("Users").child(safeEmail)
            guard let key = ref.child("Status").key else { return }
            
            let childUpdates = ["\(key)": newStatusField.text,
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
            self.newStatusField.text = ""
            navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Status"
        
        newStatusField.delegate = self
        self.updateCharacterCount()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(changeButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")

        // Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(newStatusField)
        scrollView.addSubview(newStatusLabel)
        scrollView.addSubview(countLabel)
    }
    
    func updateCharacterCount() {
        let lettersCount = self.newStatusField.text.count

        self.countLabel.text = "\((0) + lettersCount)/35"
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == newStatusField){
            return textView.text.count +  (text.count - range.length) <= 35
        }
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        newStatusLabel.frame = CGRect(x: 10,
                                      y: 30,
                                      width: scrollView.width,
                                      height: 20)
        newStatusField.frame = CGRect(x: 0,
                                    y: newStatusLabel.bottom+5,
                                    width: scrollView.width,
                                    height: 100)
        countLabel.frame = CGRect(x: scrollView.width-50,
                                  y: newStatusField.bottom+10,
                                  width: 40,
                                  height: 20)
    }
    
}
