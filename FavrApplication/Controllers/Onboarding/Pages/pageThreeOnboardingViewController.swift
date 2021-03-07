//
//  pageThreeOnboardingViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 03/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

class pageThreeOnboardingViewController: UIViewController {
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()

    @objc func dismissSelf() {
        print("trying to dismiss")
        dismiss(animated: true, completion: nil)
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(dismissButton)
            dismissButton.frame = CGRect(x: 100,
                                         y: 200,
                                         width: 100, height: 50)
        }
    }
