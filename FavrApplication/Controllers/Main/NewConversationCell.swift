//
//  NewConversationCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 03/01/2021.
//

import Foundation
import Firebase
import SDWebImage

class NewConversationCell: UITableViewCell {
    
    static let identifier = "NewConversationCell"
        
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(statusLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 70,
                                     height: 70)
        userNameLabel.frame = CGRect(x: userImageView.right + 10,
                                     y: 20,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: 30)
        statusLabel.frame = CGRect(x: userImageView.right + 10,
                                   y: 50,
                                   width: contentView.width-20,
                                   height: 20)
    }
    
    public func configure(with model: SearchResult) {
        let reference = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: model.email))
        reference.child("Status").observeSingleEvent(of: .value, with: {
            snapshot in
            let newStatus = snapshot.value as? String
            self.statusLabel.text = newStatus
        })
        reference.child("Username").observeSingleEvent(of: .value, with: {
            snapshot in
            let newName = snapshot.value as? String
            self.userNameLabel.text = newName
        })
        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("Failed to get image url: \(error)")
            }
        })
    }
    
}
