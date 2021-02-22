//
//  DeedCompletedViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 03/02/2021.
//

import UIKit
import TransitionButton
import Firebase
import SwiftDate

class DeedCompletedViewController: CustomTransitionViewController {
    
    // Integers
    var oldPoints = 0
    var deedValue = 0
    var completed = 0
    var streak = 0
    var totalDeeds = 0

    // Strings
    var deedTitle = ""
    var finalValue = ""

    // Bools
    var deedCompleted = false
    var favrCompleted = false
    var dateCompleted = false
    var streakCompleted = false
    var totalDeedsCompleted = false
    
    // Dates
    
    var lastDate: Date = Date.past()
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    
    // Stylising components
    
    private let deedLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Accent")
        label.numberOfLines = 3
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor(named: "LightAccent"), for: .normal)
        button.layer.backgroundColor = UIColor(named: "FavrBlue")?.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func completeButtonTapped() {
                
        // MARK: - Retreive Deed Points Value
        
        let pointRef = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Points")
        pointRef.observe(.value, with: { [weak self]
            snapshot in
            let deedPoints = String(describing: snapshot.value ?? 0)
            self?.deedValue = Int(deedPoints)!
        })
        
        // MARK: - Retrieve Current Points
        
        let reference = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("points")
        reference.observe(.value, with: { [weak self]
            snapshot in
            let initialPoints = String(describing: snapshot.value ?? 0)
            self?.oldPoints = Int(initialPoints)!
            self?.finalValue = "\(self!.oldPoints + self!.deedValue)"
            
            // MARK: - Update Value
            
            if self?.deedCompleted == false {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
            let ref = Database.database().reference().child(safeEmail)
            guard let key = ref.child("points").key else { return }
            
                let childUpdates = ["\(key)": self?.finalValue,
            ]
            ref.updateChildValues(childUpdates as [AnyHashable : Any])
                self?.deedCompleted = true
            }
        })
        
        
        // MARK: - Add One to Favrs Number for this Deed
        let completedRef = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Completed")
        completedRef.observe(.value, with: { [weak self]
            snapshot in
            let completed = String(describing: snapshot.value ?? 0)
            print("old completed:", self?.completed ?? "Error, old completed")
            self?.completed = Int(completed)!
            self?.completed += 1
            print("new completed:", self?.completed ?? "Error, completed")
        
        // MARK: - Update Values
            if self?.favrCompleted == false {
                
            let deedCompletedRef = Database.database().reference().child("Admin").child("Favrs").child(self?.deedTitle ?? "Favr")
            guard let deedKey = deedCompletedRef.child("Completed").key else { return }
            
            let secondChildUpdates = ["\(deedKey)": self?.completed,
            ]
            print("after upload:", completed)
            deedCompletedRef.updateChildValues(secondChildUpdates as [AnyHashable : Any])
            self?.favrCompleted = true
        }
        })
        
        // MARK: - Update Last Deed and Streaks
        
        let dateRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("lastDeed")
        dateRef.observe(.value, with: { [weak self]
            snapshot in
            let dateValue = snapshot.value as! String
            print("Date Value:", dateValue)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.locale = .autoupdatingCurrent
            let finalDateValue = formatter.date(from: dateValue)
            self?.lastDate = finalDateValue!
            if self?.dateCompleted == false {
                let secondDateRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                guard let dateKey = secondDateRef.child("lastDeed").key else { return }
                let currentDate = formatter.string(from: Date.now())
                let thirdChildUpdates = ["\(dateKey)": currentDate,
                ]
                secondDateRef.updateChildValues(thirdChildUpdates as [AnyHashable : Any])
                self?.dateCompleted = true
            }
                        
            if self?.lastDate.isYesterday == true {
                
                let streaksRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("streaks")
                streaksRef.observe(.value, with: { [weak self]
                    snapshot in
                    let streaksValue = String(describing: snapshot.value ?? 0)
                    self?.streak = Int(streaksValue)!
                    self?.streak += 1
                    if self?.streakCompleted == false {
                        let streakKeyRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                        guard let streakKey = streakKeyRef.child("streaks").key else { return }
                        
                        let fourthChildUpdates = ["\(streakKey)": self?.streak,
                        ]
                        streakKeyRef.updateChildValues(fourthChildUpdates as [AnyHashable : Any])
                        self?.streakCompleted = true
                    }
                })
            }
            else {
                print("Streaks status: New Streak")
                if self?.streakCompleted == false {
                    let streakKeyRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                    guard let streakKey = streakKeyRef.child("streaks").key else { return }
                    
                    let fourthChildUpdates = ["\(streakKey)": 1,
                    ]
                    streakKeyRef.updateChildValues(fourthChildUpdates as [AnyHashable : Any])
                    self?.streakCompleted = true
                }
            }
            
            let totalDeedsRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("totalDeeds")
            totalDeedsRef.observe(.value, with: { [weak self]
                snapshot in
                let totalDeedsValue = String(describing: snapshot.value ?? 0)
                self?.totalDeeds = Int(totalDeedsValue)!
                self?.totalDeeds += 1
                if self?.totalDeedsCompleted == false {
                    let totalDeedsKeyRef = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                    guard let totalDeedsKey = totalDeedsKeyRef.child("totalDeeds").key else { return }
                    
                    let fifthChildUpdates = ["\(totalDeedsKey)": self?.totalDeeds,
                    ]
                    totalDeedsKeyRef.updateChildValues(fifthChildUpdates as [AnyHashable : Any])
                    self?.totalDeedsCompleted = true
                }
            })
        })
        
        
        // MARK: - Dismiss View After Completing Tasks
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let pointsTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightAccent")
        label.text = "Points Added!"
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let finalPointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "FavrOrange")
        
        deedLabel.text = "\"\(deedTitle)\" Completed"
        
                
        view.addSubview(deedLabel)
        view.addSubview(completeButton)
        view.addSubview(pointsLabel)
        view.addSubview(pointsTextLabel)
        view.addSubview(finalPointsLabel)
        
        deedLabel.fadeIn()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        deedLabel.frame = CGRect(x: 40,
                                 y: 0,
                                 width: view.width-80,
                                 height: 120)
        deedLabel.center = view.center
        pointsLabel.frame = CGRect(x: 40,
                                   y: deedLabel.bottom+10,
                                   width: view.width-80,
                                   height: 18)
        pointsTextLabel.frame = CGRect(x: 40,
                                       y: pointsLabel.bottom,
                                       width: view.width-80,
                                       height: 18)
        finalPointsLabel.frame = CGRect(x: 40,
                                        y: pointsTextLabel.bottom,
                                        width: view.width-80,
                                        height: 18)
        completeButton.frame = CGRect(x: 40,
                                      y: finalPointsLabel.bottom+20,
                                      width: view.width-80,
                                      height: 52)
        
    }

}

extension UIView {


    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
