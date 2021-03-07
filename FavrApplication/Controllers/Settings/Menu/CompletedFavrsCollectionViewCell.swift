//
//  CompletedFavrsCollectionViewCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 25/02/2021.
//

import UIKit

class CompletedFavrsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "completedFavrCollectionViewCell"

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
//        label.backgroundColor = .systemFill
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
//        label.backgroundColor = .systemFill
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .label
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
//        label.backgroundColor = .systemFill
        return label
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Montserrat-Regular", size: 14)
        view.autocorrectionType = .yes
        view.backgroundColor = .secondarySystemGroupedBackground
        view.isEditable = false
        view.isSelectable = false
        view.isUserInteractionEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//         Cell Design
                
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(pointsLabel)
        
        contentView.layer.cornerRadius = 20.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 10,
                                  width: contentView.width-20,
                                  height: 35)
        titleLabel.sizeToFit()
        pointsLabel.frame = CGRect(x: 10,
                                   y: titleLabel.bottom,
                                   width: 80,
                                   height: 14)
        textView.frame = CGRect(x: 10,
                                y: pointsLabel.bottom + 5,
                                width: contentView.frame.size.width-20,
                                height: contentView.frame.size.height-70)
        dateLabel.frame = CGRect(x: 20,
                                 y: contentView.bottom-30,
                                 width: contentView.width-40,
                                 height: 14)
        
        contentView.layer.cornerRadius = 20.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func configure(with model: completedFavr) {
        titleLabel.text = model.title
        textView.text = model.description
        pointsLabel.text = "\(model.points) Points"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "dd/MM/yyyy"
        
        let currentDateString = formatter.string(from: Date.now())
        let currentDate = formatter.date(from: model.date)
        if model.date == currentDateString {
            dateLabel.text = "Today"
        }
        else if currentDate?.isYesterday == true {
            self.dateLabel.text = "Yesterday"
        }
        else {
            self.dateLabel.text = model.date
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        textView.text = nil
        dateLabel.text = nil
        pointsLabel.text = nil
    }

    
}
