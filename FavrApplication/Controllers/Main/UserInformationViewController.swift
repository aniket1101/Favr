//
//  UserInformationViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 13/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
//import MessageKit
import SDWebImage
import SystemConfiguration
import MessageUI
import NotificationCenter

class UserInformationViewController: UIViewController, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
        
    private var otherUserPhotoURL: URL?
    var safeEmail: String?
    var otherUserEmail: String?
    var otherUserName: String?
    var otherUserUsername: String?
    var otherUserStatus: String?
    
    private var completedFavrsCollectionView: UICollectionView?
    private var completedFavrs = [completedFavr]()
    
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
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.tintColor = .label
        button.setBackground(color: .systemGroupedBackground)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func backButtonTapped() {
        navigationController?.pop()
    }
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.text.square"), for: .normal)
        button.setBackground(color: .systemFill)
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
    
//    private let followUnfollowButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(named: "FavrOrange")
//        return button
//    }()
    
    let dismissButton: UIButton = {
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
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.backgroundColor = .systemFill
        label.textColor = .label
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let mailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        button.imageView?.tintColor = .label
        button.setBackground(color: .systemFill)
        button.addTarget(self, action: #selector(showMailComposer), for: .touchUpInside)
        return button
    }()
    
    private let noCompletedFavrsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favrs Completed"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
        
    @objc private func dismissPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("qrDismissButtonTapped"), object: nil)
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
        
        // MARK: - Completed Favrs Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: view.width-60,
                                 height: view.height*0.35)
//        layout.itemSize = CGSize(width: 350,
//                                 height: 300)
        
        completedFavrsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let completedFavrsCollectionView = completedFavrsCollectionView else {
            return
        }
        completedFavrsCollectionView.registerCell(CompletedFavrsCollectionViewCell.self, forCellWithReuseIdentifier: CompletedFavrsCollectionViewCell.identifier)
        completedFavrsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
        completedFavrsCollectionView.contentInsetAdjustmentBehavior = .never
        
        completedFavrsCollectionView.delegate = self
        completedFavrsCollectionView.dataSource = self
        completedFavrsCollectionView.backgroundColor = .systemGroupedBackground
        completedFavrsCollectionView.showsHorizontalScrollIndicator = false
        completedFavrsCollectionView.alpha = 0
        completedFavrsCollectionView.semanticContentAttribute = .forceRightToLeft
        completedFavrsCollectionView.frame = CGRect(x: 0,
                                                    y: (view.height*0.4)+80,
                                              width: view.width,
                                              height: (view.height*0.4))
                        
        // MARK: - HeaderView
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: otherUserEmail!)
        print("Other User Email:", otherUserEmail!)
        
        print("Safe Email:", safeEmail)

        let reference = Database.database().reference().child("Users").child(safeEmail)

        reference.child("Status").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let otherUserStatus = snapshot.value as? String
            self?.statusLabel.text = otherUserStatus ?? ""
        })
        reference.child("Display Name").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let otherUserName = snapshot.value as? String
            self?.titleLabel.text = otherUserName ?? ""
        })
        reference.child("name").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let otherUserUsername = snapshot.value as? String
            self?.usernameLabel.text = "@"+otherUserUsername!
        })
        reference.child("email").observeSingleEvent(of: .value, with: {
            snapshot in
            let email = snapshot.value as? String
            self.otherUserEmail = email ?? ""
        })

        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        let ref = Database.database().reference().child("Users").child(safeEmail)

        ref.child("streaks").observeSingleEvent(of: .value, with: { [weak self]
            snapshot in
            let newStreaks = String(describing: snapshot.value ?? "🔥")
            self?.streaksLabel.text = newStreaks + " 🔥"
        })


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
        
        // FollowUnfollowButton
//        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: "\(Auth.auth().currentUser?.email ?? "email")")
//        let followUnfollowButtonRef = Database.database().reference().child("Users").child(currentUserSafeEmail).child("Following").child(safeEmail)
//        followUnfollowButtonRef.observe(.value, with: { [weak self]
//            snapshot in
//            let followUnfollow = snapshot.value as? String
//            if followUnfollow == "following" {
//            self?.followUnfollowButton.setTitle("Unfollow", for: .normal)
//            }
//            else {
//                self?.followUnfollowButton.setTitle("Follow", for: .normal)
//            }
//        })
//
//        if followUnfollowButton.titleLabel?.text == "Follow" {
//            followUnfollowButton.backgroundColor = UIColor(named: "FavrOrange")
//            followUnfollowButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
//        }
//        else {
//            followUnfollowButton.backgroundColor = UIColor(named: "FavrDarkOrange")
//            followUnfollowButton.addTarget(self, action: #selector(unfollowUser), for: .touchUpInside)
//        }
                
        // Subviews
        view.addSubview(scrollView)
        view.addSubview(CustomNavigationBar)
        view.addSubview(customHeaderView)
        view.addSubview(lastView)
        CustomNavigationBar.addSubview(titleLabel)
        CustomNavigationBar.addSubview(dismissButton)
        CustomNavigationBar.addSubview(backButton)
        customHeaderView.addSubview(usernameLabel)
        customHeaderView.addSubview(mailButton)
        customHeaderView.addSubview(statusLabel)
        customHeaderView.addSubview(profilePicture)
        customHeaderView.addSubview(detailButton)
        customHeaderView.addSubview(streaksLabel)
        lastView.addSubview(noCompletedFavrsLabel)
