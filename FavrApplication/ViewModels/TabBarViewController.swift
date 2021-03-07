//
//  TabBarViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 06/03/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = DeedsViewController()
        let vc2 = ProfileViewController()
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        nav1.navigationBar.isHidden = true
        nav2.navigationBar.isHidden = true
//
//        nav1.navigationItem.largeTitleDisplayMode = .never
//        nav2.navigationItem.largeTitleDisplayMode = .never
//
//        nav1.navigationBar.prefersLargeTitles = false
//        nav2.navigationBar.prefersLargeTitles = false

        vc1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([vc1, vc2], animated: false)
    }
    
}
