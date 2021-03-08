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
import SwiftEntryKit
import Lottie


final class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var completedFavrsCollectionView: UICollectionView?
    private var completedFavrs = [completedFavr]()
            
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
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.alpha = 0
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat-Bold", size: 21)
        label.textColor = .label
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let streaksLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.textColor = .label
        label.backgroundColor = .systemFill
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    private let favrsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favrs", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Regular", size: 4)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.backgroundColor = .greenGrass
        button.alpha = 0
        button.addRightBorder(.separator, width: 1)
        return button
    }()
    
    private let pointsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Points", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Regular", size: 4)
        button.titleLabel?.textAlignment = .center
//        button.backgroundColor = .greenGrass
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addRightBorder(.separator, width: 1)
        button.alpha = 0
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Regular", size: 4)
        button.titleLabel?.textAlignment = .center
//        button.backgroundColor = .greenGrass
        button.addTarget(self, action: #selector(followersButtonTapped), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addRightBorder(.separator, width: 1)
        button.alpha = 0
        return button
    }()
    
    @objc private func followersButtonTapped() {
        SwiftEntryKit.dismiss()
        
        // Go back to Followers View
        let vc = followersViewController()
        vc.email = "\(Auth.auth().currentUser?.email ?? "email")"
        present(vc, animated: true, completion: nil)
    }
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Regular", size: 4)
        button.titleLabel?.textAlignment = .center
