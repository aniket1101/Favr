//
//  SecondLaunchViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 06/03/2021.
//

import UIKit
import Firebase

class SecondLaunchViewController: UIViewController {

    private let launchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreenLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let splashView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemBackground
        
        splashView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.bounds.width,
                                  height: view.bounds.height)
                
        view.addSubview(splashView)
        splashView.addSubview(launchImage)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) { [weak self] in
            self?.launchAnimation()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        launchImage.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 175,
                                   height: 175)
        launchImage.center = view.center
    }
    
    private func launchAnimation() {
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self?.playHeartBeatAnimation()
        }) { (_) in
            UIView.animate(withDuration: 0.35, delay: 1.5, options: .curveEaseIn) { [weak self] in
                self?.launchImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } completion: { [weak self] (_) in
                UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseIn) {
                    self?.launchImage.alpha = 0
                } completion: { (_) in
                    self?.launchImage.removeFromSuperview()
                    self?.validateAuth()
                }
            }
        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = startPageViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            present (nav, animated: false)
        }
        else {
            let vc = TabBarViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            nav.setNavigationBarHidden(true, animated: false)
            present (nav, animated: false)
        }
    }
    
    // MARK: - Heartbeat Animation
    /// Inspiration from https://github.com/PiXeL16/RevealingSplashView
    
    public typealias AnimatableCompletion = () -> Void
    public typealias AnimatableExecution = () -> Void
    
    fileprivate func animateLaunchImage(_ animation: AnimatableExecution, completion: AnimatableCompletion? = nil) {
        
        CATransaction.begin()
        
        if let completion = completion {
            CATransaction.setCompletionBlock { completion() }
        }
        
        animation()
        CATransaction.commit()
    }
    
    func playHeartBeatAnimation(_ completion: AnimatableCompletion? = nil) {
        
        let popForce = 0.8
        
        animateLaunchImage({
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [0, 0.1 * popForce, 0.015 * popForce, 0.2 * popForce, 0]
            animation.keyTimes = [0, 0.25, 0.35, 0.55, 1]
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = CFTimeInterval(0.75)
            animation.isAdditive = true
            animation.repeatCount = Float(1 > 0 ? 1 : 1)
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0.25)
            
            launchImage.layer.add(animation, forKey: "pop")
            
        }, completion: { [weak self] in
            
            self?.playHeartBeatAnimation(completion)
        })
    }
    
}
