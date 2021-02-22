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
        label.text = "22 February 2021"
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
        textView.frame = CGRect(x: 10,
                                y: titleLabel.bottom + 5,
                                width: contentView.frame.size.width-20,
                                height: contentView.frame.size.height-70)
        dateLabel.frame = CGRect(x: 10,
                                 y: contentView.bottom-24,
                                 width: contentView.width-20,
                                 height: 14)
        
    }
    
    public func configure(titleLabelText: String, textViewText: String, dateText: String) {
        titleLabel.text = titleLabelText
        textView.text = textViewText
        dateLabel.text = dateText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        textView.text = nil
        dateLabel.text = nil
    }
    
}
