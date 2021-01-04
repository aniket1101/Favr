//
//  DetailedAccountViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 21/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

//import UIKit
//
//struct DetailedProfileCellModel {
//    let title: String
//    let handler: (() -> Void)
//
//}
//
//final class DetailedAccountViewController: UIViewController {
//
//    private let tableView: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()
//
//    private var data = [[DetailedProfileCellModel]]()
//
//    @objc private func changeNamePressed() {
//        let vc = ChangeNameViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc private func changeStatusPressed() {
//        let vc = ChangeStatusViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc private func changeProfilePicturePressed() {
//        let vc = ChangeProfilePictureViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        self.title = "Account"
//        navigationItem.largeTitleDisplayMode = .never
//
//        configureModels()
//
//        // Subviews
//        view.addSubview(tableView)
//
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//
//    private func configureModels() {
//        data.append([
//            DetailedProfileCellModel(title: "Change Username") { [weak self] in
//                self?.ch()
//            },
//            DetailedProfileCellModel(title: "Change Profile Picture") { [weak self] in
//                self?.changeProfilePicturePressed()
//            }
//        ])
//        data.append([
//        DetailedProfileCellModel(title: "Change Status") { [weak self] in
//            self?.changeStatusPressed()
//        }
//        ])
//    }
//}
//
//extension DetailedAccountViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Handle cell selection
//        data[indexPath.section][indexPath.row].handler()
//    }
//}