//        button.backgroundColor = .greenGrass
        button.addTarget(self, action: #selector(followingButtonTapped), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.alpha = 0
        return button
    }()
    
    @objc private func followingButtonTapped() {
        SwiftEntryKit.dismiss()
        
        // Go back to Following View
        let vc = followingViewController()
        vc.email = "\(Auth.auth().currentUser?.email ?? "email")"
        present(vc, animated: true, completion: nil)
    }
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat", size: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.alpha = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = .label
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.alpha = 0
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
    
    private let noCompletedFavrsLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't completed any Favrs. Add one!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
        
    @objc private func settingsPressed() {
        let actionSheet = MaterialComponents.MDCActionSheetController()
        actionSheet.backgroundColor = .systemGroupedBackground
        actionSheet.actionFont = UIFont(name: "Montserrat", size: 18)
        actionSheet.actionTextColor = .secondaryLabel
        actionSheet.actionTintColor = .secondaryLabel
        let actionOne = MDCActionSheetAction(title: "Account", image: UIImage(named: "greyAccount")) { [weak self]_ in
//            self?.present(AccountSettingsViewController(), animated: true, completion: self?.backtoProfile)
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
            self?.navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
        }
        let actionTwo = MDCActionSheetAction(title: "QR Code", image: UIImage(systemName: "qrcode"), handler: { [weak self] _ in
            print("QR Code Tapped")
            let vc = qrCodeGenerator()
            vc.profilePicture.image = self?.profilePicture.image
            vc.usernameLabel.text = self?.usernameLabel.text
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        })
        let actionThree = MDCActionSheetAction(title: "About", image: UIImage(systemName: "info.circle.fill")) {_ in
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        }
        let actionFour = MDCActionSheetAction(title: "Tell a Friend", image: UIImage(systemName: "heart.circle.fill")) {_ in
            self.shareClicked()
        }
        let actionFive = MDCActionSheetAction(title: "Moderator", image: UIImage(systemName: "star.square.fill")) { [weak self] _ in
            let vc = moderatorControlViewController()
            self?.navigationController?.push(vc)
        }
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(actionThree)
        actionSheet.addAction(actionFour)
        let person = Auth.auth().currentUser
        let moderatorRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: person?.email ?? "email"))
        
        moderatorRef.child("moderator").observeSingleEvent(of: .value, with: {
            snapshot in
            let moderatorStatus = snapshot.value as? String
            
            if moderatorStatus == "true" {
                actionSheet.addAction(actionFive)
            }
        })

        present(actionSheet, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        view.backgroundColor = .systemGroupedBackground
//        traitCollection.performAsCurrent {
//            editProfileButton.layer.borderColor = UIColor.label.cgColor
//        }
        
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
        completedFavrsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 50, right: 10)
        completedFavrsCollectionView.contentInsetAdjustmentBehavior = .never
        
        completedFavrsCollectionView.delegate = self
        completedFavrsCollectionView.dataSource = self
        completedFavrsCollectionView.backgroundColor = .systemGroupedBackground
        completedFavrsCollectionView.showsHorizontalScrollIndicator = false
        completedFavrsCollectionView.semanticContentAttribute = .forceRightToLeft
        completedFavrsCollectionView.alpha = 0
        completedFavrsCollectionView.frame = CGRect(x: 0,
                                                    y: 0,
                                              width: 0,
                                              height: 0)
        
        // Notification Center Observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name("logOut"), object: nil, queue: nil) { (_) in
            SwiftEntryKit.dismiss()
            
            // Sign out
            do { try Auth.auth().signOut() }
            catch { print("already logged out") }
            
            // Go back to Start View
            let vc = startPageViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true) {
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: false)
            }
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

        let ref = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: email))

        ref.child("name").observe(.value, with: { [weak self]
            snapshot in
            let username = snapshot.value as? String
            self?.usernameLabel.text = "@"+username!
        })

        customHeaderView.addSubview(usernameLabel)

        ref.child("streaks").observe(.value, with: { [weak self]
            snapshot in
            let newStreaks = String(describing: snapshot.value ?? "🔥")
            self?.streaksLabel.text = newStreaks + " 🔥"
        })

        CustomNavigationBar.addSubview(streaksLabel)

        ref.child("Status").observe(.value, with: { [weak self]
            snapshot in
            let status = snapshot.value as? String
            self?.statusLabel.text = status
        })
        customHeaderView.addSubview(statusLabel)
        
        ref.child("totalDeeds").observe(.value, with: { [weak self]
            snapshot in
            
            let totalDeeds = String(describing: snapshot.value ?? 0)
            if totalDeeds == "1" {
                self?.favrsButton.setTitle("\(totalDeeds) Favr", for: .normal)
            }
            else {
                self?.favrsButton.setTitle("\(totalDeeds) Favrs", for: .normal)
            }
        })
        
        ref.child("points") .observe(.value, with: { [weak self]
            snapshot in
            
            let points = String(describing: snapshot.value ?? 0)
            if points == "1" {
                self?.pointsButton.setTitle("\(points) Point", for: .normal)
            }
            else {
                self?.pointsButton.setTitle("\(points) Points", for: .normal)
            }
            self?.favrsButton.fadeIn()
            self?.pointsButton.fadeIn()
            self?.followersButton.fadeIn()
            self?.followingButton.fadeIn()
            self?.profilePicture.fadeIn()
            self?.editProfileButton.fadeIn()
            self?.usernameLabel.fadeIn()
            self?.statusLabel.fadeIn()


        })

        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                self?.profilePicture.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        
        customHeaderView.addBottomBorder()
        customHeaderView.addSubview(editProfileButton)
        customHeaderView.addSubview(favrsButton)
        customHeaderView.addSubview(pointsButton)
        customHeaderView.addSubview(followingButton)
        customHeaderView.addSubview(followersButton)
        view.addSubview(customHeaderView)
        
        // MARK: - LastView
        view.addSubview(lastView)
        lastView.addSubview(noCompletedFavrsLabel)
        
        // MARK: - Collection View
        lastView.addSubview(completedFavrsCollectionView)
        startListeningForCompletedFavrs()
        completedFavrsCollectionView.reloadData()
    }
    
    @objc private func shareClicked() {
        let item = ["Hi there, \n\nFavr is a simple, secure and elegant app that I use to make sure I'm doing good deeds every day. \n\nGet it for free at: https://google.co.uk"]
        let activity = UIActivityViewController(activityItems: item, applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    
    private func startListeningForCompletedFavrs() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("Starting completed favrs fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        let size = view.width / 6
        let labelWidth = (view.width)/4
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
                                               height: 50)
        }
        
        titleLabel.frame = CGRect(x: 55,
                                  y: 20,
                                  width: CustomNavigationBar.width-110,
                                  height: 20)
        settingsButton.frame = CGRect(x: CustomNavigationBar.width-50,
                                      y: 5,
                                      width: 40,
                                      height: 40)
        streaksLabel.frame = CGRect(x: settingsButton.left-50,
                                    y: 5,
                                    width: 40,
                                    height: 40)
        streaksLabel.layer.cornerRadius = 12
        streaksLabel.center.y = settingsButton.center.y
        customHeaderView.frame = CGRect(x: 0,
                                        y: CustomNavigationBar.bottom,
                                        width: view.width,
                                        height: view.height*0.5-(CustomNavigationBar.bottom))
        profilePicture.frame = CGRect(x: (view.width/2)-50,
                                      y: 20,
                                      width: 100,
                                      height: 100)
        editProfileButton.frame = CGRect(x: profilePicture.center.x + 25,
                                         y: profilePicture.center.y + 25,
                                         width: 30,
                                         height: 30)
        editProfileButton.layer.cornerRadius = editProfileButton.frame.size.width / 2
        usernameLabel.frame = CGRect(x: 0,
                                     y: profilePicture.bottom+10,
                                     width: view.width,
                                     height: 34)
        statusLabel.frame = CGRect(x: 0,
                                   y: usernameLabel.bottom+5,
                                   width: view.width,
                                   height: 30)
        favrsButton.frame = CGRect(x: 0,
                                  y: statusLabel.bottom + 15,
                                  width: labelWidth,
                                  height: 30)
        pointsButton.frame = CGRect(x: favrsButton.right,
                                   y: 0,
                                   width: labelWidth,
                                   height: 30)
        pointsButton.center.y = favrsButton.center.y
        followersButton.frame = CGRect(x: pointsButton.right,
                                      y: 0,
                                      width: labelWidth,
                                      height: 30)
        followersButton.center.y = favrsButton.center.y
        followingButton.frame = CGRect(x: followersButton.right,
                                      y: 0,
                                      width: labelWidth,
                                      height: 30)
        followingButton.center.y = favrsButton.center.y
        
        if UIDevice.current.hasNotch {
            lastView.frame = CGRect(x: 0,
                                    y: customHeaderView.bottom,
                                    width: view.width,
                                    height: (view.height*0.5))
        }
        else {
            lastView.frame = CGRect(x: 0,
                                    y: customHeaderView.bottom,
                                    width: view.width,
                                    height: (view.height*0.5))
        }
        noCompletedFavrsLabel.center = lastView.center
        completedFavrsCollectionView?.frame = CGRect(x: 0,
                                                    y: 0,
                                                    width: lastView.width,
                                                    height: (lastView.height))
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.completedFavrsCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpace = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpace
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthWithSpace - scrollView.contentInset.left, y: scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
}

