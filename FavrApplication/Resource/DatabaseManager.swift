//
//  DatabaseManager.swift
//  Favr
//
//  Created by Aniket Gupta on 20/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import Foundation
import FirebaseDatabase
//import MessageKit
import AVKit
import CoreLocation
import Firebase

/// Manager object to read and write data to write to Firebase data
final class DatabaseManager {
    
    /// Shared instance of class
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress:String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

extension DatabaseManager {
    
    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("Users").child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

// MARK: - Account Management

extension DatabaseManager {
    
    /// Checks  if user exists for given email
    /// Parameters
    /// - `email`:            Target email to be checked
    /// - `completion`:    Async closure to return with result
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child("Users").child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
        
    }
    
    /// Inserts new user to database
    
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
        
//        database.child("Users").child(uid).setValue(<#T##value: Any?##Any?#>)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "dd/MM/yyyy"
        
        database.child("Users").child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "name": user.firstName + " " + user.lastName,
            "Display Name": user.firstName + " " + user.lastName,
            "Status": "Hi there, I'm using Favr!",
            "points": 0,
            "streaks": 0,
            "totalDeeds": 0,
            "lastDeed": formatter.string(from: Date.past()),
            "email": user.emailAddress,
            "onboardingComplete": "false",
            "moderator": "false",
            "conversations": [
            
            ],
            "completedDeeds": [
            
            ],
            "journals": [
            
            ]
        ], withCompletionBlock: { [weak self] error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Failed to write to database")
                completion(false)
                return
            }
            
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // Append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.emailAddress,
                    ]
                    usersCollection.append(newElement)
                    
                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
                else {
                    // Create array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.emailAddress
                        ]
                    ]
                    
                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
            })
        })
    }
    
    /// Gets all users from database
    public func getAllUsers(completion: @escaping(Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means _ failed"
            }
        }
    }
}

// MARK: - Sending messages / conversations

extension DatabaseManager {
    
//    otherUserUid: String, 
    
