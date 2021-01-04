//
//  AccountSettingsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage
import SafariServices
import SwiftEntryKit
import NotificationCenter

struct AccountSettingsCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View controller to show the Account Settings for a given user
final class AccountSettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[AccountSettingsCellModel]]()
    
    @objc private func accountEmailButtonPressed() {
        self.navigationController?.pushViewController(ChangeEmailViewController(), animated: true)
    }
    
    @objc private func deleteAccountPressed() {
        let vc = DeleteAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc private func detailedAccountPressed() {
//        let vc = DetailedAccountViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    func setUpLogOutAttributes() -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 25)
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.displayMode = .inferred
        attributes.entryBackground = .visualEffect(style: .standard)
        attributes.statusBar = .dark
        attributes.precedence = .enqueue(priority: .normal)
        attributes.screenBackground = .visualEffect(style: .dark)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.positionConstraints.verticalOffset = 10
        return attributes
    }
    
    /// Attempt to log out user
    @objc func logOut() {
        SwiftEntryKit.display(entry: logOutView(), using: setUpLogOutAttributes())
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("logOut"), object: nil, queue: nil) { (_) in
            SwiftEntryKit.dismiss()
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present (nav, animated: true) {
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: false)
                }
        }
    }
    
    @objc private func presentTerms() {
        guard let url = URL(string: "https://favrapp.weebly.com/terms-and-conditions.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Terms and Conditions"
        present(vc, animated: true, completion: {self.selectAccountSettingsView()})
    }
    
    @objc private func presentPrivacy() {
        guard let url = URL(string: "https://favrapp.weebly.com/privacy-policy.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Privacy Policy"
        present(vc, animated: true, completion: {self.selectAccountSettingsView()})
    }
    
    func selectAccountSettingsView(){
        present(AccountSettingsViewController(), animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Account"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false

        
        configureModels()
        
        // Subviews
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    private func configureModels() {
        data.append([
//            AccountSettingsCellModel(title: "Change Email") { [weak self] in
//                self?.accountEmailButtonPressed()
//            },
            AccountSettingsCellModel(title: "Push UserVerification") { [weak self] in
                let vc = UserVerificationViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present (nav, animated: false)
            },
            AccountSettingsCellModel(title: "Push Onboarding") { [weak self] in
                let vc = OnboardingViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present (nav, animated: false)
            },
            AccountSettingsCellModel(title: "Push Forgot Password") { [weak self] in
                let vc = ForgotPasswordViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present (nav, animated: false)
            },
            AccountSettingsCellModel(title: "Push Registration") { [weak self] in
                let vc = RegisterViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present (nav, animated: false)
            },
            AccountSettingsCellModel(title: "Delete Account") { [weak self] in
                self?.deleteAccountPressed()
            }
        ])
        data.append([
            AccountSettingsCellModel(title: "Log Out") { [weak self] in
                self?.logOut()
            }
        ])
    }
    
}

extension AccountSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        if cell.textLabel?.text == "Log Out" {
            cell.textLabel?.text = data[indexPath.section][indexPath.row].title
            cell.accessoryType = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
