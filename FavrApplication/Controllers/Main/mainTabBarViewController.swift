//
//  mainTabBarViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 28/10/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import AMTabView

class mainTabBarViewController: AMTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabsControllers()
    }
    

    private func setTabsControllers() {
        let firstViewController = DeedsViewController()
        let secondViewController = RankingsViewController()
        let thirdViewController = ConversationsViewController()
        let fourthViewController = ProfileViewController()
        
        viewControllers = [
            firstViewController,
            secondViewController,
            thirdViewController,
            fourthViewController
        ]
      }

}
