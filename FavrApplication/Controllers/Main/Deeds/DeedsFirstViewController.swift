//
//  DeedsFirstViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 31/01/2021.
//

import UIKit
import SDWebImage
import Firebase
import Layoutless
import SparkUI
import ShimmerSwift

class DeedsFirstViewController: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var deedTitle = ""
    var cardViewController: DeedsCardViewController!
    var visualEffectView: UIVisualEffectView!
    
    let cardHeight: CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 100
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0

    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        imageView.addSubview(blurEffectView)
        return imageView
    }()
    

    
//    private let deedLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = UIColor(named: "FavrOrange")
//        label.textColor = UIColor(named: "Accent")
//        label.textColor = .label
//        label.textAlignment = .center
//        label.numberOfLines = -1
//        label.font = UIFont(name: "Montserrat-Bold", size: 20)
//        label.layer.cornerRadius = 25
//        return label
//    }()
    
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        button.imageView?.tintColor = .systemBackground
//        button.backgroundColor = UIColor(named: "FavrOrange")
//        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
//        return button
//    }()
//
//    @objc private func backButtonPressed() {
//        navigationController?.pop()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // MARK: - Shimmer Layer
        
        imageView.heroID = "imageView"
//        backButton.heroID = "favrBackButton"
        
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
        
        imageView.add(gesture: .swipe(.down)) {
            self.navigationController?.pop()
        }
        
        view.add(gesture: .swipe(.right)) {
            self.navigationController?.pop()
        }
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("deedCompleted"), object: nil, queue: nil) { (_) in
//            self.animateTransitionIfNeeded(state: self.nextState, duration: 0.9)
//
//            // Make Favrs Completed View
//            let vc = DeedUsersCompletedViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .popover
//            self.present(nav, animated: true)
//        }
        
        // MARK: - Subviews
        view.addSubview(imageView)
//        view.addSubview(backButton)

        
        // MARK: Miscellaneous
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setUpCard()
    }
    
    // MARK: - Pop Up Card
    
    func setUpCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        cardViewController = DeedsCardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0,
                                               y: self.view.frame.height - self.cardHandleAreaHeight-85,
                                               width: self.view.bounds.width,
                                               height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recogniser:)))
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recogniser:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecogniser)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecogniser)
        
        cardViewController.deedLabel.text = deedTitle
        let ref = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Description")
        ref.observe(.value, with: { [weak self]
            snapshot in
            let value = snapshot.value as? String
            self?.cardViewController.deedDescriptionLabel.text = value
        })
        let reference = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Completed")
        reference.observe(.value, with: { [weak self]
            snapshot in
            let value = String(describing: snapshot.value ?? 0)
            if value == "1" {
                self?.cardViewController.deedCompletedButton.setTitle("\(value) Favr", for: .normal)
            }
            else {
                self?.cardViewController.deedCompletedButton.setTitle("\(value) Favrs", for: .normal)
            }
        })
        let pointRef = Database.database().reference().child("Admin").child("Favrs").child(deedTitle).child("Points")
        pointRef.observe(.value, with: { [weak self]
            snapshot in
            let value = String(describing: snapshot.value ?? 0)
            self?.cardViewController.pointLabel.text = "\(value) points"
        })
    }
    
    // MARK: - Card gestures
        
    @objc func handleCardTap(recogniser: UITapGestureRecognizer) {
        switch recogniser.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recogniser.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // MARK: - Card Animations
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    // MARK: - Card Transitions
    
    func startInteractiveTransition (state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition (fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition () {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.frame.height)
        
//        backButton.frame = CGRect(x: 20,
//                                  y: 50,
//                                  width: 60,
//                                  height: 60)
//        backButton.layer.cornerRadius = backButton.bounds.size.width * 0.5
//        backgroundView.center = view.center
//        deedLabel.frame = CGRect(x: 20,
//                                 y: 0,
//                                 width: view.width-40,
//                                 height: 150)
//        deedLabel.center = view.center

    }
    
    // MARK: - Hero
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableHero()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableHero()
    }

}
