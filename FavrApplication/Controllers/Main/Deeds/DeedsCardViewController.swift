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
import MarqueeLabel

class DeedsCardViewController: UIViewController {
        
    private let buttonConstant: CGFloat = 70
    private let handleAreaConstant: CGFloat = 20
    
    private let labelShimmerView: ShimmeringView = {
        let view = ShimmeringView()
        view.shimmerSpeed = 150
        view.shimmerDirection = .right
        return view
    }()
    
    let deedLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textColor = .label
        label.textAlignment = .left
        label.type = .rightLeft
        label.animationCurve = .easeInOut
        label.speed = .duration(1.5)
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
    @IBOutlet var handleBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelShimmerView.contentView = pointLabel
        labelShimmerView.isShimmering = true
                
        self.deedLabel.heroID = "deedLabel"
        self.favrButton.heroID = "favrButton"
        self.deedDescriptionLabel.heroID = "descriptionLabel"

        handleArea.addSubview(deedLabel)
        view.addSubview(deedDescriptionLabel)
        handleArea.addSubview(favrButton)
        view.addSubview(deedCompletedButton)
        view.addSubview(pointLabel)
        
//        deedLabel.rightAnchor.constraint(equalTo: favrButton.leftAnchor).isActive = true
        deedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        deedLabel.fadeIn()
        pointLabel.fadeIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        labelShimmerView.frame = CGRect(x: 100,
                                        y: 100,
                                        width: (2*size)+10,
                                        height: 20)
                deedLabel.frame = CGRect(x: 20,
                                          y: 20,
                                          width: (2*size)+10,
                                          height: 25)
        favrButton.frame = CGRect(x: view.width-(size-buttonConstant)-20,
                                  y: 25,
                                  width: handleArea.bottom-10,
                                  height: handleArea.bottom-10)
        favrButton.layer.cornerRadius = favrButton.frame.size.width/2
        deedLabel.center.y = favrButton.center.y
        pointLabel.frame = CGRect(x: 20,
                                  y: deedLabel.bottom+5,
                                  width: view.width-40,
                                  height: 20)
        deedDescriptionLabel.frame = CGRect(x: 20,
                                            y: pointLabel.bottom+15,
                                            width: view.width-40,
                                            height: 80)
        deedCompletedButton.frame = CGRect(x: (2*size)-10,
                                           y: deedDescriptionLabel.bottom+5,
                                           width: 100,
                                           height: 25)
        
    }
    
}