//        customHeaderView.addSubview(followUnfollowButton)

        
        view.add(gesture: .swipe(.down)) {
            self.navigationController?.pop()
        }
        
        view.add(gesture: .swipe(.right)) {
            self.navigationController?.pop()
        }
        
        // MARK: - Collection View
        view.addSubview(completedFavrsCollectionView)
        startListeningForCompletedFavrs()
        completedFavrsCollectionView.reloadData()
    }
    
//    @objc private func followUser() {
//        print("\(otherUserEmail ?? "ERROR: No user") has been followed.")
//        DispatchQueue.main.async { [weak self] in
//            self?.followUnfollowButton.titleLabel?.text = "Unfollow"
//            self?.followUnfollowButton.backgroundColor = UIColor(named: "FavrDarkOrange")
//
//            let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: "\(Auth.auth().currentUser?.email ?? "email")")
//            let followUnfollowButtonRef = Database.database().reference().child("Users").child(currentUserSafeEmail).child("Following").child(self?.safeEmail ?? "email")
//            followUnfollowButtonRef.removeValue()
//
//        }
//    }
//
//    @objc private func unfollowUser() {
//        print("\(otherUserEmail ?? "ERROR: No user") has been unfollowed.")
//        DispatchQueue.main.async { [weak self] in
//            self?.followState = "Follow"
//            self?.followUnfollowButton.backgroundColor = UIColor(named: "FavrOrange")
//
//            let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: "\(Auth.auth().currentUser?.email ?? "email")")
//            let followUnfollowButtonRef = Database.database().reference().child("Users").child(currentUserSafeEmail).child("Following").child(self?.safeEmail ?? "email")
//            followUnfollowButtonRef.setValue("")
//        }
//    }
    
    private func startListeningForCompletedFavrs() {
        print("Starting completed favrs fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: "\(otherUserEmail ?? "email")")
        DatabaseManager.shared.getAllCompletedFavrs(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let completedFavrs):
                print("successfully got completedFavrs")
                self?.completedFavrsCollectionView?.fadeIn()

                guard !completedFavrs.isEmpty else {
                    self?.completedFavrsCollectionView?.isHidden = true
                    self?.view.bringSubviewToFront(self!.noCompletedFavrsLabel)
                    self?.noCompletedFavrsLabel.isHidden = false
                    return
                }
                self?.noCompletedFavrsLabel.isHidden  = true
                self?.completedFavrsCollectionView?.isHidden = false
                self?.completedFavrs = completedFavrs
                
                DispatchQueue.main.async {
                    self?.completedFavrsCollectionView?.reloadData()
                }
                
            case .failure(let error):
                self?.completedFavrsCollectionView?.isHidden = true
                self?.noCompletedFavrsLabel.isHidden = true
//                let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//                self?.present(alert, animated: true)
                
                print("failed to get completedFavrs: \(error)")
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        completedFavrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = completedFavrs[indexPath.row]
        let completedFavrCell = collectionView.dequeueReusableCell(withReuseIdentifier: "completedFavrCollectionViewCell", for: indexPath) as! CompletedFavrsCollectionViewCell
        
        completedFavrCell.configure(with: model)
        return completedFavrCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = completedFavrsDetailedViewController()
        let completedDeedTitle = completedFavrs[indexPath.row].title
        let completedDeedDescription = completedFavrs[indexPath.row].description
        vc.deedTitle = completedDeedTitle
        vc.deedDescription = completedDeedDescription
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.hasNotch {
            CustomNavigationBar.frame = CGRect(x: 0,
                                               y: 44,
                                               width: view.width,
                                               height: 60)
        }
        else {
            CustomNavigationBar.frame = CGRect(x: 0,
                                               y: 10,
                                               width: view.width,
                                               height: 60)
        }
        titleLabel.frame = CGRect(x: 0,
                                  y: 20,
                                  width: CustomNavigationBar.width,
                                  height: 20)
        dismissButton.frame = CGRect(x: CustomNavigationBar.width-60,
                                      y: 5,
                                      width: 50,
                                      height: 50)
        backButton.frame = CGRect(x: 10,
                                  y: 10,
                                  width: 20,
                                  height: 40)
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
        mailButton.center.x = view.center.x
        mailButton.layer.cornerRadius = mailButton.frame.size.width / 2
        detailButton.frame = CGRect(x: mailButton.left-50,
                                    y: statusLabel.bottom+5,
                                    width: 30,
                                    height: 30)
        detailButton.layer.cornerRadius = detailButton.frame.size.width / 2
        streaksLabel.frame = CGRect(x: mailButton.right+20,
                                   y: statusLabel.bottom+5,
                                 width: 50,
                                 height: 30)
        streaksLabel.layer.cornerRadius = 12
        mailButton.center.x = view.center.x
//        followUnfollowButton.frame = CGRect(x: 0,
//                                            y: mailButton.bottom+5,
//                                            width: 110,
//                                            height: 50)
//        followUnfollowButton.center.x = view.center.x
        lastView.frame = CGRect(x: 0,
                                y: customHeaderView.bottom,
                                width: view.width,
                                height: view.height-customHeaderView.bottom)
        noCompletedFavrsLabel.center = lastView.center
    }
    
}
