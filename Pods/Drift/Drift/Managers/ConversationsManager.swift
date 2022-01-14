//
//  ConversationsManager.swift
//  Drift
//
//  Created by Brian McDonald on 08/06/2017.
//  Copyright © 2017 Drift. All rights reserved.
//

import Foundation

class ConversationsManager {
    
    class func checkForConversations(userId: Int64) {
        DriftAPIManager.getEnrichedConversations(userId) { (result) in
            switch result {
            case .success(let conversations):
                let conversationsToShow: [EnrichedConversation]
                if DriftManager.sharedInstance.shouldShowAutomatedMessages {
                    //Show conversations with unread > 0
                    conversationsToShow = conversations.filter({$0.unreadMessages > 0})
                } else {
                    //Show unread conversations that we have a status for (Remove automated messages)
                    conversationsToShow = conversations.filter({ $0.unreadMessages > 0 && $0.conversation.status != nil })
                }
                PresentationManager.sharedInstance.didRecieveNewMessages(conversationsToShow)
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }
    
    class func markMessageAsRead(_ messageId: Int64) {
        DriftAPIManager.markConversationAsRead(messageId: messageId) { (result) in
            switch result {
            case .success:
                LoggerManager.log("Successfully marked Message Read: \(messageId)")
            case .failure(let error):
                LoggerManager.didRecieveError(error)
            }
        }
    }

}
