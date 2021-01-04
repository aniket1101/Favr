//
//  Onboarding.swift
//  Favr
//
//  Created by Aniket Gupta on 01/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

//import UIKit
//import paper_onboarding
//
//class Onboarding: UIViewController {
//
////    @IBOutlet var skipButton: UIButton!
//
//    fileprivate let items = [
//        OnboardingItemInfo(informationImage: UIImage(named: "Warning")!,
//                           title: "title",
//                           description: "description",
//                           pageIcon: UIImage(named: "LaunchScreenLogo")!,
//                           color: UIColor.blue,
//                           titleColor: UIColor.white,
//                           descriptionColor: UIColor.white,
//                           titleFont: UIFont.systemFont(ofSize: 20),
//                           descriptionFont: UIFont.systemFont(ofSize: 12)),
//
//        OnboardingItemInfo(informationImage: UIImage(named: "Warning")!,
//                           title: "title",
//                           description: "description",
//                           pageIcon: UIImage(named: "LaunchScreenLogo")!,
//                           color: UIColor.blue,
//                           titleColor: UIColor.white,
//                           descriptionColor: UIColor.white,
//                           titleFont: UIFont.systemFont(ofSize: 20),
//                           descriptionFont: UIFont.systemFont(ofSize: 12)),
//
//        OnboardingItemInfo(informationImage: UIImage(named: "Warning")!,
//                           title: "title",
//                           description: "description",
//                           pageIcon: UIImage(named: "LaunchScreenLogo")!,
//                           color: UIColor.blue,
//                           titleColor: UIColor.white,
//                           descriptionColor: UIColor.white,
//                           titleFont: UIFont.systemFont(ofSize: 20),
//                           descriptionFont: UIFont.systemFont(ofSize: 12)),
//
//    ]
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        skipButton.isHidden = true
//
//        setupPaperOnboardingView()
//
////        view.bringSubviewToFront(skipButton)
//    }
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
//// MARK: Actions
//
//extension Onboarding {
//
//    @IBAction func skipButtonTapped(_: UIButton) {
//        print(#function)
//    }
//}
//
//// MARK: PaperOnboardingDelegate
//
//extension Onboarding: PaperOnboardingDelegate {
//
//    func onboardingWillTransitonToIndex(_ index: Int) {
////        skipButton.isHidden = index == 2 ? false : true
//    }
//
//    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
//
//    }
//}
//
//// MARK: PaperOnboardingDataSource
//
//extension Onboarding: PaperOnboardingDataSource {
//
//    func onboardingItem(at index: Int) -> OnboardingItemInfo {
//        return items[index]
//    }
//
//    func onboardingItemsCount() -> Int {
//        return 3
//    }
//}
//
//
////MARK: Constants
////private extension Onboarding {
////
////    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
////    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
////}
//
