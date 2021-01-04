//
//  AboutViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 25/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import SafariServices
import Lottie

struct AboutCellModel {
    let title: String
    let handler: (() -> Void)
    
}

final class AboutViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var data = [[AboutCellModel]]()
    
    @objc private func presentTerms() {
        guard let url = URL(string: "https://favrapp.weebly.com/terms-and-conditions.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Terms and Conditions"
        present(vc, animated: true, completion: {self.selectAboutView()})
    }
    
    @objc private func presentPrivacy() {
        guard let url = URL(string: "https://favrapp.weebly.com/privacy-policy.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "Privacy Policy"
        present(vc, animated: true, completion: {self.selectAboutView()})
    }
    
    @objc private func presentLicenses() {
//        guard let url = URL(string: "https://favrapp.weebly.com/licenses.html") else {
//            return
//        }
//        let vc = SFSafariViewController(url: url)
//        vc.title = "Licenses"
//        present(vc, animated: true, completion: {self.selectAboutView()})
    }
    
    @objc private func presentContactUs() {
        self.navigationController?.pushViewController(ContactUsViewController(), animated: true)
    }
    
    @objc private func presentAcknowledgements() {
        self.navigationController?.pushViewController(AdditionalLicensesViewController(), animated: true)
    }
    
    func selectAboutView(){
        present(AboutViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false

        view.backgroundColor = .systemGroupedBackground
        self.title = "About"
        navigationItem.largeTitleDisplayMode = .never
        tableView.isScrollEnabled = false
        
        configureModels()
        
        // Subviews
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    func createTableHeader() -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: view.height/3.25))
        
        headerView.backgroundColor = tableView.backgroundColor
        
        let imageView = UIImageView(frame: CGRect(x: 20,
                                                  y: 84,
                                                  width: view.width-40,
                                                  height: view.height/4))
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.image = UIImage(named: "ContactUs")
        view.addSubview(imageView)
        
        return headerView

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func configureModels() {
        data.append([
            AboutCellModel(title: "Contact Us") { [weak self] in
                self?.presentContactUs()
            }
        ])
        data.append([
            AboutCellModel(title: "Terms and Conditions") { [weak self] in
                self?.presentTerms()
            },
            AboutCellModel(title: "Privacy Policy") { [weak self] in
                self?.presentPrivacy()
            }
        ])
        data.append([
            AboutCellModel(title: "Licenses") { [weak self] in
                self?.presentLicenses()
            },
            AboutCellModel(title: "Other Acknowlegements") { [weak self] in
                self?.presentAcknowledgements()
            }
        ])
    }
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
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

