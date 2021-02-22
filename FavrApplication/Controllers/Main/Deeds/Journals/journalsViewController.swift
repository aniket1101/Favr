//
//  journalsViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 21/02/2021.
//

import UIKit
import ShimmerSwift
import Firebase

class JournalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let entries = ["Today was great. I had so much fun", "I didn't have fun today. I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.I didn't have fun today.", "This was the best day in a while. This was the best day in a while.This was the best day in a while.This was the best day in a while.This was the best day in a while.", "I can't wait for tomorrow :("]
    private let entriesTitle = ["Today", "Yesterday", "Saturday", "Friday"]
    private let entriesDate = ["22 February 2021", "21 February 2021", "20 February 2021", "19 February 2021"]
    
    private var journalsCollectionView: UICollectionView?
    
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
    
    private let currentJournalTextView: UILabel = {
        let textView = UILabel()
        textView.text = "How has your day been?"
        textView.textAlignment = .center
        textView.font = UIFont(name: "Montserrat-Regular", size: 14)
        textView.backgroundColor = .tertiarySystemGroupedBackground
        return textView
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
        currentJournalView.addSubview(currentJournalTextView)
        view.addSubview(pastJournalsView)
        pastJournalsView.addSubview(pastJournalsLabel)
        view.addSubview(journalsCollectionView)
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
        currentJournalTextView.frame = CGRect(x: 10,
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let oldJournalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCollectionViewCell", for: indexPath) as! oldJournalCollectionViewCell
        oldJournalCell.configure(titleLabelText: "\(entriesTitle[indexPath.row])", textViewText: "\(entries[indexPath.row])", dateText: "\(entriesDate[indexPath.row])")
        return oldJournalCell
    }

}
