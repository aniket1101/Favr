//
//  ConversationTableViewCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 03/01/2021.
//

//import UIKit
//import SDWebImage
//import MessageKit
//
//class ConversationTableViewCell: UITableViewCell {
//
//    static let identifier = "ConversationTableViewCell"
//
//
//    private let userImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 35
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//
//    private let userNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .semibold)
////        label.backgroundColor = .black
//        return label
//    }()
//
//    private let userMessageLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let userDateLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .light)
//        label.textAlignment = .left
//        label.textColor = .gray
//       return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .systemFill
//        layer.cornerRadius = contentView.frame.size.height/2
//        clipsToBounds = true
//
//        // Subviews
//        contentView.addSubview(userImageView)
//        contentView.addSubview(userNameLabel)
//        contentView.addSubview(userMessageLabel)
//        contentView.addSubview(userDateLabel)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        userImageView.frame = CGRect(x: 10,
//                                     y: 10,
//                                     width: 70,
//                                     height: 70)
//        userNameLabel.frame = CGRect(x: userImageView.right + 10,
//                                     y: 10,
//                                     width: contentView.width - 20 - userImageView.width,
//                                     height: 22)
//        userMessageLabel.frame = CGRect(x: userImageView.right + 10,
//                                        y: userNameLabel.bottom + 5,
//                                        width: contentView.width - 25 - userImageView.width,
//                                        height: 20)
//        userDateLabel.frame = CGRect(x: contentView.right-70,
//                                     y: contentView.top+5,
//                                     width: contentView.width - 30 - userImageView.width,
//                                     height: 20)
//        layer.cornerRadius = contentView.frame.size.height/2
//        clipsToBounds = true
//    }
//
//    public func configure(with model: Conversation) {
//        userMessageLabel.text = model.latestMessage.text
//        userNameLabel.text = model.name
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        formatter.locale = .autoupdatingCurrent
//        formatter.dateFormat = "dd/MM/yyyy"
//
//        let currentDateString = formatter.string(from: Date.now())
//        let currentDate = formatter.date(from: model.latestMessage.date)
//        if model.latestMessage.date == currentDateString {
//            userDateLabel.text = "Today"
//        }
//        else if currentDate?.isYesterday == true {
//            self.userDateLabel.text = "Yesterday"
//        }
//        else {
//            self.userDateLabel.text = model.latestMessage.date
//        }
////        var dateString = model.latestMessage.date.replacingOccurrences(of: ",", with: " ")
////        dateString = dateString.replacingOccurrences(of: "202", with: "                                        ")
////        userDateLabel.text = dateString
//
//        let path = "images/\(model.otherUserEmail)_profile_picture.png"
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//
//                DispatchQueue.main.async {
//                    self?.userImageView.sd_setImage(with: url, completed: nil)
//                }
//
//            case .failure(let error):
//                print("Failed to get image url: \(error)")
//            }
//        })
//    }
//
//}
