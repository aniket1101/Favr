//
//  UserInformationViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 13/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import SDWebImage
import SystemConfiguration
import MessageUI

class UserInformationViewController: UIViewController, MFMailComposeViewControllerDelegate {
        
    private var otherUserPhotoURL: URL?
    var safeEmail: String?
    var otherUserEmail: String?
    var otherUserName: String?
    var otherUserUsername: String?
    var otherUserStatus: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let CustomNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let customHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.text.square"), for: .normal)
        button.setBackground(color: .systemGroupedBackground)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func detailButtonTapped() {
        print("Detail Button Tapped")
    }
    
    private let lastView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat-Bold", size: 21)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat", size: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
        return button
    }()
    
    private let streaksLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat", size: 16)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let mailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(showMailComposer), for: .touchUpInside)
        return button
    }()
        
    @objc private func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
                //Show alert informing the user
                let alert = UIAlertController(title: "Whoops!",
                                              message: "Mail services are not available.",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay",
                                              style: .default, handler: nil))
                present(alert, animated: true)
            return
            }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["\(otherUserEmail ?? "Enter email...")"])
        present(composer, animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        scrollView.isScrollEnabled = true
        
        // MARK: - Navigation Bar
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        titleLabel.text = otherUserName
                
        // MARK: - HeaderView
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: otherUserEmail!)
        
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        
        let ref = Database.database().reference().child(safeEmail)
        
        ref.child("streaks").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let newStreaks = String(describing: snapshot.value ?? "🔥")
            self?.streaksLabel.text = newStreaks + " 🔥"
        })
                
        usernameLabel.text = otherUserUsername
        statusLabel.text = otherUserStatus
        
        
        
        // Download Other User's Profile Picture
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                self?.profilePicture.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        
        customHeaderView.addBottomBorder()
                
        // Subviews
        view.addSubview(scrollView)
        view.addSubview(CustomNavigationBar)
        view.addSubview(customHeaderView)
        view.addSubview(lastView)
        CustomNavigationBar.addSubview(titleLabel)
        CustomNavigationBar.addSubview(dismissButton)
        customHeaderView.addSubview(usernameLabel)
        customHeaderView.addSubview(mailButton)
        customHeaderView.addSubview(statusLabel)
        customHeaderView.addSubview(profilePicture)
        customHeaderView.addSubview(detailButton)
        customHeaderView.addSubview(streaksLabel)

        
        view.add(gesture: .swipe(.down)) {
            self.navigationController?.pop()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CustomNavigationBar.frame = CGRect(x: 0,
                                           y: 44,
                                           width: view.width,
                                           height: 60)
        titleLabel.frame = CGRect(x: 0,
                                  y: 20,
                                  width: CustomNavigationBar.width,
                                  height: 20)
        dismissButton.frame = CGRect(x: CustomNavigationBar.width-60,
                                      y: 5,
                                      width: 50,
                                      height: 50)
        customHeaderView.frame = CGRect(x: 0,
                                        y: 104,
                                        width: view.width,
                                        height: view.height*0.4)
        profilePicture.frame = CGRect(x: (view.width/2)-50,
                                      y: 20,
                                      width: 100,
                                      height: 100)
        usernameLabel.frame = CGRect(x: 0,
                                     y: profilePicture.bottom+10,
                                     width: view.width,
                                     height: 34)
        statusLabel.frame = CGRect(x: 0,
                                    y: usernameLabel.bottom+5,
                                   width: view.width,
                                   height: 30)
        mailButton.frame = CGRect(x: (view.width/2)-10,
                                y: statusLabel.bottom+5,
                                width: 30,
                                height: 30)
        detailButton.frame = CGRect(x: mailButton.left-50,
                                    y: statusLabel.bottom+5,
                                    width: 30,
                                    height: 30)
        streaksLabel.frame = CGRect(x: mailButton.right+20,
                                   y: statusLabel.bottom+5,
                                 width: 50,
                                 height: 30)
        mailButton.center.x = view.center.x
        lastView.frame = CGRect(x: 0,
                                y: customHeaderView.bottom,
                                width: view.width,
                                height: view.height-customHeaderView.bottom)
    }
    
}
