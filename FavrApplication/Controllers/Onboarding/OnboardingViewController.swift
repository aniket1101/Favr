//
//  OnboardingViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 02/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import NotificationCenter
import liquid_swipe

//class OnboardingViewController: UIViewController {
//
//override func viewDidLoad() {
//        let host = UIHostingController(rootView: OnboardingContentView())
//        guard let hostView = host.view else { return }
//
//        hostView.translatesAutoresizingMaskIntoConstraints = true
//        hostView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
//        navigationController?.navigationBar.isHidden = true
//        tabBarController?.tabBar.isHidden = true
//        view.addSubview(hostView)
//
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("dismissSwiftUI"), object: nil, queue: nil) { (_) in
//            self.navigationController?.dismiss(animated: true, completion: nil)
//        }
//    }
//
//}

// MARK: - Third-party Alternative (Paper_Onboarding)

//class OnboardingViewController: UIViewController {
//
//fileprivate let items = [
//    OnboardingItemInfo(informationImage: UIImage(named: "OnboardingLogo")!,
//                                  title: "Welcome to Favr",
//                            description: "Start being a better you",
//                            pageIcon: UIImage(systemName: "1.circle")!,
//                                  color: UIColor(named: "FavrOnboardingOrange")!,
//                             titleColor: UIColor(named: "FavrLightShade")!,
//                       descriptionColor: UIColor(named: "FavrLightShade")!,
//                              titleFont: UIFont.systemFont(ofSize: 40),
//                              descriptionFont: UIFont.systemFont(ofSize: 20)),
//
//    OnboardingItemInfo(informationImage: UIImage(named: "OnboardingDeeds")!,
//                                   title: "Favrs",
//                             description: "Complete good deeds every day to earn points",
//                             pageIcon: UIImage(systemName: "2.circle")!,
//                             color: UIColor(named: "FavrLightShade")!,
//                              titleColor: UIColor(named: "FavrOnboardingOrange")!,
//                        descriptionColor: UIColor(named: "FavrOnboardingOrange")!,
//                               titleFont: UIFont.systemFont(ofSize: 40),
//                         descriptionFont: UIFont.systemFont(ofSize: 20)),
//
//    OnboardingItemInfo(informationImage: UIImage(named: "OnboardingChats")!,
//                                title: "Chat",
//                          description: "Exchange news with your friends",
//                          pageIcon: UIImage(systemName: "3.circle")!,
//                                color: UIColor(named: "FavrOnboardingOrange")!,
//                           titleColor: UIColor(named: "FavrLightShade")!,
//                     descriptionColor: UIColor(named: "FavrLightShade")!,
//                            titleFont: UIFont.systemFont(ofSize: 40),
//                      descriptionFont: UIFont.systemFont(ofSize: 20))
//]
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    navigationController?.navigationBar.isHidden = true
//    setupPaperOnboardingView()
//}
//
//
//    private func setupPaperOnboardingView() {
//        let onboarding = PaperOnboarding()
//        onboarding.delegate = self
//        onboarding.dataSource = self
//        onboarding.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(onboarding)
//
//        // Add constraints
//        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
//            let constraint = NSLayoutConstraint(item: onboarding,
//                                                attribute: attribute,
//                                                relatedBy: .equal,
//                                                toItem: view,
//                                                attribute: attribute,
//                                                multiplier: 1,
//                                                constant: 0)
//            view.addConstraint(constraint)
//        }
//    }
//}
//
//extension OnboardingViewController: PaperOnboardingDataSource {
//
//    func onboardingItem(at index: Int) -> OnboardingItemInfo {
//        return items[index]
//    }
//
//    func onboardingItemsCount() -> Int {
//        return 3
//    }
//
//        func onboardinPageItemRadius() -> CGFloat {
//            return 2
//        }
//
//        func onboardingPageItemSelectedRadius() -> CGFloat {
//            return 10
//        }
//        func onboardingPageItemColor(at index: Int) -> UIColor {
//            return [UIColor.white, UIColor.red, UIColor.green][index]
//        }
//}

// MARK: - Third Party Alternative (Liquid-Swipe)

class ColoredController: UIViewController {
    var viewColor: UIColor = .white {
        didSet {
            viewIfLoaded?.backgroundColor = viewColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColor
    }
}

class OnboardingViewController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    var viewControllers: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page1")
        let secondPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page2")
        let thirdPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page3")
        let fourthPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page4")
        let lastVC = DeedsViewController()
        var controllers: [UIViewController] = [firstPageVC, secondPageVC, thirdPageVC, fourthPageVC, lastVC]
        return controllers
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        datasource = self
    }

    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return viewControllers.count
    }

    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
}
