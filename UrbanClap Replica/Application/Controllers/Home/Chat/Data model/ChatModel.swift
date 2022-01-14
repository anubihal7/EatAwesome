
//

import Foundation

// MARK: - ChatListModel



struct ChatListModel:Codable
{
    let id, senderId, groupId, actualMessageId: String?
    let messageType, type, status, sentAt: Int?
    let message, media, thumbnail, senderName: String?
    let senderImage: String?
    //selectUser for createGroup
    var selectedUser = false
    let messagesStatuses: [MessagesStatus]?
    let actualMessage: ActualMessage?
    let groupName :String?
    let groupIcon :String?
    var groupMember1 = [groupMember]()
    let createdBy : String?
    let  adminId : String?
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? String
        self.senderId = dict["senderId"] as? String
        self.groupId = dict["groupId"] as? String
        self.actualMessage = dict["actualMessage"] as? ActualMessage
        self.actualMessageId = dict["actualMessageId"] as? String
        self.messageType = dict["messageType"] as? Int
        self.type = dict["type"] as? Int
        self.status = dict["status"] as? Int
        self.sentAt = dict["sentAt"] as? Int
        self.message = dict["message"] as? String
        self.media = dict["media"] as? String
        self.thumbnail = dict["thumbnail"] as? String
        self.senderName = dict["senderName"] as? String
        self.senderImage = dict["senderImage"] as? String
        self.selectedUser = (dict["selectedUser"] != nil)
        self.messagesStatuses = dict["messagesStatuses"] as? [MessagesStatus]
        self.groupName = dict["groupName"] as? String
        self.groupIcon = dict["groupIcon"] as? String
        self.createdBy = dict["createdBy"] as? String
        self.adminId = dict["adminId"] as? String
        
        if let arrGroupMember = dict["groupMember"] as? [[String:Any]]{
            self.groupMember1.removeAll()
            _ = arrGroupMember.map({ (dict) in
                let model = groupMember.init(dict: dict)
                self.groupMember1.append(model)
            })
        }
        
        
        
//        self.groupMember = dict["groupMember"] as? [groupMember]
    }
}
//MARK:- GroupMember
struct groupMember: Codable
{
    let userId: String?
    var isSelected = false

   init(dict: [String:Any])
   {
    self.userId = dict["userId"] as? String
    self.isSelected = (dict["isSelected"] != nil)
    }
}

// MARK: - ActualMessage
struct ActualMessage: Codable {
}

// MARK: - MessagesStatus
struct MessagesStatus: Codable {
    let deliveredAt, readAt: Int?
    let userId, image, userName: String?

  init(dict: [String:Any]) {
    self.deliveredAt = dict["deliveredAt"] as? Int
    self.readAt = dict["readAt"] as? Int
    self.userId = dict["userId"] as? String
      self.image = dict["image"] as? String
      self.userName = dict["userName"] as? String
    }
    
}
