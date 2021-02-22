//
//  DeedsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 21/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import Network
import SwiftEntryKit

class DeedsViewController: UIViewController {
    
    var deedTitle: String?
    
    @IBOutlet weak var favrsLabel: UILabel!
    
    @IBOutlet weak var rankingsButton: UIButton!
    
    @IBOutlet weak var journalsButton: UIButton!
    
    @IBOutlet weak var deedsCollectionView: UICollectionView!
    
    @IBAction func journalsButtonTapped(_ sender: Any) {
        let vc = JournalsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func rankingsButtonTapped(_ sender: Any) {
        let vc = RankingsViewController()
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    var deeds = Deed.fetchDeeds()
    
    private let spinner: JGProgressHUD = {
        let spinner = JGProgressHUD(style: .dark)
        spinner.square = true
        spinner.cornerRadius = 12
        return spinner
    }()
    
    lazy var popUpAlert: CustomPopUpAlert = {
        let view = CustomPopUpAlert()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.popUpAlertDelegate = self
        return view
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)
        button.tintColor = .systemBackground
        button.clipsToBounds = true
        button.setBackground(color: .label)
        button.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func chatButtonTapped() {
        let vc = ConversationsViewController()
//        hidesBottomBarWhenPushed = true
//        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.frame.origin = CGPoint(x: 0, y: 20)
//        navigationController?.push(vc)
        favrsLabel.heroID = "viewTitleLabel"
        chatButton.heroID = "viewTitleButton"
        vc.chatTitleLabel.heroID = "viewTitleLabel"
        vc.searchButton.heroID = "viewTitleButton"
        showHero(vc)
    }
    
    let monitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            print("No user")
            view.addSubview(visualEffectView)
        }
        else {
            title = nil
            tabBarController?.tabBar.isHidden = false
            navigationController?.navigationBar.isHidden = true
        }
        deedsCollectionView.contentInsetAdjustmentBehavior = .never
        
        
        // MARK:- Collection View Cell
        let cellScale: CGFloat = 0.6
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = deedsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout?.estimatedItemSize = .zero
        deedsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        deedsCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        // Subviews
        
        view.addSubview(chatButton)
        
        // Check internet connectivity
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                
            }
            else {
                print("Disconnected")
                func setUpDisconnectedAttributes() -> EKAttributes {
                    var attributes = EKAttributes.topNote
                    attributes.displayDuration = 5
                    attributes.entryBackground = .gradient(
                        gradient: .init(
                            colors: [Colour.Orange.a1, Colour.Orange.a2, Colour.Orange.a3, Colour.Orange.a4, Colour.Orange.a5, Colour.Orange.a6], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                    attributes.scroll = .edgeCrossingDisabled(swipeable: true)
                    attributes.displayMode = .inferred
                    attributes.statusBar = .currentStatusBar
                    attributes.entryInteraction = .absorbTouches
                    attributes.precedence.priority = .max
                    return attributes
                }
                
                DispatchQueue.main.async {
                    SwiftEntryKit.display(entry: DisconnectedView(), using: setUpDisconnectedAttributes())
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        // Miscellaneous
        
        deedsCollectionView.dataSource = self
        deedsCollectionView.delegate = self
        
        favrsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        
        print("Today:", Date.now())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.deedsCollectionView.collectionViewLayout.invalidateLayout()
        chatButton.frame = CGRect(x: view.width-90,
                                  y: favrsLabel.top,
                                  width: 50,
                                  height: 50)
        chatButton.layer.cornerRadius = chatButton.frame.size.width / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.dismiss()
        validateAuth()
        validateVerification()
        
//        DispatchQueue.main.async {
//                    self.navigationController?.navigationBar.setNeedsLayout()
//                }
        
        // MARK: Onboarding
        
        let person = Auth.auth().currentUser
        
        let reference = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: person?.email ?? "email"))
            
            reference.child("onboardingComplete").observeSingleEvent(of: .value, with: {
                snapshot in
                let onboardingStatus = snapshot.value as? String
                print(onboardingStatus ?? "failed")
                
                if onboardingStatus == "false" {
                    self.view.addSubview(self.popUpAlert)
                    // MARK: - popUpAlert
                    self.popUpAlert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
                    self.popUpAlert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.popUpAlert.heightAnchor.constraint(equalToConstant: self.view.frame.width - 64).isActive = true
                    self.popUpAlert.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32).isActive = true
                    
                    self.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.popUpAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5) { [weak self] in
                        self?.visualEffectView.alpha = 1
                        self?.popUpAlert.alpha = 1
                        self?.popUpAlert.transform = CGAffineTransform.identity
                    }
                }
            })
        enableHero()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableHero()
    }
    
    private func validateVerification() {
        
        if Auth.auth().currentUser?.isEmailVerified == false {
            let vc = UserVerificationViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present (nav, animated: true)

        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = startPageViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present (nav, animated: false)
        }
    }
}

// MARK: - Pop Ups

extension DeedsViewController: userVerificationPopUpDelegate {
        @objc func dismissingNav() {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    func handlingSuccess() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            let vc = UserVerificationViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true)
            print("Success: Did remove pop up window")
        }
    }

}

    extension DeedsViewController: popUpDelegate {
        @objc func dismissNav() {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpAlert.removeFromSuperview()
            print("Dismissal: Did remove pop up window")
            let person = Auth.auth().currentUser
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            guard let key = ref.child("onboardingComplete").key else { return }
            
            let childUpdates = ["\(key)": "true",
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
        }
    }
    func handleSuccess() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.visualEffectView.alpha = 0
            self?.popUpAlert.alpha = 0
            self?.popUpAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            let vc = OnboardingViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true)
            let person = Auth.auth().currentUser
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            guard let key = ref.child("onboardingComplete").key else { return }
            
            let childUpdates = ["\(key)": "true",
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
            print("Success: Did remove pop up window")
        }
    }

}

extension DeedsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DeedsFirstViewController()
        vc.deedTitle = deeds[indexPath.row].title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeedsCollectionViewCell", for: indexPath) as! DeedsCollectionViewCell
        let deed = deeds[indexPath.item]
        
        cell.deed = deed
        
        return cell
    }
}

extension DeedsViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.deedsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpace = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpace
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthWithSpace - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
