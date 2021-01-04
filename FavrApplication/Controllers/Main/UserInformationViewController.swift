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

struct UserInformationCellModel {
    let title: String
    let handler: (() -> Void)
    
}

class UserInformationViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[UserInformationCellModel]]()
    
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
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.backgroundColor = .systemBackground
        userNameLabel.textColor = .label
        userNameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        return userNameLabel
    }()
    
    private func doNothing() {
        
    }
    
    private func showMailComposer() {
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
        tableView.reloadData()
        view.backgroundColor = .systemBackground
        scrollView.isScrollEnabled = true
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        // Download Other User's Profile Picture
        let path = "images/\(safeEmail ?? "email")_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                self?.otherUserPhotoURL = url
                DispatchQueue.main.async {
                    self?.imageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print("\(error)")
            }
        })
        
        configureModels()
        
        // Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isUserInteractionEnabled = false
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        scrollView.frame = view.bounds
//        imageView.frame = CGRect(x: 0,
//                                 y: 0,
//                                 width: view.width,
//                                 height: 400)
        tableView.frame = CGRect(x: 0,
                                 y: imageView.bottom,
                                 width: view.width,
                                 height: 400)
    }
    
    private func configureModels() {
        let userNameLabel = "@"+otherUserUsername!+" ("+otherUserName!+")"
        data.append([
            UserInformationCellModel(title: userNameLabel) { [weak self] in
                self?.doNothing()
            },
            UserInformationCellModel(title: otherUserStatus ?? "Status not available") { [weak self] in
                self?.doNothing()
            }
        ])
        data.append([
            UserInformationCellModel(title: otherUserEmail ?? "User email not available") { [weak self] in
                self?.showMailComposer()
            }
        ])
    }
}

extension UserInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .none
        if cell.textLabel?.text == otherUserName {
            cell.textLabel?.text = data[indexPath.section][indexPath.row].title
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        }
        if cell.textLabel?.text == otherUserStatus {
            cell.textLabel?.text = data[indexPath.section][indexPath.row].title
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .thin)
        }
        if cell.textLabel?.text == otherUserEmail {
            cell.imageView?.image = UIImage(systemName: "envelope.fill")
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
