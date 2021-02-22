//
//  ProfileViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 03/01/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage
import Firebase
import MaterialComponents


final class ProfileViewController: UIViewController {
        
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
    
    private let streaksLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat", size: 16)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let qrButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "qrcode"), for: .normal)
        button.setBackground(color: .systemGroupedBackground)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(QRCodeTapped), for: .touchUpInside)
        return button
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.text.square"), for: .normal)
        button.setBackground(color: .systemGroupedBackground)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func QRCodeTapped() {
        print("QR Code Tapped")
    }
    
    @objc private func detailButtonTapped() {
        print("Detail Button Tapped")
    }
    
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
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(editProfilePressed), for: .touchUpInside)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3.circle"), for: .normal)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func editProfilePressed() {
        let vc = editProfileViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func backtoProfile() {
        navigationController?.navigationBar.isHidden = true
    }
        
    @objc private func settingsPressed() {
        let actionSheet = MaterialComponents.MDCActionSheetController()
        actionSheet.backgroundColor = .systemGroupedBackground
        actionSheet.actionFont = UIFont(name: "Montserrat", size: 18)
        actionSheet.actionTextColor = .secondaryLabel
        actionSheet.actionTintColor = .secondaryLabel
        let actionOne = MDCActionSheetAction(title: "Account", image: UIImage(named: "greyAccount")) { [weak self]_ in
//            self?.present(AccountSettingsViewController(), animated: true, completion: self?.backtoProfile)
            self?.navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
        }
        let actionTwo = MDCActionSheetAction(title: "Tell a Friend", image: UIImage(named: "greyTellafriend")) {_ in
            self.shareClicked()
        }
        let actionThree = MDCActionSheetAction(title: "About", image: UIImage(named: "greyAbout")) {_ in
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        }
        let actionFour = MDCActionSheetAction(title: "Moderator", image: UIImage(systemName: "star.square.fill")) { [weak self] _ in
            let vc = moderatorControlViewController()
            self?.navigationController?.push(vc)
        }
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(actionThree)
        let person = Auth.auth().currentUser
        let moderatorRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: person?.email ?? "email"))
        
        moderatorRef.child("onboardingComplete").observeSingleEvent(of: .value, with: {
            snapshot in
            let moderatorStatus = snapshot.value as? String
            
            if moderatorStatus == "true" {
                actionSheet.addAction(actionFour)
            }
        })

        present(actionSheet, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        customHeaderView.addSubview(editProfileButton)
        traitCollection.performAsCurrent {
            editProfileButton.layer.borderColor = UIColor.label.cgColor
        }
        
        // MARK: - Navigation Bar
        
        CustomNavigationBar.addSubview(titleLabel)
        CustomNavigationBar.addSubview(settingsButton)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false

        titleLabel.text = UserDefaults.standard.value(forKey: "name") as? String
                
        view.addSubview(CustomNavigationBar)
        
        // MARK: - HeaderView
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        customHeaderView.addSubview(profilePicture)

        let ref = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: email))

        ref.child("name").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let username = snapshot.value as? String
            self?.usernameLabel.text = "@"+username!
        })

        customHeaderView.addSubview(usernameLabel)

        ref.child("streaks").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let newStreaks = String(describing: snapshot.value ?? "🔥")
            self?.streaksLabel.text = newStreaks + " 🔥"
        })

        customHeaderView.addSubview(streaksLabel)

        ref.child("Status").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let status = snapshot.value as? String
            self?.statusLabel.text = status
        })
        customHeaderView.addSubview(statusLabel)

        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                self?.profilePicture.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        
        customHeaderView.addBottomBorder()
        customHeaderView.addSubview(qrButton)
        customHeaderView.addSubview(detailButton)
                
        view.addSubview(customHeaderView)
        
        // MARK: - LastView
        view.addSubview(lastView)
    }
    
    @objc private func shareClicked() {
        let item = ["Hi there, \n\nFavr is a simple, secure and elegant app that I use to make sure I'm doing good deeds every day. \n\nGet it for free at: https://google.co.uk"]
        let activity = UIActivityViewController(activityItems: item, applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let size = view.width / 6
        CustomNavigationBar.frame = CGRect(x: 0,
                                           y: 44,
                                           width: view.width,
                                           height: 60)
        titleLabel.frame = CGRect(x: 0,
                                  y: 20,
                                  width: CustomNavigationBar.width,
                                  height: 20)
        settingsButton.frame = CGRect(x: CustomNavigationBar.width-60,
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
        qrButton.frame = CGRect(x: (view.width/2)-10,
                                y: statusLabel.bottom+5,
                                width: 30,
                                height: 30)
        qrButton.center.x = view.center.x
        detailButton.frame = CGRect(x: qrButton.left-50,
                                    y: statusLabel.bottom+5,
                                    width: 30,
                                    height: 30)
        streaksLabel.frame = CGRect(x: qrButton.right+20,
                                   y: statusLabel.bottom+5,
                                 width: 50,
                                 height: 30)
        editProfileButton.frame = CGRect(x: (view.width/2)-60,
                                         y: streaksLabel.bottom+15,
                                         width: 120,
                                         height: 30)
        lastView.frame = CGRect(x: 0,
                                y: customHeaderView.bottom,
                                width: view.width,
                                height: view.height-customHeaderView.bottom)
    }
    
}


extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    
    // Alexander Volkov - https://stackoverflow.com/users/2022586/alexander-volkov

    /// Adds bottom border to the view with given side margins
    ///
    /// - Parameters:
    ///   - color: the border color
    ///   - margins: the left and right margin
    ///   - borderLineSize: the size of the border
    func addBottomBorder(color: UIColor = UIColor.quaternaryLabel, margins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
}

