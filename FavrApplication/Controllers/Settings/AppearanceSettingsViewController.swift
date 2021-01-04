//
//  AppearanceSettingsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 24/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

struct AppearanceSettingsCellModel {
    let title: String
    let handler: (() -> Void)
    
}

final class AppearanceSettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[AppearanceSettingsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Appearance"
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
            AppearanceSettingsCellModel(title: "Change Appearance") { [weak self] in
                
            }
        ])
    }

}

extension AppearanceSettingsViewController: UITableViewDelegate, UITableViewDataSource {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
