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
import Lottie

class DeedCompletedViewController: CustomTransitionViewController {
    
    // Integers
    var oldPoints = 0
    var deedValue = 0
    var completed = 0
    var streak = 0
    var totalDeeds = 0
 
    // Doubles
    
    var currentDeedPoints: Double = 0
    var firstPoints: Double = 0

    // Strings
    var deedTitle = ""
    var finalValue = ""
    var deedDescription = ""

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
        label.textColor = UIColor(named: "LightAccent")
        label.numberOfLines = 3
        label.font = UIFont(name: "Montserrat-Bold", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let animationView = AnimationView()
    
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
        
        let reference = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("points")
        reference.observe(.value, with: { [weak self]
            snapshot in
            let initialPoints = String(describing: snapshot.value ?? 0)
            self?.oldPoints = Int(initialPoints)!
            self?.finalValue = "\(self!.oldPoints + self!.deedValue)"
            
            // MARK: - Update Value
            
            if self?.deedCompleted == false {
            let safeEmail = DatabaseManager.safeEmail(emailAddress: (Auth.auth().currentUser?.email)!)
                let ref = Database.database().reference().child("Users").child(safeEmail)
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
            self?.completed = Int(completed)!
            self?.completed += 1
        
        // MARK: - Update Values
            if self?.favrCompleted == false {
                
            let deedCompletedRef = Database.database().reference().child("Admin").child("Favrs").child(self?.deedTitle ?? "Favr")
            guard let deedKey = deedCompletedRef.child("Completed").key else { return }
            
            let secondChildUpdates = ["\(deedKey)": self?.completed,
            ]
            deedCompletedRef.updateChildValues(secondChildUpdates as [AnyHashable : Any])
            self?.favrCompleted = true
        }
        })
        
        // MARK: - Update Last Deed and Streaks
        
        let dateRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("lastDeed")
        dateRef.observe(.value, with: { [weak self]
            snapshot in
            let dateValue = snapshot.value as! String
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.locale = .autoupdatingCurrent
            formatter.dateFormat = "dd/MM/yyyy"
            let lastDate = formatter.date(from: dateValue)
            self?.lastDate = lastDate!
            if self?.dateCompleted == false {
                let secondDateRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                guard let dateKey = secondDateRef.child("lastDeed").key else { return }
                let currentDate = formatter.string(from: Date.now())
                let thirdChildUpdates = ["\(dateKey)": currentDate,
                ]
                secondDateRef.updateChildValues(thirdChildUpdates as [AnyHashable : Any])
                self?.dateCompleted = true
            }
                        
            if self?.lastDate.isYesterday == true {
                
                let streaksRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("streaks")
                streaksRef.observe(.value, with: { [weak self]
                    snapshot in
                    let streak = String(describing: snapshot.value ?? 0)
                    self?.streak = Int(streak)!
                    self?.streak += 1
                    if self?.streakCompleted == false {
                        let streakKeyRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                        guard let streakKey = streakKeyRef.child("streaks").key else { return }
                        
                        let fourthChildUpdates = ["\(streakKey)": self?.streak,
                        ]
                        streakKeyRef.updateChildValues(fourthChildUpdates as [AnyHashable : Any])
                        self?.streakCompleted = true
                    }
                })
            }
            else if self?.lastDate.isToday == true {
                print("Last Favr was today")
            }
            else {
                print("Streaks status: New Streak")
                if self?.streakCompleted == false {
                    let streakKeyRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                    guard let streakKey = streakKeyRef.child("streaks").key else { return }
                    
                    let fourthChildUpdates = ["\(streakKey)": 1,
                    ]
                    streakKeyRef.updateChildValues(fourthChildUpdates as [AnyHashable : Any])
                    self?.streakCompleted = true
                }
            }
            
            let totalDeedsRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("totalDeeds")
            totalDeedsRef.observe(.value, with: { [weak self]
                snapshot in
                let totalDeeds = String(describing: snapshot.value ?? 0)
                self?.totalDeeds = Int(totalDeeds)!
                self?.totalDeeds += 1
                if self?.totalDeedsCompleted == false {
                    let totalDeedsKeyRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email"))
                    guard let totalDeedsKey = totalDeedsKeyRef.child("totalDeeds").key else { return }
                    let fifthChildUpdates = ["\(totalDeedsKey)": self?.totalDeeds,
                    ]
                    totalDeedsKeyRef.updateChildValues(fifthChildUpdates as [AnyHashable : Any])
                    self?.totalDeedsCompleted = true
                }
            })
            
            let database = Database.database().reference()
            guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
            let ref = database.child("Users").child("\(safeEmail)")

            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard var userNode = snapshot.value as? [String: Any] else {
                    print("User not found")
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                formatter.locale = .autoupdatingCurrent
                formatter.dateFormat = "dd/MM/yyyy"
                
                let currentDate = formatter.string(from: Date.now())
                let pointString = String(describing: self?.deedValue ?? 0)
                let pointInt = Int(pointString)!
                                
                let completedFavrEntry: [String: Any] = [
                    "title": self?.deedTitle ?? "Error",
                    "description": self?.deedDescription ?? "Error",
                    "points": "\(pointInt)",
                    "date": currentDate
                ]
                
                if var completedFavrs = userNode["completedFavrs"] as? [[String: Any]] {
                    // completedFavrs array exists for current user
                    // You should append
                    
                    completedFavrs.append(completedFavrEntry)
                    userNode["completedFavrs"] = completedFavrs
                    ref.setValue(userNode, withCompletionBlock: { error, _  in
                        guard error == nil else {
                            return
                        }
                    })
                }
                else {
                    // completedFavrs array does NOT exist
                    // Create it
                    userNode["completedFavrs"] = [
                        completedFavrEntry
                    ]
                    
                    ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        return
                        }
                    })
                }
            })
        })
        // MARK: - Dismiss View After Completing Tasks
        dismiss(animated: true, completion: nil)
        
    }
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Montserrat-Bold", size: 60)
        label.backgroundColor = UIColor(named: "FavrSecondaryBlue")
        label.textAlignment = .center
        label.numberOfLines = 1
        label.layer.masksToBounds = true
        label.clipsToBounds = true
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
        
        // CA Display Link
        
        let pointsDisplayLink = CADisplayLink(target: self, selector: #selector(pointsUpdate))
        pointsDisplayLink.add(to: .main, forMode: .default)
        
        deedLabel.text = "\'\(deedTitle)\' Completed"
        
        startAnimation()

                
        view.addSubview(animationView)
        view.addSubview(deedLabel)
        view.addSubview(completeButton)
        view.addSubview(pointsLabel)
        view.addSubview(pointsTextLabel)
        view.addSubview(finalPointsLabel)
        
        deedLabel.fadeIn()
    }
    
    let animationStartDate = Date()
    let animationDuration: Double = 2
    
    @objc private func pointsUpdate() {
        
        // Inital Points
        let intialPointRef = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "email")).child("points")
        intialPointRef.observe(.value, with: { [weak self]
            snapshot in
            let initialPoints = String(describing: snapshot.value ?? 0)
            self?.firstPoints = Double(initialPoints)!
        })
        
        // Deed Points
        let pointRef = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Points")
        pointRef.observe(.value, with: { [weak self]
            snapshot in
            let currentDeed = String(describing: snapshot.value ?? 0)
            self?.currentDeedPoints = Double(currentDeed)!
        })
        
        let totalPoints = firstPoints + currentDeedPoints
        
        self.pointsLabel.text = "\(firstPoints)"
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
                
        if elapsedTime > animationDuration {
            self.pointsLabel.text = "\(Int(totalPoints))"
            pointsTextLabel.fadeOut()
        }
        else {
            let percentage = elapsedTime / animationDuration
            let finalFinalPointsValue = firstPoints + percentage * (totalPoints - firstPoints)
            self.pointsLabel.text = "\(Int(finalFinalPointsValue))"
        }
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("confetti")
        animationView.play()
        animationView.loopMode = .repeat(2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        deedLabel.frame = CGRect(x: 40,
                                 y: 44,
                                 width: view.width-80,
                                 height: 120)
        deedLabel.center.x = view.center.x
        pointsLabel.frame = CGRect(x: 40,
                                   y: deedLabel.bottom+10,
                                   width: view.width-80,
                                   height: 70)
        pointsTextLabel.center.x = view.center.x
        pointsLabel.layer.cornerRadius = 16
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
        animationView.frame = view.bounds
        
    }

}

extension UIView {


    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
