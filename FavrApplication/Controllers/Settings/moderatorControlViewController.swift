//
//  moderatorControlViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 20/02/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SwiftImage

class moderatorControlViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sky")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        return view
    }()
    
    private let deedTitleField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.returnKeyType = .done
        field.borderStyle = .none
        field.backgroundColor = .systemFill
        field.attributedPlaceholder = NSAttributedString(string: "Title...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        field.setLeftPaddingPoints(10)
        return field
    }()
    
    private let deedPointsField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.returnKeyType = .done
        field.borderStyle = .none
        field.backgroundColor = .systemFill
        field.attributedPlaceholder = NSAttributedString(string: "Points...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        field.setLeftPaddingPoints(10)
        return field
    }()
    
    private let deedDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .yes
        textView.returnKeyType = .done
        textView.backgroundColor = .systemFill
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .label
        return textView
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.imageView?.tintColor = .systemBackground
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapChangeFavrPicture), for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "DESCRIPTION"
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    @objc private func didTapChangeFavrPicture() {
        presentPhotoActionSheet()
    }
    
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.tintColor = .systemBackground
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func backButtonPressed() {
        navigationController?.pop()
    }
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.imageView?.tintColor = .systemBackground
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func completeButtonPressed() {
        if deedTitleField.text?.isEmpty == false, deedDescriptionTextView.text.isEmpty == false, deedPointsField.text?.isEmpty == false, imageView.image !== UIImage(named: "sky") {
            let deedTitle = deedTitleField.text!
            let deedDescription = deedDescriptionTextView.text!
            let deedPoints = deedPointsField.text!

            let deedRef = Database.database().reference().child("Admin").child("Favrs")

            deedRef.child(deedTitle).setValue([
                "Completed": 0,
                "Description": deedDescription,
                "Points": "\(deedPoints)"
            ])
            
            guard let imagedata = imageView.image?.pngData() else {
                return
            }
            Storage.storage().reference().child("images/Favrs/\(deedTitle).png").putData(imagedata)
            deedTitleField.text = ""
            deedDescriptionTextView.text = ""
            deedPointsField.text = ""
            
            let deedTitleRef = Database.database().reference().child("Admin")
            
            deedTitleRef.observeSingleEvent(of: .value, with: { snapshot in
                guard var adminNode = snapshot.value as? [String: Any] else {
                    print("Admin not found")
                    return
                }
                
                let favrEntry: [String: Any] = [
                    "title": deedTitle
                ]
                
                if var favrs = adminNode["FavrsTitles"] as? [[String: Any]] {
                    // Favrs array exists
                    // You should append
                    
                    favrs.append(favrEntry)
                    adminNode["FavrsTitles"] = favrs
                    deedTitleRef.setValue(adminNode, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
                else {
                    // Favrs array does NOT exist
                    // Create it
                    
                    adminNode["FavrsTitles"] = [
                        favrEntry
                    ]
                    
                    deedTitleRef.setValue(adminNode, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
            })

        }
        else {
            view.shake()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        deedDescriptionTextView.delegate = self
        deedTitleField.delegate = self
        deedPointsField.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.updateCharacterCount()
        
        // Subviews
        
        view.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(mainView)
        mainView.addSubview(deedTitleField)
        mainView.addSubview(imageButton)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(deedDescriptionTextView)
        mainView.addSubview(countLabel)
        mainView.addSubview(deedPointsField)
        mainView.addSubview(completeButton)
    }
    
    func updateCharacterCount() {
        let lettersCount = self.deedDescriptionTextView.text.count

        self.countLabel.text = "\((0) + lettersCount)/500"
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == deedDescriptionTextView){
            return textView.text.count +  (text.count - range.length) <= 500
        }
        return false
    }
    
    /**
        * Called when 'return' key pressed. return NO to ignore.
        */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.frame.height)
        backButton.frame = CGRect(x: 20,
                                  y: 50,
                                  width: 60,
                                  height: 60)
        backButton.layer.cornerRadius = 30
        mainView.frame = CGRect(x: 20,
                                y: view.height*(2/5),
                                width: view.width-40,
                                height: view.height/2)
        mainView.layer.cornerRadius = 20
        deedTitleField.frame = CGRect(x: 20,
                                      y: 20,
                                      width: mainView.width-110,
                                      height: 50)
        deedTitleField.layer.cornerRadius = 10
        imageButton.frame = CGRect(x: deedTitleField.right+15,
                                   y: 50,
                                   width: 60,
                                   height: 60)
        imageButton.center.y = deedTitleField.center.y
        imageButton.layer.cornerRadius = 30
        descriptionLabel.frame = CGRect(x: 20,
                                        y: deedTitleField.bottom+15,
                                        width: mainView.width,
                                        height: 20)
        deedDescriptionTextView.frame = CGRect(x: 20,
                                            y: descriptionLabel.bottom+5,
                                            width: mainView.width-35,
                                            height: 50)
        deedDescriptionTextView.layer.cornerRadius = 10
        countLabel.frame = CGRect(x: mainView.width-115,
                                  y: deedDescriptionTextView.bottom+5,
                                  width: 100,
                                  height: 20)
        deedPointsField.frame = CGRect(x: 20,
                                       y: countLabel.bottom+15,
                                       width: 100,
                                       height: 50)
        deedPointsField.layer.cornerRadius = 10
        completeButton.frame = CGRect(x: mainView.width-95,
                                      y: deedPointsField.bottom+10,
                                      width: 80,
                                      height: 50)
        completeButton.layer.cornerRadius = 15

    }

}

extension moderatorControlViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Favr Picture", message: "How would you like to select a photo?", preferredStyle: .actionSheet)
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
        
        let resultImage = selectedImage.resized(toWidth: 400)

        imageView.image = resultImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
