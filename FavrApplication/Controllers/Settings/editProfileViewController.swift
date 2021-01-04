//
//  editProfileViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 31/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import SDWebImage
import NotificationCenter
import Firebase

struct EditProfileFormModel {
    let title: String
    let handler: (() -> Void)
}

class editProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .systemGroupedBackground
        return table
    }()
    
    private var models = [[EditProfileFormModel]]()
    
    private let profilePictureView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle.fill")
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 70
        return imageView
    }()
    
    private let changeProfilePictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Change profile picture"
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    @objc private func didTapChangeProfilePicture() {
            presentPhotoActionSheet()
        }
    
    @objc private func didTapSave() {
        dismiss(animated: true, completion: nil)
    }
    
//    @objc private func didTapCancel() {
//        dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        configureModels()
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
//                                                           style: .plain,
//                                                           target: self,
//                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
//        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "FavrOrange")

        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
        
        // MARK: - Main Views
        view.addSubview(profilePictureView)
        view.addSubview(tableView)
                
        // MARK: - Profile Picture View
        profilePictureView.addSubview(profilePicture)
        profilePictureView.addSubview(changeProfilePictureLabel)
        
        profilePicture.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self ,
                                             action: #selector(didTapChangeProfilePicture))
        profilePicture.addGestureRecognizer(gesture)
        
        profilePictureView.addBottomBorder()

//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
        
    }
    
    private func configureModels() {
        // name, username, website, status
        models.append([
            EditProfileFormModel(title: "Name") {  [weak self] in
                print("yes")
                let vc = ChangeDisplayNameViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self?.present (nav, animated: false)
            },
            EditProfileFormModel(title: "Display Name") {  [weak self] in
                let vc = ChangeDisplayNameViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self?.present (nav, animated: false)
            },
            EditProfileFormModel(title: "Status") {  [weak self] in
                let vc = ChangeStatusViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self?.present (nav, animated: false)
            }
        ])
        models.append([
            EditProfileFormModel(title: "Private Settings") { [weak self] in
                let vc = privateSettingsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self?.present (nav, animated: false)
            }
        ])
    }
    
    // MARK: - Action
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK:- Profile Picture View Layout
        profilePictureView.frame = CGRect(x: 0,
                                          y: 104,
                                        width: view.width,
                                        height: view.height*0.3)
        profilePicture.frame = CGRect(x: (view.width/2)-70,
                                      y: 20,
                                      width: 140,
                                      height: 140)
        changeProfilePictureLabel.frame = CGRect(x: 0,
                                                 y: profilePicture.bottom+20,
                                                 width: view.width,
                                                 height: 20)
        // MARK:- Table View Layout
        tableView.frame = CGRect(x: 0,
                                 y: profilePictureView.bottom,
                                 width: view.width,
                                 height: view.height-profilePictureView.height)
    }

}

extension editProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        profilePicture.image = selectedImage
        
        // MARK:- Upload image
        guard let image = self.profilePicture.image,
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
        
        // MARK:- Finishing up
        profilePicture.image = UIImage(systemName: "camera.circle.fill")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension editProfileViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = models[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .secondaryLabel
        if cell.textLabel?.text == "Name" {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            ref.child("Name").observe(.value, with: {
                snapshot in
                let newInfo = snapshot.value as? String
                cell.imageView?.image = UIImage(systemName: "lock")
                cell.imageView?.tintColor = .secondaryLabel
                cell.textLabel?.textColor = .secondaryLabel
                cell.detailTextLabel?.text = newInfo
                cell.accessoryType = .none
                cell.isUserInteractionEnabled = false
                cell.isSelected = false
            })
        }
        else if cell.textLabel?.text == "Display Name" {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            ref.child("Display Name").observe(.value, with: {
                snapshot in
                let newInfo = snapshot.value as? String
                cell.detailTextLabel?.text = newInfo
            })
        }
        else if cell.textLabel?.text == "Status" {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            ref.child("Status").observe(.value, with: {
                snapshot in
                let newInfo = snapshot.value as? String
                cell.detailTextLabel?.text = newInfo
            })
        }
        
        if cell.textLabel?.text == "Private Settings" {
            cell.textLabel?.text = models[indexPath.section][indexPath.row].title
            cell.accessoryType = .none
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .systemBlue
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        models[indexPath.section][indexPath.row].handler()
    }
}

//extension editProfileViewController: EditProfileTableViewCellDelegate {
//    func editProfileTableViewCell(_ cell: EditProfileTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
//        print(updatedModel.value ?? "nil")
//    }
//}