    /// Creates a new conversation with target user email and first message sent
//    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
//        let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
//            return
//        }
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
//
//        let ref = database.child("Users").child("\(safeEmail)")
//
////        let currentUid = (Auth.auth().currentUser?.uid)!
////        let Uidref = database.child(currentUid)
//
//        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            guard var userNode = snapshot.value as? [String: Any] else {
//                completion(false)
//                print("User not found")
//                return
//            }
//
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .medium
//            formatter.locale = .autoupdatingCurrent
//            formatter.dateFormat = "dd/MM/yyyy"
//
//            let messageDate = firstMessage.sentDate
//            let dateString = formatter.string(from: messageDate)
//
//            var message = ""
//
//            switch firstMessage.kind {
//
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .custom(_):
//                break
//            case .linkPreview(_):
//                break
//            }
//
//            let conversationId = "conversation_\(firstMessage.messageId)"
//
//            let newConversationData: [String: Any] = [
//                "id": conversationId,
//                "other_user_email": otherUserEmail,
////                "other_user_uid": otherUserUid,
//                "name": name,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//
//                ]
//
//            ]
//
//            let recipient_newConversationData: [String: Any] = [
//                "id": conversationId,
//                "other_user_email": safeEmail,
////                "other_user_uid": otherUserUid,
//                "name": currentName,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//
//                ]
//            ]
//            // Update recipient conversation entry
//
////            self?.database.child("\(otherUserUid)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
////                if var conversations = snapshot.value as? [[String: Any]] {
////                    // Append
////                    conversations.append(recipient_newConversationData)
////                    self?.database.child("\(otherUserUid)/conversations").setValue(conversations)
////
////                }
////                else {
////                    // Create
////                    self?.database.child("\(otherUserUid)/conversations").setValue([recipient_newConversationData])
////                }
////            })
//
//            self?.database.child("Users").child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//                if var conversations = snapshot.value as? [[String: Any]] {
//                    // Append
//                    conversations.append(recipient_newConversationData)
//                    self?.database.child("Users").child("\(otherUserEmail)/conversations").setValue(conversations)
//
//                }
//                else {
//                    // Create
//                    self?.database.child("Users").child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
//                }
//            })
//
//            // Update current user conversation entry
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//                // Conversation array exists for current user
//                // You should append
//
//                conversations.append(newConversationData)
//                userNode["conversations"] = conversations
//                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//
//                    self?.finishCreatingConversation(name: name,
//                                                     conversationID: conversationId,
//                                                     firstMessage: firstMessage,
//                                                     completion: completion)
//                })
//            }
//            else {
//                // Conversations array does NOT exist
//                // Create it
//                userNode["conversations"] = [
//                    newConversationData
//                ]
//
//                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
//                guard error == nil else {
//                    completion(false)
//                    return
//                    }
//                    self?.finishCreatingConversation(name: name,
//                                                     conversationID: conversationId,
//                                                     firstMessage: firstMessage,
//                                                     completion: completion)
//                })
//            }
//        })
//    }
//
//    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
////        {
////            "id": String,
////            "type":text, photo, VideoPlayerViewController,
////            "content": String,
////            "date": Date(),
////            "sender_email": String,
////            "isRead": true/false,
////        }
//
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        formatter.locale = .autoupdatingCurrent
//        formatter.dateFormat = "dd/MM/yyyy"
//
//        let messageDate = firstMessage.sentDate
//        let dateString = formatter.string(from: messageDate)
//
//        var message = ""
//        switch firstMessage.kind {
//        case .text(let messageText):
//            message = messageText
//        case .attributedText(_):
//            break
//        case .photo(_):
//            break
//        case .video(_):
//            break
//        case .location(_):
//            break
//        case .emoji(_):
//            break
//        case .audio(_):
//            break
//        case .contact(_):
//            break
//        case .custom(_):
//            break
//        case .linkPreview(_):
//            break
//        }
//
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }
//
//        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
////        let currentUserUid = Auth.auth().currentUser?.uid
//
//        let collectionMessage: [String: Any] = [
//            "id": firstMessage.messageId,
//            "type": firstMessage.kind.messageKindString,
//            "content": message,
//            "date": dateString,
//            "sender_email": currentUserEmail,
////            "sender_uid": currentUserUid!,
//            "is_read": false,
//            "name": name
//        ]
//
//        let value: [String: Any] = [
//            "messages": [
//                collectionMessage
//            ]
//        ]
//
//        print("Adding conversation: \(conversationID)")
//
//        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        })
//    }
//
////    uid: String,
//
//    /// Fetches  and returns all conversations for the user with passed in email
//    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
//        database.child("Users").child("\(email)/conversations").observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
////            database.child("\(uid)/conversations").observe(.value, with: { snapshot in
////                guard let value = snapshot.value as? [[String: Any]] else {
////                    completion(.failure(DatabaseError.failedToFetch))
////                    return
////                }
//
//            let conversations: [Conversation] = value.compactMap({ dictionary in
//                guard let conversationId = dictionary["id"] as? String,
//                    let name = dictionary["name"] as? String,
//                    let otherUserEmail = dictionary["other_user_email"] as? String,
////                    let otherUserUid = dictionary["other_user_uid"] as? String,
//                    let latestMessage = dictionary["latest_message"] as? [String: Any],
//                    let date = latestMessage["date"] as? String,
//                    let message = latestMessage["message"] as? String,
//                    let isRead = latestMessage["is_read"] as? Bool else {
//                        return nil
//                }
//
//                let latestMessageObject = LatestMessage(date: date,
//                                                        isRead: isRead,
//                                                        text: message)
//                return Conversation(id: conversationId,
//                                    name: name,
//                                    otherUserEmail: otherUserEmail,
//                                    latestMessage: latestMessageObject)
//
////                return Conversation(id: conversationId,
////                                    name: name,
////                                    otherUserUid: otherUserUid,
////                                    latestMessage: latestMessageObject)
//            })
//
//            completion(.success(conversations))
//        })
//
//    }
    
