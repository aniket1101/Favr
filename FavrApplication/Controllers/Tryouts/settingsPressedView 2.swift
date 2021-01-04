//
//  settingsPressedView.swift
//  Favr
//
//  Created by Aniket Gupta on 26/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

class settingsPressedView: UIView {
    
    private let table: UITableView = {
        let table = UITableView()
        return table
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        table.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
