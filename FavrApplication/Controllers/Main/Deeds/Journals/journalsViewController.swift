//
//  journalsViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 21/02/2021.
//

import UIKit
import ShimmerSwift
import Firebase
import Network
import Lottie

class JournalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var journalsCollectionView: UICollectionView?
    private var journals = [Journal]()
    
    private let currentJournalView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let pastJournalsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let currentJournalLabel: UILabel = {
        let label = UILabel()
        label.text = "How has your day been?"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.backgroundColor = .tertiarySystemGroupedBackground
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    private let journalLabel: UILabel = {
        let label = UILabel()
        label.text = "Journals"
        label.font = UIFont(name: "Montserrat-Bold", size: 22)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = -1
        return label
    }()
    
    private let pastJournalsLabel: UILabel = {
        let label = UILabel()
        label.text = "Past Journals"
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private let animationView: AnimationView = {
        let view = AnimationView()
        view.isHidden = true
        return view
    }()
    
    func startAnimation() {
        animationView.animation = Animation.named("44656-error")
        animationView.play()
        animationView.loopMode = .loop
    }
    
    private let noJournalsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Journals. Add one!"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    
    
    @objc private func currentJournalTapped() {
        let vc = detailedCurrentJournalViewController()
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemGroupedBackground
        self.hideKeyboardWhenTappedAround()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: view.width-20, height: view.height/4)
        
        journalsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let journalsCollectionView = journalsCollectionView else {
            return
        }
        journalsCollectionView.registerCell(oldJournalCollectionViewCell.self, forCellWithReuseIdentifier: oldJournalCollectionViewCell.identifier)
        
        journalsCollectionView.delegate = self
        journalsCollectionView.dataSource = self
        journalsCollectionView.backgroundColor = .systemFill
        journalsCollectionView.alpha = 0
        journalsCollectionView.showsVerticalScrollIndicator = false
        
        journalsCollectionView.frame = CGRect(x: 0,
                                              y: (view.height/4)+160,
                                              width: view.width,
                                              height: (view.height)-((view.height/4)+160))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(currentJournalTapped))
        currentJournalView.addGestureRecognizer(gesture)
        
        view.addSubview(dismissButton)
        view.addSubview(journalLabel)
        view.addSubview(currentJournalView)
        currentJournalView.addSubview(currentJournalLabel)
        view.addSubview(pastJournalsView)
        pastJournalsView.addSubview(pastJournalsLabel)
        view.addSubview(journalsCollectionView)
        view.addSubview(noJournalsLabel)
        view.addSubview(animationView)
        startListeningForJournals()
        journalsCollectionView.reloadData()
    }
    
    private func startListeningForJournals() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        print("Starting journal fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getAllJournals(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let journals):
                print("successfully got journals")
                self?.journalsCollectionView?.fadeIn()
                guard !journals.isEmpty else {
                    self?.journalsCollectionView?.isHidden = true
                    self?.pastJournalsView.isHidden = true
                    self?.pastJournalsLabel.isHidden = true
                    self?.view.bringSubviewToFront(self!.noJournalsLabel)
                    self?.noJournalsLabel.isHidden = false
                    return
                }
                self?.noJournalsLabel.isHidden  = true
                self?.pastJournalsView.isHidden = false
                self?.pastJournalsLabel.isHidden = false
                self?.journalsCollectionView?.isHidden = false
                self?.journals = journals
                
                DispatchQueue.main.async {
                    self?.journalsCollectionView?.reloadData()
                }
            case .failure(let error):
                self?.journalsCollectionView?.isHidden = true
                let monitor = NWPathMonitor()
                monitor.pathUpdateHandler = { path in
                    if path.status == .satisfied {
                        print("Connected")
                        self?.noJournalsLabel.isHidden = false
                        self?.animationView.isHidden = true
                        let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self?.present(alert, animated: true)
                    }
                    else {
                        // Network error image/animation
                        self?.startAnimation()
                        self?.animationView.isHidden = false
                    }
                }
                
                print("failed to get journals: \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dismissButton.frame = CGRect(x: view.width-60,
                                     y: 40,
                                     width: 30,
                                     height: 30)
        journalLabel.frame = CGRect(x: 0,
                                    y: dismissButton.bottom+5,
                                    width: view.width,
                                    height: 30)
        currentJournalView.frame = CGRect(x: 10,
                                          y: journalLabel.bottom+10,
                                              width: view.width-20,
                                              height: view.height/4)
        currentJournalLabel.frame = CGRect(x: 10,
                                              y: 10,
                                              width: currentJournalView.width-20,
                                              height: currentJournalView.height-20)
        pastJournalsView.frame = CGRect(x: 0,
                                        y: currentJournalView.bottom+15,
                                        width: view.width,
                                        height: 50)
        pastJournalsLabel.frame = CGRect(x: 10,
                                         y: 0,
                                         width: view.width,
                                         height: 30)
        noJournalsLabel.sizeToFit()
        noJournalsLabel.frame = CGRect(x: 10,
                                       y: view.height/2,
                                       width: view.width-20,
                                       height: 100)
        animationView.frame = CGRect(x: (view.width/2)-200,
                                     y: (view.height)*(3/4),
                                     width: 100,
                                     height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        journals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = journals[indexPath.row]
        let oldJournalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCollectionViewCell", for: indexPath) as! oldJournalCollectionViewCell
        
        oldJournalCell.configure(with: model)
        return oldJournalCell
    }

}
