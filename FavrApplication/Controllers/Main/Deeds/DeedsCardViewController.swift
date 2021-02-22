//
//  DeedsCardViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 02/02/2021.
//

import UIKit
import Firebase
import Hero
import NotificationCenter
import ShimmerSwift

class DeedsCardViewController: UIViewController {
        
    private let buttonConstant: CGFloat = 70
    
    private let labelShimmerView: ShimmeringView = {
        let view = ShimmeringView()
        view.shimmerSpeed = 150
        view.shimmerDirection = .right
        return view
    }()
    
    let deedLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor(named: "FavrOrange")
//        label.textColor = UIColor(named: "Accent")
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        return label
    }()
    
    let pointLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        return label
    }()
    
    let deedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.sizeToFit()
        return label
    }()
    
    let deedCompletedButton: UIButton = {
        let button = UIButton()
//        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(deedCompletedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let favrButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.setImage(UIImage(named: "whiteLogo"), for: .normal)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 100
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(favrButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func deedCompletedButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("deedCompleted"), object: nil)
    }
    
    @objc private func favrButtonTapped() {
        let vc = DeedsDetailedViewController()
        vc.deedTitle = deedLabel.text ?? "Error"
        vc.deedLabel.heroID = "deedLabel"
        vc.deedDescriptionLabel.heroID = "descriptionLabel"
        vc.imageView.heroID = "imageView"
        vc.favrButton.heroID = "favrButton"
        vc.backButton.heroID = "favrBackButton"
        self.showHero(vc)
    }
    
    @IBOutlet weak var handleArea: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelShimmerView.contentView = deedLabel
        labelShimmerView.isShimmering = true
                
        self.deedLabel.heroID = "deedLabel"
        self.favrButton.heroID = "favrButton"
        self.deedDescriptionLabel.heroID = "descriptionLabel"

        view.addSubview(deedLabel)
        view.addSubview(deedDescriptionLabel)
        view.addSubview(favrButton)
        view.addSubview(deedCompletedButton)
        view.addSubview(pointLabel)
        
        deedLabel.fadeIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        deedLabel.frame = CGRect(x: view.width-(size-buttonConstant)-20,
                                  y: 20,
                                  width: (2*size)+10,
                                  height: 25)
        labelShimmerView.frame = CGRect(x: 100,
                                        y: 100,
                                        width: (2*size)+10,
                                        height: 65)
//        deedLabel.frame = CGRect(x: 20,
//                                  y: 20,
//                                  width: (2*size)+10,
//                                  height: 25)
        favrButton.frame = CGRect(x: view.width-(size-buttonConstant)-20,
                                  y: 5,
                                  width: size-buttonConstant,
                                  height: size-buttonConstant)
        favrButton.layer.cornerRadius = favrButton.frame.size.width/2
        pointLabel.frame = CGRect(x: 20,
                                  y: handleArea.bottom+5,
                                  width: view.width-40,
                                  height: 20)
        deedDescriptionLabel.frame = CGRect(x: 10,
                                            y: pointLabel.bottom+15,
                                            width: view.width-20,
                                            height: 80)
        deedCompletedButton.frame = CGRect(x: (2*size)-10,
                                          y: deedDescriptionLabel.bottom+5,
                                          width: 100,
                                          height: 25)
    }
    
}
