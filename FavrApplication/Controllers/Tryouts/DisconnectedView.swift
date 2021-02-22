//
//  DisconnectedView.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 01/02/2021.
//

import UIKit

class DisconnectedView: UIView {
    
    private let DisconnectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wifi.exclamationmark")
        imageView.tintColor = .systemWhite
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 40).isActive = true

        
        addSubview(DisconnectedImage)
        DisconnectedImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        DisconnectedImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
