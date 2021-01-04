//
//  pageOneOnboardingViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 03/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase
import NotificationCenter

class pageTwoOnboardingViewController: UIViewController {
    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "OnboardingLogo")
//        imageView.tintColor = .clear
//        imageView.layer.cornerRadius = imageView.width / 2.0
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.masksToBounds = false
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    private let welcomeLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Online"
//        label.textColor = UIColor(named: "LightAccent")
//        label.font = .systemFont(ofSize: 47, weight: .regular)
//        return label
//    }()
//
//    private let FavrLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Chats"
//        label.textColor = .white
//        label.font = UIFont(name: "DINCondensed-Bold", size: 75)
//        return label
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Start being a better you"
//        label.textColor = UIColor(named: "FavrLightShade")
//        label.font = .systemFont(ofSize: 28, weight: .medium)
//        return label
//    }()
//
//    let skipButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("skip", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
//        button.setTitleColor(UIColor(named: "Accent"), for: .normal)
//        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    @objc private func skipButtonTapped() {
//        let person = Auth.auth().currentUser
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
//        let ref = Database.database().reference().child(safeEmail)
//        guard let key = ref.child("onboardingComplete").key else { return }
//
//        let childUpdates = ["\(key)": "true",
//        ]
//        ref.updateChildValues(childUpdates as [AnyHashable : Any])
//        dismiss(animated: true, completion: nil)
//    }
//
//    private let pageControl: UIPageControl = {
//        let control = UIPageControl()
//        control.numberOfPages = 4
//        control.currentPage = 0
//        return control
//    }()
//
//
//
//
    @IBAction func skipPressed(_ sender: UIButton) {
        let person = Auth.auth().currentUser
        let safeEmail = DatabaseManager.safeEmail(emailAddress: (person?.email)!)
        let ref = Database.database().reference().child(safeEmail)
        guard let key = ref.child("onboardingComplete").key else { return }
        
        let childUpdates = ["\(key)": "true",
        ]
        ref.updateChildValues(childUpdates as [AnyHashable : Any])
        
        NotificationCenter.default.post(name: NSNotification.Name("dismissOnboarding"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "FavrOrange")
//        view.addSubview(imageView)
//        view.addSubview(welcomeLabel)
//        view.addSubview(FavrLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(pageControl)
//        view.addSubview(skipButton)
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        imageView.frame = CGRect(x: 104.5,
//                                 y: 106,
//                                 width: 200,
//                                 height: 223)
//        welcomeLabel.frame = CGRect(x: 42,
//                                    y: 537,
//                                    width: 237,
//                                    height: 57)
//        FavrLabel.frame = CGRect(x: 65,
//                                 y: 601.5,
//                                 width: 103,
//                                 height: 75)
//        descriptionLabel.frame = CGRect(x: 42,
//                                        y: 704,
//                                        width: 289.5,
//                                        height: 72)
//        pageControl.frame = CGRect(x: 42,
//                                   y: 825,
//                                   width: 55,
//                                   height: 37)
//        skipButton.frame = CGRect(x: view.width-50,
//                                  y: 50,
//                                  width: 40,
//                                  height: 40)
//    }

}