//    uid: String,
    
    public func getAllJournals(for email: String, completion: @escaping (Result<[Journal], Error>) -> Void) {
        database.child("Users").child("\(email)/journals").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
//            database.child("\(uid)/journals").observe(.value, with: { snapshot in
//                guard let value = snapshot.value as? [[String: Any]] else {
//                    completion(.failure(DatabaseError.failedToFetch))
//                    return
//                }
            
            let journals: [Journal] = value.compactMap({ dictionary in
                guard let title = dictionary["title"] as? String,
                      let journal = dictionary["journal"] as? String,
                      let date = dictionary["date"] as? String else {
                    return nil
                }
                
                return Journal(title: title,
                               journal: journal,
                               date: date)
            })
            
            completion(.success(journals))
            
        })
    }
    
    public func getAllFavrs(completion: @escaping (Result<[Favr], Error>) -> Void) {
        let dataValue = "Admin"
        database.child("\(dataValue)/FavrsTitles").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let favrs: [Favr] = value.compactMap({ dictionary in
                guard let title = dictionary["title"] as? String else {
                    return nil
                }
                
                return Favr(title: title)
            })
            
            completion(.success(favrs))
            
        })
    }
    
    public func getAllCompletedFavrs(for email: String, completion: @escaping (Result<[completedFavr], Error>) -> Void) {
        database.child("Users").child("\(email)/completedFavrs").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let completedFavrs: [completedFavr] = value.compactMap({ dictionary in
                guard let title = dictionary["title"] as? String,
                      let description = dictionary["description"] as? String,
                      let points = dictionary["points"] as? String,
                      let date = dictionary["date"] as? String else {
                    return nil
                }
                
                return completedFavr(title: title,
                                     description: description,
                                     points: points,
                                     date: date)
            })
            
            completion(.success(completedFavrs))
        })
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {

    do {
        let asset = AVURLAsset(url: path , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let timestamp = asset.duration
        print("Timestamp:   \(timestamp)")
        let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
        var thumbnail = UIImage(cgImage: cgImage)
        if thumbnail != UIImage(cgImage: cgImage) {
            thumbnail = UIImage(named: "video_placeholder")!
        }
        return thumbnail
        } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
      }
    }
    
    /// Gets all messages for a given conversation
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//        database.child("\(id)/messages").observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .medium
//            formatter.locale = .autoupdatingCurrent
//            formatter.dateFormat = "dd/MM/yyyy"
//
//            let messages: [Message] = value.compactMap({ dictionary in
//                guard let name = dictionary["name"] as? String,
//                    let isRead = dictionary["is_read"] as? Bool,
//                    let messageID = dictionary["id"] as? String,
//                    let content = dictionary["content"] as? String,
//                    let senderEmail = dictionary["sender_email"] as? String,
////                    let senderUid = dictionary["sender_uid"] as? String,
//                    let type = dictionary["type"] as? String,
//                    let dateString = dictionary["date"] as? String,
//                    let date = formatter.date(from: dateString) else {
//                        return nil
//                }
//
//                var kind: MessageKind?
//                if type == "photo" {
//                    // Photo
//                    guard let imageUrl = URL(string: content),
//                    let placeHolder = UIImage(systemName: "plus") else {
//                        return nil
//                    }
//                    let media = Media(url: imageUrl,
//                                      image: nil,
//                                      placeholderImage: placeHolder,
//                                      size: CGSize(width: 300, height: 300))
//                    kind = .photo(media)
//                }
//
//                else if type == "video" {
//                    // Video
//                    guard let videoUrl = URL(string: content) else {
//                        return nil
//                    }
//
////                    guard let placeHolder = strongself.getThumbnailFrom(path: videoUrl) else {
////                        return nil
////                    }
//
//
//                    guard let placeHolder = UIImage(named: "video_placeholder") else {
//                        return nil
//                    }
//
//                    let media = Media(url: videoUrl,
//                                      image: nil,
//                                      placeholderImage: placeHolder,
//                                      size: CGSize(width: 300, height: 300))
//                    kind = .video(media)
//                }
//
//                else if type == "location" {
//                    let locationComponents = content.components(separatedBy: ",")
//                    guard let longitude = Double(locationComponents[0]),
//                        let latitude = Double(locationComponents[1]) else {
//                        return nil
//                    }
//                    print("Rendering location; long=\(longitude) | lat=\(latitude)")
//                    let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
//                                            size: CGSize(width: 300, height: 300))
//                    kind = .location(location)
//                }
//
//                else {
//                    kind = .text(content)
//                }
//
//                guard let finalKind = kind else {
//                    return nil
//                }
//
//                let sender = Sender(photoURL: "",
//                                    senderId: senderEmail,
//                                    displayName: name)
//
////                let sender = Sender(photoURL: "",
////                                    senderUid: senderUid,
////                                    displayName: name)
//
//                return Message(sender: sender,
//                               messageId: messageID,
//                               sentDate: date,
//                               kind: finalKind)
//            })
//
//            completion(.success(messages))
//        })
//    }
//
////    otherUserUid: String,
//
//    /// Sends a message with target conversation and message
//    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
//        // Add new message to messages
//        // Update sender latest message
//        // Update recipient latest message
//
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }
//
//        let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
//
//        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            guard let strongSelf = self else {
//                return
//            }
//            guard var currentMessages = snapshot.value as? [[String: Any]] else {
//                completion(false)
//                return
//            }
//
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .medium
//            formatter.locale = .autoupdatingCurrent
//            formatter.dateFormat = "dd/MM/yyyy"
//
//            let messageDate = newMessage.sentDate
//            let dateString = formatter.string(from: messageDate)
//
//            var message = ""
//            switch newMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(let mediaItem):
//                if let targetUrlString = mediaItem.url?.absoluteString {
//                message = targetUrlString
//                }
//                break
//            case .video(let mediaItem):
//                if let targetUrlString = mediaItem.url?.absoluteString {
//                message = targetUrlString
//                }
//                break
//            case .location(let locationData):
//                let location = locationData.location
//                message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .custom(_):
//                break
//            case .linkPreview(_):
//                break
//            }
//
//            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//                completion(false)
//                return
//            }
//
//            let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
////            let currentUserUid = Auth.auth().currentUser?.uid
//
//            let newMessageEntry: [String: Any] = [
//                "id": newMessage.messageId,
//                "type": newMessage.kind.messageKindString,
//                "content": message,
//                "date": dateString,
//                "sender_email": currentUserEmail,
////                "sender_uid": currentUserUid,
//                "is_read": false,
//                "name": name
//            ]
//
//            currentMessages.append(newMessageEntry)
//
//            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages, withCompletionBlock: {error, _ in
//                guard error == nil else {
//
//                    completion(false)
//                    return
//                }
//
//                strongSelf.database.child("\(currentUserUid)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                    var databaseEntryConversations = [[String: Any]]()
//                    let updatedValue: [String: Any] = [
//                        "date": dateString,
//                        "is_read": false,
//                        "message": message
//
//                    ]
//                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
//
//                        // We need to create conversation entry
//                        var targetConversation: [String: Any]?
//
//                        var position = 0
//
//                        for conversationDictionary in currentUserConversations {
//                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                targetConversation = conversationDictionary
//                                break
//                            }
//                            position += 1
//                        }
//
//                        if var targetConversation = targetConversation {
//                            targetConversation["latest_message"] = updatedValue
//                            currentUserConversations[position] = targetConversation
//                            databaseEntryConversations = currentUserConversations
//                            }
//                        else {
//                            let newConversationData: [String: Any] = [
//                                "id": conversation,
//                                "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                                "other_user_uid": otherUserUid,
//                                "name": name,
//                                "latest_message": updatedValue
//                            ]
//                            currentUserConversations.append(newConversationData)
//                            databaseEntryConversations = currentUserConversations
//                        }
//                }
//                    else {
//                        let newConversationData: [String: Any] = [
//                            "id": conversation,
//                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                            "other_user_uid": otherUserUid
//                            "name": name,
//                            "latest_message": updatedValue
//                            ]
//                        databaseEntryConversations = [
//                            newConversationData
//                        ]
//                    }
//
//                    strongSelf.database.child("\(currentUserUid)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//
//                        // Update latest message for recipient user
//
//                        strongSelf.database.child("\(otherUserUid)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//
//                            let updatedValue: [String: Any] = [
//                                "date": dateString,
//                                "is_read": false,
//                                "message": message
//
//                            ]
//
//                            var databaseEntryConversations = [[String: Any]]()
//
//                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
//                                return
//                            }
//
//                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
//                                var targetConversation: [String: Any]?
//
//                                var position = 0
//
//                                for conversationDictionary in otherUserConversations {
//                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                        targetConversation = conversationDictionary
//                                        break
//                                    }
//                                    position += 1
//                                }
//
//                                if var targetConversation = targetConversation {
//                                    targetConversation["latest_message"] = updatedValue
//                                    otherUserConversations[position] = targetConversation
//                                    databaseEntryConversations = otherUserConversations
//                                }
//                                else {
//                                    // Failed to find in current collection
//                                    let newConversationData: [String: Any] = [
//                                        "id": conversation,
//                                        "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                                        "other_user_uid": otherUserUid,
//                                        "name": currentName,
//                                        "latest_message": updatedValue
//                                    ]
//                                    otherUserConversations.append(newConversationData)
//                                    databaseEntryConversations = otherUserConversations
//                                }
//
//                            }
//                            else {
//                                // Current collection does not exist
//                                let newConversationData: [String: Any] = [
//                                    "id": conversation,
//                                    "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
//                                    "other_user_uid": otherUserUid,
//                                    "name": currentName,
//                                    "latest_message": updatedValue
//                                ]
//                                databaseEntryConversations = [
//                                    newConversationData
//                                ]
//                            }
//
//
//
//
//                            strongSelf.database.child("\(otherUserUid)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                                guard error == nil else {
//                                    completion(false)
//                                    return
//                                }
//
//                                completion(true)
//                            })
//                        })
//                    })
//                })
//            })
//        })
            
