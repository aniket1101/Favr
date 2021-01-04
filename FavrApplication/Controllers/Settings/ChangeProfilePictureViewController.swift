//
//  ChangeProfilePictureViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 24/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import FirebaseUI
import SDWebImage
import Firebase

class ChangeProfilePictureViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .none
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = imageView.width / 2.0
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let changeProfilePictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Hey, looking for a different look?"
        label.font = UIFont(name: "Helvetica", size: 22)
        label.numberOfLines = -1
//        label.textColor =
        label.textAlignment = .center
        return label
    }()
    
    @objc private func didTapChangeProfilePicture() {
            presentPhotoActionSheet()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Profile Picture"
        
        // Load the initial image using SDWebImage
        let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        
        // Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(changeProfilePictureLabel)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self ,
                                             action: #selector(didTapChangeProfilePicture))
        imageView.addGestureRecognizer(gesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: (0+size)/2,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        changeProfilePictureLabel.frame = CGRect(x: 20,
                                                 y: imageView.bottom+20,
                                                 width: scrollView.width-40,
                                                 height: 90)
    }
}

extension ChangeProfilePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        // Upload image
        guard let image = self.imageView.image,
            let data = image.pngData() else {
                return
        }
        let filename = "\(DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!))_profile_picture.png"
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


