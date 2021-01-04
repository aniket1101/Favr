//
//  CustomMessageFlowLayout.swift
//  Favr
//
//  Created by Aniket Gupta on 12/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

//import Foundation
//import MessageKit
//
//class CustomMessageFlowLayout: MessagesCollectionViewFlowLayout {
//    lazy open var sizeCalculator = CustomMessageSizeCalculator(layout: self)
//
//    override open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
//      let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
//      if case .custom = message.kind {
//        return sizeCalculator
//      }
//      return super.cellSizeCalculatorForItem(at: indexPath);
//    }
//}
