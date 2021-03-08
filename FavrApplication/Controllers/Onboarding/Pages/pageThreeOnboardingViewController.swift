//
//  pageThreeOnboardingViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 03/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

class pageThreeOnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: NSNotification.Name("onboardingCompleted"), object: nil)
        
    }
}
