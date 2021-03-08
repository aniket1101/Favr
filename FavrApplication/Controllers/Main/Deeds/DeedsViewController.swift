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
import Lottie

class DeedsViewController: UIViewController, UICollectionViewDelegate {
    
    var deedTitle: String?
    
    private var favrCollectionView: UICollectionView?
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.trackTintColor = .gray
        progressBar.progressTintColor = UIColor(named: "FavrOrange")
        progressBar.progress = 0
        return progressBar
    }()
        
    private let rankingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Rankings", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(rankingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let journalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Journal", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(journalsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let singleView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let favrsLabel: UILabel = {
        let label = UILabel()
        label.text = "Favrs"
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 35)
        label.textColor = .label
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.isOpaque = false
        return label
    }()
    
    private var favrs = [Favr]()
    
    /// Presents the Rankings View
    @objc private func rankingsButtonTapped() {
        let vc = RankingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    /// Presents the Journals View
    @objc private func journalsButtonTapped() {
        let vc = JournalsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
        
//    var deeds = Deed.fetchDeeds()
    
//    private let spinner: JGProgressHUD = {
//        let spinner = JGProgressHUD(style: .dark)
//        spinner.square = true
//        spinner.cornerRadius = 12
//        return spinner
//    }()
    
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
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.tintColor = .systemGroupedBackground
        button.clipsToBounds = true
        button.setBackground(color: .label)
        button.imageView?.tintColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    /// Searches for the entered query and pushes the user's profile
    @objc private func didTapSearchButton() {
        let vc = searchUsersViewController()
        vc.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let vcpush = UserInformationViewController()
            vcpush.otherUserEmail = result.email
            vcpush.navigationItem.largeTitleDisplayMode = .never
            vcpush.dismissButton.isHidden = true
            vcpush.backButton.isHidden = false
            vcpush.navigationItem.backButtonDisplayMode = .minimal
            strongSelf.navigationController?.push(vcpush, animated: true)
        }
            
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
//    private let chatButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)
//        button.tintColor = .systemBackground
//        button.clipsToBounds = true
//        button.setBackground(color: .label)
//        button.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    @objc private func chatButtonTapped() {
//        let vc = ConversationsViewController()
//        hidesBottomBarWhenPushed = true
//        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.frame.origin = CGPoint(x: 0, y: 20)
//        favrsLabel.heroID = "viewTitleLabel"
//        chatButton.heroID = "viewTitleButton"
//        vc.chatTitleLabel.heroID = "viewTitleLabel"
//        vc.chatTitleLabel.isOpaque = false
//        vc.searchButton.heroID = "viewTitleButton"
//        showHero(vc)
//    }
    
    private let animationView: AnimationView = {
        let view = AnimationView()
        view.isHidden = true
        return view
    }()
    
    func startAnimation() {
        animationView.animation = Animation.named("44656-error")
        animationView.play()
        animationView.loopMode = .loop
    }
    
    private let noFavrsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favrs"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
//        private let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
//        private let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    let monitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        title = nil
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setHidden()
        navigationController?.navigationBar.isHidden = true
        
        let favrLayout = UICollectionViewFlowLayout()
        favrLayout.scrollDirection = .horizontal
        favrLayout.item(width: view.width*0.6,
                        height: view.height*0.6)
        favrLayout.estimatedItemSize = .zero
        favrLayout.minimumInteritemSpacing = 30
        favrLayout.minimumLineSpacing = 30
        favrCollectionView = UICollectionView(frame: .zero, collectionViewLayout: favrLayout)
        guard let favrCollectionView = favrCollectionView else {
            return
        }
        favrCollectionView.registerCell(favrsCollectionViewCell.self, forCellWithReuseIdentifier: favrsCollectionViewCell.identifier)
        favrCollectionView.clipsToBounds = true
        let insetX = (view.width - (view.width*0.6))/2.0
        let insetY = (view.height - (view.height*0.6))/2.0
        favrCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        favrCollectionView.contentInsetAdjustmentBehavior = .never
        favrCollectionView.showsHorizontalScrollIndicator = false
        favrCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favrCollectionView.dataSource = self
        favrCollectionView.delegate = self
        favrCollectionView.backgroundColor = .systemGroupedBackground
        favrCollectionView.alpha = 0
        favrCollectionView.semanticContentAttribute = .forceRightToLeft
//        favrCollectionView.autoresizesSubviews = false
        view.addSubview(favrCollectionView)
        
        favrCollectionView.frame = view.bounds
        
        // Subviews
        
        view.addSubview(favrsLabel)
        view.addSubview(searchButton)
        view.addSubview(singleView)
        view.addSubview(progressBar)
//        view.addSubview(chatButton)
//        view.addSubview(rankingsButton)
        view.addSubview(noFavrsLabel)
        view.addSubview(animationView)
        view.addSubview(journalsButton)
        
        // Constraints
        
        rankingsButton.translatesAutoresizingMaskIntoConstraints = false
        journalsButton.translatesAutoresizingMaskIntoConstraints = false
        [
//            rankingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            rankingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            rankingsButton.heightAnchor.constraint(equalToConstant: 30),
            journalsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            journalsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            journalsButton.heightAnchor.constraint(equalToConstant: 30),
            favrCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            favrCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            favrCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            favrCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favrCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach{ $0.isActive = true}
        
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
        
        startListeningForFavrs()
        favrCollectionView.reloadData()
        
        // Favr Label Reload
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favrsReload))
        favrsLabel.addGestureRecognizer(gesture)
    }
    
    @objc private func favrsReload() {
        progressBar.alpha = 1
        startListeningForFavrs()
        favrCollectionView?.reloadData()
    }
    
    private func startListeningForFavrs() {
        
        print("starting favrs download...")
        self.progressBar.setProgress(0.3, animated: true)
        
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.medium
//        loadingIndicator.startAnimating()
        
//        loadingAlert.view.addSubview(loadingIndicator)
//        present(loadingAlert, animated: true, completion: nil)

        
        DatabaseManager.shared.getAllFavrs(completion: { [weak self] result in
            self?.progressBar.setProgress(0.7, animated: true)
            switch result {
            case .success(let favrs):
                print("successfully got favrs")
                self?.progressBar.setProgress(1.0, animated: true)
                self?.progressBar.fadeOut()
//                DispatchQueue.main.async {
//                    self?.loadingAlert.dismiss(animated: false, completion: nil)
//                    self?.loadingIndicator.stopAnimating()
//                }
                self?.favrCollectionView?.fadeIn()

                guard !favrs.isEmpty else {
                    self?.progressBar.setProgress(1.0, animated: true)
                    self?.favrCollectionView?.isHidden = true
                    self?.noFavrsLabel.isHidden = false
                    return
                }
                self?.noFavrsLabel.isHidden = true
                self?.favrCollectionView?.isHidden = false
                self?.favrs = favrs

                DispatchQueue.main.async {
                    self?.favrCollectionView?.reloadData()
                }
            case.failure(let error):
                self?.progressBar.setProgress(0, animated: true)
                self?.noFavrsLabel.isHidden = false
                let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self?.present(alert, animated: true)
                // Network error image/animation
                self?.startAnimation()
                self?.animationView.isHidden = false
                print("failed to get favrs: \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        singleView.frame = CGRect(x: 10,
                                  y: searchButton.bottom+10,
                                  width: view.width-20,
                                  height: 1)
        progressBar.frame = singleView.frame
        favrsLabel.frame = CGRect(x: 10,
                                  y: view.safeAreaInsets.top+18,
                                  width: favrsLabel.intrinsicContentSize.width,
                                  height: 40)
        searchButton.frame = CGRect(x: view.width-90,
                                  y: 120,
                                  width: 50,
                                  height: 50)
        searchButton.layer.cornerRadius = searchButton.frame.size.width / 2
        searchButton.center.y = favrsLabel.center.y
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        spinner.dismiss()
        navigationController?.setNavigationBarHidden(true, animated: false)
        validateVerification()
        
        // MARK: Onboarding
        
        let person = Auth.auth().currentUser
        
        let reference = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: person?.email ?? "email"))
            
            reference.child("onboardingComplete").observeSingleEvent(of: .value, with: {
                snapshot in
                let onboardingStatus = snapshot.value as? String
                
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
            let ref = Database.database().reference().child("Users").child(safeEmail)
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
            nav.modalPresentationStyle = .pageSheet
            self.present (nav, animated: true)
            let person = Auth.auth().currentUser
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
            let ref = Database.database().reference().child("Users").child(safeEmail)
            guard let key = ref.child("onboardingComplete").key else { return }
            
            let childUpdates = ["\(key)": "true",
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
            print("Success: Did remove pop up window")
        }
    }

}

extension DeedsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = favrs[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favrsCollectionViewCell.identifier, for: indexPath) as! favrsCollectionViewCell
        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DeedsFirstViewController()
        vc.deedTitle = favrs[indexPath.row].title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DeedsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = self.favrCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpace = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpace
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthWithSpace - scrollView.contentInset.left, y: scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
}
