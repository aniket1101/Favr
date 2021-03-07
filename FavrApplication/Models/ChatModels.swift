//
//  ChatModels.swift
//  Favr
//
//  Created by Aniket Gupta on 27/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

//import Foundation
//import CoreLocation
//import MessageKit
//
//struct Message: MessageType {
//    public var sender: SenderType
//    public var messageId: String
//    public var sentDate: Date
//    public var kind: MessageKind
//}
//
//extension MessageKind {
//    var messageKindString: String {
//        switch self {
//        case .text(_):
//            return "text"
//        case .attributedText(_):
//            return "attributed_text"
//        case .photo(_):
//            return "photo"
//        case .video(_):
//            return "video"
//        case .location(_):
//            return "location"
//        case .emoji(_):
//            return "emoji"
//        case .audio(_):
//            return "audio"
//        case .contact(_):
//            return "contact"
//        case .custom(_):
//            return "custom"
//        case .linkPreview(_):
//            return "link_preview"
//        }
//    }
//}
//
//struct Sender: SenderType {
//    public var photoURL: String
//    public var senderId: String
//    public var displayName: String
//}
//
////struct Sender: SenderType {
////    public var photoURL: String
////    public var senderUid: String
////    public var displayName: String
////}
//
//struct Media: MediaItem {
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//}
//
//struct Location: LocationItem {
//    var location: CLLocation
//    var size: CGSize
//}