//            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages, withCompletionBlock: {error, _ in
//                guard error == nil else {
//
//                    completion(false)
//                    return
//                }
//
//                strongSelf.database.child("Users").child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                    var databaseEntryConversations = [[String: Any]]()
//                    let updatedValue: [String: Any] = [
//                        "date": dateString,
//                        "is_read": false,
//                        "message": message
//
//                    ]
//                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
//
//                        // We need to create conversation entry
//                        var targetConversation: [String: Any]?
//
//                        var position = 0
//
//                        for conversationDictionary in currentUserConversations {
//                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                targetConversation = conversationDictionary
//                                break
//                            }
//                            position += 1
//                        }
//
//                        if var targetConversation = targetConversation {
//                            targetConversation["latest_message"] = updatedValue
//                            currentUserConversations[position] = targetConversation
//                            databaseEntryConversations = currentUserConversations
//                            }
//                        else {
//                            let newConversationData: [String: Any] = [
//                            "id": conversation,
//                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                            "name": name,
//                            "latest_message": updatedValue
//                            ]
//                            currentUserConversations.append(newConversationData)
//                            databaseEntryConversations = currentUserConversations
//                        }
//                }
//                    else {
//                        let newConversationData: [String: Any] = [
//                            "id": conversation,
//                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                            "name": name,
//                            "latest_message": updatedValue
//                            ]
//                        databaseEntryConversations = [
//                            newConversationData
//                        ]
//                    }
//
//                    strongSelf.database.child("Users").child("\(currentEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//
//                        // Update latest message for recipient user
//
//                        strongSelf.database.child("Users").child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//
//                            let updatedValue: [String: Any] = [
//                                "date": dateString,
//                                "is_read": false,
//                                "message": message
//
//                            ]
//
//                            var databaseEntryConversations = [[String: Any]]()
//
//                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
//                                return
//                            }
//
//                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
//                                var targetConversation: [String: Any]?
//
//                                var position = 0
//
//                                for conversationDictionary in otherUserConversations {
//                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                        targetConversation = conversationDictionary
//                                        break
//                                    }
//                                    position += 1
//                                }
//
//                                if var targetConversation = targetConversation {
//                                    targetConversation["latest_message"] = updatedValue
//                                    otherUserConversations[position] = targetConversation
//                                    databaseEntryConversations = otherUserConversations
//                                }
//                                else {
//                                    // Failed to find in current collection
//                                    let newConversationData: [String: Any] = [
//                                        "id": conversation,
//                                        "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                                        "name": currentName,
//                                        "latest_message": updatedValue
//                                    ]
//                                    otherUserConversations.append(newConversationData)
//                                    databaseEntryConversations = otherUserConversations
//                                }
//
//                            }
//                            else {
//                                // Current collection does not exist
//                                let newConversationData: [String: Any] = [
//                                    "id": conversation,
//                                    "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
//                                    "name": currentName,
//                                    "latest_message": updatedValue
//                                ]
//                                databaseEntryConversations = [
//                                    newConversationData
//                                ]
//                            }
//
//
//
//
//                            strongSelf.database.child("Users").child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                                guard error == nil else {
//                                    completion(false)
//                                    return
//                                }
//
//                                completion(true)
//                            })
//                        })
//                    })
//                })
//            })
//        })
    }
    
