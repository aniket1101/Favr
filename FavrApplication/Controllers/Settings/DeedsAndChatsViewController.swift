//
//  DeedsAndChatsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 29/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

struct DeedsAndChatsCellModel {
    let title: String
    let handler: (() -> Void)
    
}

class DeedsAndChatsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[DeedsAndChatsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Deeds and Chats"
        navigationItem.largeTitleDisplayMode = .never
        
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
            DeedsAndChatsCellModel(title: "MM/DD/YYYY Date Style") { [weak self] in
                self?.navigationController?.pushViewController(ProfileViewController(), animated: true)
            }
        ])
    }

}

extension DeedsAndChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    @objc private func switchDidChange(_ sender: UISwitch) {
        ChatViewController.dateFormatter.dateFormat = "MM/dd/yy"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        if cell.textLabel?.text == "MM/DD/YYYY Date Style" {
            let switchButton:UISwitch = {
                let switchButton = UISwitch(frame: .zero)
                switchButton.setOn(false, animated: true)
                switchButton.tag = indexPath.row
                switchButton.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
                return switchButton
            }()
            cell.textLabel?.text = data[indexPath.section][indexPath.row].title
            cell.isUserInteractionEnabled = true
            cell.accessoryView = switchButton
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
