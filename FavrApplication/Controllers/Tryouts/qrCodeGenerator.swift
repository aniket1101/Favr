//
//  qrCodeGenerator.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 23/02/2021.
//

import Foundation
import UIKit
import Firebase
import NotificationCenter

class qrCodeGenerator: UIViewController {
    
    private var userBrightness = UIScreen.main.brightness
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let qrView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.backgroundColor = .systemGroupedBackground
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let favrView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "favrImage")
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGroupedBackground
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Montserrat-Bold", size: 21)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrBlue")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func scanButtonPressed() {
        let vc = qrScannerViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        
        let stringData = string.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(stringData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return UIImage()
    }
//
//    func toBase64(string: String) -> String {
//        let base64Encoded = string.data(using: String.Encoding.utf8)!.base64EncodedString()
//
//        return base64Encoded
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
//        layer.cornerRadius = 25
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("qrDismissButtonTapped"), object: nil, queue: nil) { (_) in
            
            // Dismiss this View
            self.dismiss(animated: true, completion: nil)
        }
        
        traitCollection.performAsCurrent {
            qrView.layer.borderColor = background.backgroundColor?.cgColor
            profilePicture.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        }
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
//        let encodedUserValue = toBase64(string: email)
        let usernameImage = generateQRCode(from: email)
        qrView.image = usernameImage
        
        view.addSubview(background)
        
        background.addSubview(qrView)
        qrView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qrView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200).isActive = true
        qrView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -200).isActive = true
        
        background.addSubview(favrView)
        favrView.centerYAnchor.constraint(equalTo: qrView.centerYAnchor).isActive = true
        favrView.centerXAnchor.constraint(equalTo: qrView.centerXAnchor).isActive = true
        favrView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        favrView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        background.addSubview(usernameLabel)
        usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: qrView.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(profilePicture)
        view.addSubview(scanButton)
        
        view.add(gesture: .tap(1)) { [weak self] in
            self?.addPulse()
        }
    }
    
    func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 80, position: profilePicture.center)
        pulse.animationDuration = 1.5
        pulse.backgroundColor = UIColor(named: "FavrOrange")?.cgColor
        
        self.view.layer.insertSublayer(pulse, below: profilePicture.layer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        background.frame = CGRect(x: 20,
                                  y: view.height/3,
                                  width: view.width-40,
                                  height: view.height/2.5)
        background.center.x = view.center.x
        profilePicture.frame = CGRect(x: (view.width/2)-30,
                                      y: (view.height/3)-30,
                                      width: 50,
                                      height: 50)
        profilePicture.center.x = view.center.x
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        scanButton.frame = CGRect(x: 20,
                                  y: background.bottom+20,
                                  width: view.width-40,
                                  height: 50)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIScreen.main.brightness = userBrightness
    }
}
