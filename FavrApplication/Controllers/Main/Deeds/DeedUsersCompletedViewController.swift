//
//  DeedUsersCompletedViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 03/02/2021.
//

import UIKit

class DeedUsersCompletedViewController: UIViewController {
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.text = "These people completed this Favr"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.add(gesture: .tap(1)) {
            self.dismiss(animated: true, completion: nil)
        }
        
        view.addSubview(completedLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        completedLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: view.width-20,
                                      height: 25)
        completedLabel.center = view.center
    }
 
}