//    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//
//        print("Deleting conversation with id: \(conversationId)")
//
//        // Get all conversations for the current user
//        // Delete conversation in collection with the target ID
//        // Reset those conversations for the user in database
//        let ref = database.child("Users").child("\(safeEmail)/conversations")
////        let uid = Auth.auth().currentUser?.uid
////        let uidRef = database.child("\(uid)/conversations")
//
//
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            if var conversations = snapshot.value as? [[String: Any]] {
//                var positionToRemove = 0
//                for conversation in conversations {
//                    if let id = conversation["id"] as? String,
//                        id == conversationId {
//                        print("Found conversation to be deleted")
//                        break
//                    }
//                    positionToRemove += 1
//                }
//
//                conversations.remove(at: positionToRemove)
//                ref.setValue(conversations, withCompletionBlock: { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        print("Failed to write new conversation array")
//                        return
//                    }
//                    print("Deleted conversation")
//                    completion(true)
//                })
//            }
//        })
//    }
////    targetRecipientUid: String,
//    public func conversationExists(with targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
//        let safeRecipientEmail = DatabaseManager.safeEmail(emailAddress: targetRecipientEmail)
//        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: senderEmail)
////        let safeSenderUid = Auth.auth().currentUser?.uid
////        database.child("\(safeSenderUid)/conversations").observeSingleEvent(of: .value, with: { snapshot in
////            guard let collection = snapshot.value as? [[String: Any]] else {
////                completion(.failure(DatabaseError.failedToFetch))
////                return
////            }
//
//        database.child("Users").child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//            guard let collection = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            // Iterate and find conversation with target sender
//            if let conversation = collection.first(where: {
//                guard let targetSenderEmail = $0["other_user_email"] as? String else {
//                    return false
//                }
////                guard let targetSenderUid = $0["other_user_uid"] as? String else {
////                    return false
////                }
////                return safeSenderUid == targetSenderUid
//                return safeSenderEmail == targetSenderEmail
//            }) {
//                // Get id
//                guard let id = conversation["id"] as? String else {
//                    completion(.failure(DatabaseError.failedToFetch))
//                    return
//                }
//                completion(.success(id))
//                return
//            }
//
//            completion(.failure(DatabaseError.failedToFetch))
//            return
//        })
//    }
    
//}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}

