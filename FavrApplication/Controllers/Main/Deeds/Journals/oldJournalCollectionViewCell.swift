//
//  oldJournalCollectionViewCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 21/02/2021.
//

import UIKit

class oldJournalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "journalCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.backgroundColor = .tertiarySystemGroupedBackground
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .label
        label.textAlignment = .right
        label.backgroundColor = .tertiarySystemGroupedBackground
        return label
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.text = "test"
        view.font = UIFont(name: "Montserrat-Regular", size: 14)
        view.autocorrectionType = .yes
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.isEditable = false
        view.isSelectable = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //         Cell Design
        
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        contentView.layer.cornerRadius = 20.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.masksToBounds = true
        
        //Adding a Long press event to the container view
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.08
        lpgr.delaysTouchesBegan = false
        contentView.addGestureRecognizer(lpgr)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state.rawValue == 1 {
            highlight(true)
        }
        else {
            highlight(false)
        }
        
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 10,
                                  width: contentView.width-20,
                                  height: 35)
        titleLabel.sizeToFit()
        textView.frame = CGRect(x: 10,
                                y: titleLabel.bottom + 5,
                                width: contentView.frame.size.width-20,
                                height: contentView.frame.size.height-70)
        dateLabel.frame = CGRect(x: 10,
                                 y: contentView.bottom-24,
                                 width: contentView.width-20,
                                 height: 14)
        
    }
    
    public func configure(with model: Journal) {
        titleLabel.text = model.title
        textView.text = model.journal
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
    }
    
    func highlight(_ touched: Bool) {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 5.0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = touched ? .init(scaleX: 0.95, y: 0.95) : .identity
            }, completion: nil)
        }
    
}
