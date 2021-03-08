//
//  RankingsViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 16/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController {
    
    //    private let tableView: UITableView = {
    //        let table = UITableView()
    //        table.isHidden = true
    //        table.backgroundColor = .systemGroupedBackground
    //        table.automaticallyAdjustsScrollIndicatorInsets = false
    //        table.clipsToBounds = true
    //        table.register(ConversationTableViewCell.self,
    //                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
    //        return table
    //    }()
    
    private let rankingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Rankings"
        label.font = UIFont(name: "Montserrat-Bold", size: 22)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = -1
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground

        
        view.addSubview(dismissButton)
        view.addSubview(rankingsLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dismissButton.frame = CGRect(x: view.width-60,
                                     y: 40,
                                     width: 30,
                                     height: 30)
        rankingsLabel.frame = CGRect(x: 0,
                                    y: dismissButton.bottom+5,
                                    width: view.width,
                                    height: 30)
        
    }
    
}
