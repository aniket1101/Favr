//
//  DataHomeViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 19/02/2021.
//

import UIKit

class DataHomeViewController: UIViewController {
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.textColor = .systemFill
        label.font = UIFont(name: "Monstserrat-Regular", size: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(loadingLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingLabel.center = view.center
    }
    
}
