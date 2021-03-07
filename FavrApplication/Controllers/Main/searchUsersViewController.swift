//
//  NewConversationViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

final class searchUsersViewController: UIViewController {
    
    public var completion: ((SearchResult) -> (Void))?
    
    private let spinner: JGProgressHUD = {
        let spinner = JGProgressHUD(style: .dark)
        spinner.square = true
        spinner.cornerRadius = 12
        return spinner
    }()

    
    private var users = [[String: String]]()
    
    private var results = [SearchResult]()
    
    private var hasFetched = false

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search for Email"
        searchBar.backgroundColor = .systemBackground
        searchBar.keyboardType = .emailAddress
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.register(NewConversationCell.self,
                       forCellReuseIdentifier: NewConversationCell.identifier)
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width / 4,
                                      y: (view.height-200) / 2,
                                      width: view.width / 2,
                                      height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension searchUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationCell.identifier,
                                                 for: indexPath) as! NewConversationCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Start conversation
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension searchUsersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        spinner.show(in: view)
        
        searchUsers(query: text)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        // Check is array has Firebase results
        if hasFetched {
            // If Firebase results are present, filer
            filterUsers(with: query)
        }
        else {
            // If firebase results are not present, fetch them and then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result{
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
            
        }
    }
    func filterUsers(with term: String) {
        // Update the UI; Show results or show "No results" UILabel
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        spinner.dismiss()
        
        let results: [SearchResult] = users.filter({
            guard let email = $0["email"], email != currentUserEmail else {
                return false
            }

            return email.hasPrefix(term.lowercased())
        }).compactMap({
            
            guard let email = $0["email"] else {
                return nil
            }
            
            return SearchResult(email: email)
        })
        
        self.results = results
        
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            noResultsLabel.isHidden = false
            tableView.isHidden  = true
        }
        else {
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
}
