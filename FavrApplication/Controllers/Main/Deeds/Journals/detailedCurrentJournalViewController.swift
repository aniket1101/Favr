//
//  detailedCurrentJournalViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 22/02/2021.
//

import UIKit
import Firebase

class detailedCurrentJournalViewController: UIViewController {
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "How has your day been?"
        label.font = UIFont(name: "Montserrat-Bold", size: 22)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = -1
        return label
    }()
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .words
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.borderStyle = .none
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.font = UIFont(name: "Montserrat-Regular", size: 14)
        field.backgroundColor = .systemGroupedBackground
        field.setPadding()
        field.setBottomBorder()
        field.attributedPlaceholder = NSAttributedString(string: "Define your day in a few words", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        return field
    }()
    
    private let journalTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGroupedBackground
        textView.textColor = .secondaryLabel
        textView.autocorrectionType = .yes
        textView.autocapitalizationType = .sentences
        textView.font = UIFont(name: "Montserrat-Regular", size: 14)
        return textView
    }()
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.imageView?.tintColor = .systemBackground
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func completeButtonPressed() {
        if titleField.text?.isEmpty == false, journalTextView.text?.isEmpty == false {
            let title = titleField.text!
            let journal = journalTextView.text!
            let database = Database.database().reference()
            guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
            let ref = database.child("Users").child("\(safeEmail)")

            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard var userNode = snapshot.value as? [String: Any] else {
                    print("User not found")
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                formatter.locale = .autoupdatingCurrent
                formatter.dateFormat = "dd/MM/yyyy"
                
                let currentDate = formatter.string(from: Date.now())
                
                let journalEntry: [String: Any] = [
                    "title": title,
                    "journal": journal,
                    "date": currentDate
                ]
                
                if var journals = userNode["journals"] as? [[String: Any]] {
                    // Journal array exists for current user
                    // You should append
                    
                    journals.append(journalEntry)
                    userNode["journals"] = journals
                    ref.setValue(userNode, withCompletionBlock: { error, _  in
                        guard error == nil else {
                            return
                        }
                    })
                }
                else {
                    // Journals array does NOT exist
                    // Create it
                    userNode["journals"] = [
                        journalEntry
                    ]
                    
                    ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        return
                        }
                    })
                }
            })
            titleField.text = nil
            journalTextView.text = nil
            dismiss(animated: true, completion: nil)
        }
        else {
            view.shake()
        }

    }
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(dismissButton)
        view.addSubview(currentLabel)
        view.addSubview(titleField)
        view.addSubview(completeButton)
        view.addSubview(journalTextView)
        
        journalTextView.translatesAutoresizingMaskIntoConstraints = false
        [
            journalTextView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10),
            journalTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            journalTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            journalTextView.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        
        journalTextView.delegate = self
        journalTextView.isScrollEnabled = false
        
        textViewDidChange(journalTextView)
        
        journalTextView.text = "What were your key moments from today?"
        journalTextView.textColor = UIColor.secondaryLabel

        journalTextView.selectedTextRange = journalTextView.textRange(from: journalTextView.beginningOfDocument, to: journalTextView.beginningOfDocument)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dismissButton.frame = CGRect(x: view.width-60,
                                     y: 30,
                                     width: 30,
                                     height: 30)
        currentLabel.frame = CGRect(x: 30,
                                    y: dismissButton.bottom+10,
                                    width: view.width-60,
                                    height: 25)
        titleField.frame = CGRect(x: 20,
                                  y: currentLabel.bottom+20,
                                  width: view.width-40,
                                  height: 50)
        completeButton.frame = CGRect(x: 40,
                                      y: journalTextView.bottom+40,
                                      width: view.width-80,
                                      height: 50)
        completeButton.layer.cornerRadius = 15
    }

}

extension detailedCurrentJournalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width-40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "What were your key moments from today?"
            textView.textColor = UIColor.secondaryLabel

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.secondaryLabel && !text.isEmpty {
            textView.textColor = UIColor.label
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.secondaryLabel {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
