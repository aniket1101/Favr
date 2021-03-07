//
//  ViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 19/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//
//
//import UIKit
//import FirebaseAuth
//import JGProgressHUD
//import Firebase
//import SwiftEntryKit
//import Network
//import Lottie
//
///// Controller that shows list of conversations
//final class ConversationsViewController: UIViewController {
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.clipsToBounds = true
//        return scrollView
//    }()
//    
//    private let spinner: JGProgressHUD = {
//        let spinner = JGProgressHUD(style: .dark)
//        spinner.square = true
//        spinner.cornerRadius = 12
//        return spinner
//    }()
//    
//    private let animationView: AnimationView = {
//        let view = AnimationView()
//        view.isHidden = true
//        return view
//    }()
//        
//    private let chatTitleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGroupedBackground
//        return view
//    }()
//    
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        button.imageView?.tintColor = .label
//        button.setBackground(color: .systemGroupedBackground)
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    @objc private func backButtonTapped() {
//        navigationController?.pop()
//    }
//    
//    let chatTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Chats"
//        label.font = UIFont(name: "Montserrat-Bold", size: 35)
//        label.isOpaque = false
//        label.textColor = .label
//        label.backgroundColor = .systemGroupedBackground
//        return label
//    }()
//    
//    func startAnimation() {
//        animationView.animation = Animation.named("44656-error")
//        animationView.play()
//        animationView.loopMode = .loop
//    }
//    
//    let searchButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
//        button.tintColor = .systemBackground
//        button.clipsToBounds = true
//        button.setBackground(color: .label)
//        button.imageView?.tintColor = .systemGroupedBackground
//        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
//        return button
//    }()
//
//    
//    private let refreshControl = UIRefreshControl()
//    
//    private var conversations = [Conversation]()
//    
//    private let tableView: UITableView = {
//        let table = UITableView()
//        table.isHidden = true
//        table.backgroundColor = .systemGroupedBackground
//        table.automaticallyAdjustsScrollIndicatorInsets = false
//        table.clipsToBounds = true
//        table.register(ConversationTableViewCell.self,
//                       forCellReuseIdentifier: ConversationTableViewCell.identifier)
//        return table
//    }()
//    
//    private let noConversationsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No Conversations"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
//    
////    private let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
////
////    private let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//    
//    private var loginObserver: NSObjectProtocol?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = true
//        
//        view.backgroundColor = .systemGroupedBackground
//        tableView.contentInsetAdjustmentBehavior = .never
//        
////        navigationController?.navigationBar.prefersLargeTitles = true
//        
////        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
////                                                            target: self,
////                                                            action: #selector(didTapSearchButton))
//        
//        view.addSubview(scrollView)
//        
//        chatTitleView.addSubview(chatTitleLabel)
//        chatTitleView.addSubview(searchButton)
//        chatTitleView.addSubview(backButton)
//        scrollView.addSubview(chatTitleView)
//        scrollView.addSubview(tableView)
//        scrollView.addSubview(noConversationsLabel)
//        scrollView.addSubview(animationView)
//        setupTableView()
//        startListeningForConversations()
//        tableView.reloadData()
//        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.startListeningForConversations()
//        })
//        
//        chatTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        
//        view.add(gesture: .swipe(.down)) {
//            self.navigationController?.pop()
//        }
//        
//        view.add(gesture: .swipe(.right)) {
//            self.navigationController?.pop()
//        }
//    }
//    
//    private func startListeningForConversations() {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        
//        if let observer = loginObserver {
//            NotificationCenter.default.removeObserver(observer)
//        }
//        
//        print("Starting conversation fetch...")
//        
////        loadingIndicator.hidesWhenStopped = true
////        loadingIndicator.style = UIActivityIndicatorView.Style.medium
////        loadingIndicator.startAnimating();
////
////        loadingAlert.view.addSubview(loadingIndicator)
////        present(loadingAlert, animated: true, completion: nil)
//        
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//        
//        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
//            switch result {
//                case .success(let conversations):
//                    print("successfully got conversation models")
////                    DispatchQueue.main.async {
////                        self?.loadingAlert.dismiss(animated: false, completion: nil)
////                        self?.loadingIndicator.stopAnimating()
////                    }
//                    guard !conversations.isEmpty else {
//                        self?.tableView.isHidden = true
//                        self?.noConversationsLabel.isHidden = false
//                        return
//                    }
//                    self?.noConversationsLabel.isHidden = true
//                    self?.tableView.isHidden = false
//                    self?.conversations = conversations
//
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                case .failure(let error):
//                    self?.tableView.isHidden = true
//                    let monitor = NWPathMonitor()
//                    monitor.pathUpdateHandler = { path in
//                        if path.status == .satisfied {
//                            print("Connected")
//                            self?.noConversationsLabel.isHidden = false
//                            self?.animationView.isHidden = true
//                            let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//                            self?.present(alert, animated: true)
//                        }
//                        else {
//                            // Network error image/animation
//                            self?.startAnimation()
//                            self?.animationView.isHidden = false
//                        }
//                    }
//                    
//                    print("failed to get convos: \(error)")
//                }
//            })
//    }
//    
//    @objc private func didTapSearchButton() {
//        let vc = searchUsersViewController()
//        vc.completion = { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            
//            let currentConversations = strongSelf.conversations
//            
//            if let targetConversation = currentConversations.first(where: {
//                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
//            }) {
//                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
//                vc.isNewConversation = false
//                vc.title = ""
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//                let reference = Database.database().reference().child("Users").child(DatabaseManager.safeEmail(emailAddress: result.email))
//                reference.child("name").observeSingleEvent(of: .value, with: {
//                    snapshot in
//                    let newName = snapshot.value as? String
//                    vc.title = "@ \(newName ?? "User")"
//                })
//            }
//            else {
//                strongSelf.createNewConversation(result: result)
//            }
//        }
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
//    }
//    
//    private func createNewConversation(result: SearchResult) {
//        let email = DatabaseManager.safeEmail(emailAddress: result.email)
//        
//        // Check in database if conversation with these two users exists
//        // If there is a conversation we use conversationId
//        // Otherwise use existing code
//        
//        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            switch result {
//            case .success(let conversationId):
//                let vc = ChatViewController(with: email, id: conversationId)
//                vc.isNewConversation = false
//                vc.title = ""
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//                let reference = Database.database().reference().child("Users").child(email)
//                reference.child("name").observeSingleEvent(of: .value, with: {
//                    snapshot in
//                    let newName = snapshot.value as? String
//                    vc.title = newName
//                })
//            case .failure(_):
//                let vc = ChatViewController(with: email, id: nil)
//                vc.isNewConversation = true
//                vc.title = ""
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//                let reference = Database.database().reference().child("Users").child(email)
//                reference.child("name").observeSingleEvent(of: .value, with: {
//                    snapshot in
//                    let newName = snapshot.value as? String
//                    vc.title = newName
//                })
//            }
//        })
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
//        noConversationsLabel.frame = CGRect(x: 10,
//                                            y: (scrollView.height-100)/2,
//                                            width: scrollView.width-20,
//                                            height: 100)
//        animationView.frame = CGRect(x: (scrollView.width/2)-200,
//                                     y: (scrollView.height/2)-200,
//                                     width: scrollView.width/2,
//                                     height: scrollView.width/2)
//        chatTitleView.frame = CGRect(x: 0,
//                                     y: view.top,
//                                     width: view.width,
//                                     height: 80)
//        searchButton.frame = CGRect(x: view.width-90,
//                                    y: chatTitleLabel.top,
//                                    width: 50,
//                                    height: 50)
//        searchButton.layer.cornerRadius = searchButton.frame.size.width / 2
//        backButton.frame = CGRect(x: 10,
//                                  y: 20,
//                                  width: 20,
//                                  height: 40)
//        chatTitleLabel.frame = CGRect(x: backButton.right + 5,
//                                      y: 20,
//                                      width: chatTitleView.width,
//                                      height: 40)
//        tableView.frame = CGRect(x: 0,
//                                 y: chatTitleView.bottom,
//                                 width: view.width,
//                                 height: view.height-view.safeAreaInsets.top-100-view.safeAreaInsets.bottom)
//        animationView.center = scrollView.center
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.contentInsetAdjustmentBehavior = .never
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        chatTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//
//        enableHero()
////        DispatchQueue.main.async {
////                    self.navigationController?.navigationBar.setNeedsLayout()
////                }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        disableHero()
//    }
//    
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.bounces = true
//        tableView.alwaysBounceVertical = true
//    }
//    
//}
//
//
//extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return conversations.count
//    }
//    
////    func numberOfSections(in tableView: UITableView) -> Int {
////    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = conversations[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
//                                                 for: indexPath) as! ConversationTableViewCell
//        cell.configure(with: model)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let model = conversations[indexPath.row]
//        openConversation(model)
//    }
//    
//    func openConversation(_ model: Conversation) {
//        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
//        vc.title = model.name
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            // Begin deleting
//            let conversationId = conversations[indexPath.row].id
//            tableView.beginUpdates()
//            self.conversations.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
//
//            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
//                if !success {
//                    // Add model and row back and show error alert
//                    print("Conversation Deleted")
//                }
//            })
//            
//            tableView.endUpdates()
//        }
//    }
//}
