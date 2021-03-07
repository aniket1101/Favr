//
//  completedFavrsDetailedViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 05/03/2021.
//

import UIKit
import MarqueeLabel

class completedFavrsDetailedViewController: UIViewController {

    var deedTitle = ""
    var deedDescription = ""
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let deedLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.backgroundColor = .systemGroupedBackground
        label.textColor = .label
        label.numberOfLines = -1
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.type = .rightLeft
        label.speed = .duration(1.5)
        label.animationCurve = .easeInOut
        label.textAlignment = .center
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
        
        // Deed Title and Deed Description
                
        deedLabel.text = deedTitle
        deedDescriptionLabel.text = deedDescription
        
        // Add subviews

        view.addSubview(imageView)
        view.addSubview(deedLabel)
        view.addSubview(deedDescriptionLabel)
        
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
