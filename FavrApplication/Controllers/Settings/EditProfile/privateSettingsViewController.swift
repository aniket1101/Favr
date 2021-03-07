//
//  privateSettingsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 10/11/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import Firebase

struct privateSettingsCellModel {
    let title: String
    let handler: (() -> Void)
}

class privateSettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[privateSettingsCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Private Settings"
        
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "FavrOrange")
        
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
//            privateSettingsCellModel(title: "Email") { [weak self] in
//                let vc = ChangeEmailViewController()
//                self?.navigationController?.pushViewController(vc, animated: true)
//            },
            privateSettingsCellModel(title: "Change Password") { [weak self] in
                let vc = currentPasswordViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ])
    }
}

extension privateSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.textLabel?.textColor = .label
        cell.imageView?.tintColor = .secondaryLabel
        if cell.textLabel?.text == "Email" {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child("Users").child(safeEmail)
            ref.child("email").observe(.value, with: {
                snapshot in
                let newInfo = snapshot.value as? String
                cell.detailTextLabel?.text = newInfo
            })
            cell.imageView?.image = UIImage(systemName: "envelope.fill")
        }
        else if cell.textLabel?.text == "Password" {
            cell.imageView?.image = UIImage(systemName: "eye.slash.fill")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
