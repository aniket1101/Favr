//
//  detailPressedView.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 07/03/2021.
//

import UIKit
import SwiftEntryKit

class detailPressedView: UIView {
    
    private let favrsLabel: UILabel = {
        let label = UILabel()
        label.text = "Favrs"
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Monstserrat-Bold", size: 6)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favrsNumberButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Bold", size: 10)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Monstserrat-Bold", size: 6)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("999", for: .normal)
        button.addTarget(self, action: #selector(followersNumberButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Bold", size: 10)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    @objc private func followersNumberButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("followersNumberButtonTapped"), object: nil)
    }
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Monstserrat-Bold", size: 6)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("999", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.addTarget(self, action: #selector(followersNumberButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Monstserrat-Bold", size: 10)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    @objc private func followingNumberButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("followingNumberButtonTapped"), object: nil)
    }
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Accent")
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func dismissSelf() {
        SwiftEntryKit.dismiss()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // View Setup
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        clipsToBounds = true
        backgroundColor = UIColor(named: "FavrOrange")
        clipsToBounds = true
        layer.cornerRadius = 25
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        lineView.addGestureRecognizer(gesture)
        
        
        // Subviews
        addSubview(favrsLabel)
        addSubview(favrsNumberButton)
        addSubview(followersLabel)
        addSubview(followersNumberButton)
        addSubview(followingLabel)
        addSubview(followingNumberButton)
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelWidth = (width)/3
        favrsLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: labelWidth,
                                  height: 20)
        favrsLabel.center.y = center.y
        followersLabel.frame = CGRect(x: favrsLabel.right,
                                      y: 0,
                                      width: labelWidth,
                                      height: 20)
        followersLabel.center.y = favrsLabel.center.y
        followersLabel.center.x = center.x
        followingLabel.frame = CGRect(x: followersLabel.right,
                                      y: 0,
                                      width: labelWidth,
                                      height: 20)
        followingLabel.center.y = favrsLabel.center.y
        lineView.frame = CGRect(x: 0,
                                y: 5,
                                width: 80,
                                height: 4)
        lineView.center.x = followersLabel.center.x
        
        // Buttons
        favrsNumberButton.frame = CGRect(x: 0,
                                         y: favrsLabel.top-30,
                                         width: labelWidth,
                                         height: 20)
        favrsNumberButton.center.x = favrsLabel.center.x
        followersNumberButton.frame = CGRect(x: 0,
                                             y: 0,
                                             width: labelWidth,
                                             height: 20)
        followersNumberButton.center.x = followersLabel.center.x
        followersNumberButton.center.y = favrsNumberButton.center.y
        followingNumberButton.frame = CGRect(x: 0,
                                             y: 0,
                                             width: labelWidth,
                                             height: 20)
        followingNumberButton.center.x = followingLabel.center.x
        followingNumberButton.center.y = favrsNumberButton.center.y

        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
