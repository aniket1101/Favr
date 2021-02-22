//
//  Expandable.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 31/01/2021.
//

import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}
