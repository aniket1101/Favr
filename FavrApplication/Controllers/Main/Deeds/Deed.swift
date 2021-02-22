//
//  Deed.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 04/01/2021.
//

import UIKit

class Deed {
    
    var title = ""
    var featuredImage: UIImage
    var colour: UIColor
    
    init(title: String, featuredImage: UIImage, colour: UIColor) {
        self.title = title
        self.featuredImage = featuredImage
        self.colour = colour
    }
    
    static func fetchDeeds() -> [Deed] {
        return [
        
            Deed(title: "Help out your neighbours", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Deed(title: "Catch up with an old friend", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Deed(title: "Take out the rubbish for your house", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Deed(title: "Plant something", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Deed(title: "Exercise for 20 minutes", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Deed(title: "Put some music on and dance", featuredImage: UIImage(named: "sky")!, colour: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            
        ]
    }
    
}
