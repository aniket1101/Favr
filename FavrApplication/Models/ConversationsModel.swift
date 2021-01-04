//
//  ConversationsModel.swift
//  Favr
//
//  Created by Aniket Gupta on 27/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let isRead: Bool
    let text: String
}
