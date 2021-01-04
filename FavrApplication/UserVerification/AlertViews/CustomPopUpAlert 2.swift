//
//  CustomPopUpAlert.swift
//  Favr
//
//  Created by Aniket Gupta on 21/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit

protocol popUpDelegate {
    func handleDismissal()
    func handleSuccess()
}

class CustomPopUpAlert: UIView {

    // MARK: - Properties
    
    var popUpAlertDelegate: popUpDelegate?
    
    @objc private func handleDismissal() {
        popUpAlertDelegate?.handleDismissal()
    }
    
    @objc private func handleSuccess() {
        popUpAlertDelegate?.handleSuccess()
    }
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 90)
//        label.textColor = UIColor(red: 147/255, green: 227/255, blue: 105/255, alpha: 1)
        label.text = "👋"
        return label
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 16)
        label.textColor = UIColor(named: "FavrOnboardingOrange")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text =
        """
        Welcome to Favr!
        Do you want to see what you can do?
        """
        return label
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yeah, sure", for: .normal)
//        button.setTitleColor(UIColor(named: "FavrOrange"), for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrBlue")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSuccess), for: .touchUpInside)
        return button
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("No thanks", for: .normal)
        button.setTitleColor(UIColor(named: "FavrOrange"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "LightAccent")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(notificationLabel)
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notificationLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -120).isActive = true

        addSubview(checkLabel)
        checkLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -38).isActive = true
        checkLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 0).isActive = true
        checkLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(yesButton)
        yesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        yesButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        yesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -74).isActive = true
        yesButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(noButton)
        noButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        noButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
