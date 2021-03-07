//
//  favrsCollectionViewCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 22/02/2021.
//

import UIKit

class favrsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "favrsCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sky")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.clipsToBounds = true
        return view
    }()
    
    private let favrLabel: UILabel = {
        let label = UILabel()
        label.text = "Travelling Around the World"
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .heavy)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(background)
        contentView.addSubview(favrLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
        background.frame = contentView.bounds
        favrLabel.frame = CGRect(x: 12,
                                 y: 20,
                                 width: contentView.width-24,
                                 height: contentView.height-40)
        
        contentView.layer.cornerRadius = 10.0
        imageView.layer.cornerRadius = 10.0
        background.layer.cornerRadius = 10.0
    }
    
    public func configure(with model: Favr) {
        favrLabel.text = model.title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        favrLabel.text = nil
    }
    
}
