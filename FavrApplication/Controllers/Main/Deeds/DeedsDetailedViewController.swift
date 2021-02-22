//
//  DeedsDetailedViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 04/01/2021.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase
import SDWebImage
import Layoutless
import TransitionButton

class DeedsDetailedViewController: UIViewController {
    
    var deedTitle = ""
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let deedLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGroupedBackground
        label.textColor = .label
        label.numberOfLines = -1
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = 25
        return label
    }()
    
    let deedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.backgroundColor = .systemGroupedBackground
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.sizeToFit()
        return label
    }()
    
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.tintColor = .systemBackground
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func backButtonPressed() {
        navigationController?.pop()
    }
    
//    private let navigationBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = .tertiarySystemBackground
//        view.layer.cornerRadius = 12
//        return view
//    }()
    
    let favrButton: TransitionButton = {
        let button = TransitionButton()
        button.backgroundColor = UIColor(named: "FavrOrange")
        button.setTitle("Complete", for: .normal)
        button.addTarget(self, action: #selector(favrButtonTapped), for: .touchUpInside)
        button.spinnerColor = .white
        return button
    }()
    
    @objc private func favrButtonTapped() {
        favrButton.startAnimation()
                
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.favrButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1) {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.modalPresentationStyle = .overFullScreen
                    let vc = DeedCompletedViewController()
                    vc.deedTitle = self.deedLabel.text ?? "Error, not"
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
//    private let secondNavigationBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = .tertiarySystemBackground
//        view.layer.cornerRadius = 12
//        return view
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemGroupedBackground
        
        // Download Image
        let path = "images/Favrs/\(deedTitle).png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    UIView.transition(with: self!.imageView, duration: 1.5, options: .transitionCrossDissolve, animations: {
                        self?.imageView.sd_setImage(with: url, completed: nil)
                    }, completion: nil)
                }
            case .failure(let error):
                print("\(error)")
            }
        })
        
        // Deed Title
                
        deedLabel.text = deedTitle
        
        // Download Deed Description
        let reference = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Description")
        reference.observe(.value, with: { [weak self]
            snapshot in
            let value = snapshot.value as? String
            self?.deedDescriptionLabel.text = value
        })
        
        // Add subviews

        view.addSubview(imageView)
        view.addSubview(deedLabel)
        view.addSubview(deedDescriptionLabel)
        view.addSubview(backButton)
//        scrollView.addSubview(backButton)
        view.addSubview(favrButton)
//        view.addSubview(navigationBar)
//        view.addSubview(secondNavigationBar)
        
        imageView.add(gesture: .swipe(.down)) {
            self.navigationController?.pop()
        }
        
        view.add(gesture: .swipe(.right)) {
            self.navigationController?.pop()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
        navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        imageView.frame = CGRect(x: 0,
                                 y: -10,
                                 width: view.width,
                                 height: 300)
        deedLabel.frame = CGRect(x: 20,
                                 y: imageView.bottom+20,
                                 width: view.width-40,
                                 height: 22)
        deedDescriptionLabel.frame = CGRect(x: 20,
                                            y: deedLabel.bottom+10,
                                            width: view.width-40,
                                            height: 80)
        favrButton.frame = CGRect(x: (view.width/2)-75,
                                  y: deedDescriptionLabel.bottom+20,
                                  width: 150,
                                  height: 50)
        favrButton.layer.cornerRadius = 12
        backButton.frame = CGRect(x: 20,
                                  y: 50,
                                  width: 60,
                                  height: 60)
        backButton.layer.cornerRadius = 30

//        navigationBar.frame = CGRect(x: 0,
//                                     y: 0,
//                                     width: scrollView.width,
//                                     height: 50)
//        secondNavigationBar.frame = CGRect(x: 0,
//                                           y: 0,
//                                           width: 25,
//                                           height: imageView.height+10)
    }

}
