//
//  DeedsCollectionViewCell.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 04/01/2021.
//

import UIKit
import NotificationCenter

class DeedsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var backgroundColourView: UIView!
    @IBOutlet weak var deedsTitleLabel: UILabel!
    
    
    // MY CODE
    
        

    var deed: Deed! {
        didSet {
            self.updateUI()
        }
    }
    
    
    // Remember to update to download image from URL
    
    func updateUI() {
        if let deed = deed {
            featuredImageView.image = deed.featuredImage
            deedsTitleLabel.text = deed.title
            backgroundColourView.backgroundColor = deed.colour
        }
        else {
            featuredImageView.image = nil
            deedsTitleLabel.text = nil
            backgroundColourView.backgroundColor = nil
        }
        
        backgroundColourView.layer.cornerRadius = 10.0
        backgroundColourView.layer.masksToBounds = true
        featuredImageView.layer.cornerRadius = 10.0
        featuredImageView.layer.masksToBounds = true
        
    }
        
}
