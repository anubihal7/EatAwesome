
//

import UIKit
import SocketIO
//import MessageKit
import JSQMessagesViewController
import MobileCoreServices
import JJFloatingActionButton
import AVFoundation
import AVKit
import WebKit
import Photos
import NVActivityIndicatorView
import Foundation

class ChatVC: JSQMessagesViewController{
    
    //MARK:- Outlet and variables
    @IBOutlet var tbleViewChat: UITableView!
    @IBOutlet var txtViewMessage: UITextView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var viewAttachment: UIView!
    
    var messages = [JSQMessage]()
    var manager:SocketManager!
    var socketIOClient: SocketIOClient!
    var groupId:String?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var selectedGroupId:String?
    var imagePicker = UIImagePickerController()
    var imagePickerDelegate:UIImagePickerDelegate?
    var imageExtension:String?
    var isFirstTime = false
    var tapped_image = false
    var isImageSelected = false
    var thumbImage:UIImage?
    var pdfImage:UIImage?
    var groupName:String?
    var createGroupId :String?
    public var selcetedSenderId : String?
    public var chatHistoryData = [ChatListModel]()
    var createdById : String?
    var groupMembers = [groupMember]()
    var newGroupId = ""
    var localDate:String?
    var messageTime:Date?
    var joinRoomFirstTime = false
    var preSelectedValues : [String] = []
    var orderId = ""
    var GoingForImage = false
    
    //MARK:- lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConnectToSocket()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let btnDrawer = UIBarButtonItem(image: UIImage(named: "btn_back_black"), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.leftBarButtonItem  = btnDrawer
        //
        //             btnDrawer.target = self.revealViewController()
        //               btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        //               self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //               self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        senderId = AppDefaults.shared.userID
        senderDisplayName = senderId
        
        
        //  self.inputToolbar.preferredDefaultHeight = 44
    }
    @objc func addTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tapped_image = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Chat with Admin"
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        if(self.GoingForImage == true)
        {
            self.GoingForImage = false
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = true
            joinRoomFirstTime = false
            self.socketIOClient.emit("leaveRoom", ["authToken":AppDefaults.shared.userJWT_Token,"groupId":self.newGroupId])
            socketIOClient.disconnect()
            NotificationCenter.default.removeObserver(self)
            chat_HistoryData.removeAll()
            self.navigationController?.isNavigationBarHidden = true
        }
        
        
        // socketIOClient.disconnect()
        //        DispatchQueue.main.async
        //            {
        
        //        }
        
    }
    
    func showOptions() {
        let pickerData : [[String:String]] = [
            [
                "value":"en",
                "display":"I have not recieved my order"
            ],
            [
                "value":"ar",
                "display":"I have packaging or spillage issue with my order"
            ],
            [
                "value":"fr",
                "display":"Items are missing or incorrect in my order"
            ],
            [
                "value":"fr",
                "display":"I have food taste, quality or quantity issue with my order"
            ],
            [
                "value":"fr",
                "display":"Connect to an agent"
            ]
        ]
        
        
        
        MultiPickerDialog().show(title: "Hi \(AppDefaults.shared.userName), how can we help you today?",doneButtonTitle:"Confirm", cancelButtonTitle:"Cancel" ,options: pickerData, selected:  preSelectedValues) {
            values -> Void in
            DispatchQueue.main.async {
                print("callBack \(values)")
                // self.preSelectedValues = values.compactMap {return $0["value"]}
                let displayValues = values.compactMap {return $0["display"]}
                self.inputToolbar.contentView.textView.text = "\(displayValues.joined(separator: ", "))"
                self.inputToolbar.toggleSendButtonEnabled()
            }
            
            //self.txtViewMessage.isUserInteractionEnabled = false
        }
    }
    
    
    
    
    
    //MARK:- ConnectSocket
    //"http://51.79.40.224:9070/"
    func ConnectToSocket() {
        manager = SocketManager(socketURL: URL(string: APIAddress.Socket_Url)!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            //            self.socketIOClient.emit("joinRoom", ["authToken":UserDefault.authToken,"receiverId":self.selcetedSenderId])
            print(data)
            print(self.joinRoomFirstTime)
            if self.joinRoomFirstTime == false
            {
                self.socketIOClient.emit("joinRoom", ["authToken":AppDefaults.shared.userJWT_Token,"receiverId":"89624900-a974-4849-9048-c32d6bed220a","orderId" : self.orderId ])
            }
        }
        socketIOClient.on("leaveRoom"){data, ack in
            print(data)
        }
        
        
        socketIOClient.on("joinRoom") { (data, ack) in
          //  self.StartIndicator(message: kLoading)
            self.joinRoomFirstTime = true
            print(data[0])
            let dic = data[0] as? [String : Any]
            self.newGroupId = dic?["groupId"] as? String ?? ""
            if self.isFirstTime == false
            {
                self.socketIOClient.emit("chatHistory", ["authToken":AppDefaults.shared.userJWT_Token,"groupId":self.newGroupId])
            }
        }
        
        socketIOClient.on("newMessage") { (data, ack) in
            print(data)
            var messageId:String?
            if data.count > 0
            {
                for listData in data
                {
                    if let model = listData as? [String:Any]
                    {
                        let newModel = ChatListModel(dict: model)
                        print(newModel)
                        //chat_HistoryData.append(newModel)
                        self.messageTime = self.converTime(time: newModel.sentAt)
                        messageId =  newModel["id"] as? String
                        let media =  newModel["media"] as? String
                        if media!.isEmpty
                        {
                            if(newModel["senderId"] as? String == AppDefaults.shared.userID)
                            {
                                if let message = JSQMessage(senderId: newModel["senderId"] as? String, senderDisplayName:  newModel["senderName"] as? String, date: self.messageTime , text: newModel["message"]  as? String)
                                {
                                    self.messages.append(message)
                                }
                            }
                            else
                            {
                                self.txtViewMessage.isUserInteractionEnabled = true
                                if let message = JSQMessage(senderId: newModel["adminId"] as? String, senderDisplayName: "Admin",date: self.messageTime , text: newModel["message"]  as? String)
                                {
                                    self.messages.append(message)
                                }
                                
                            }
                        }
                        else
                        {
                            let media = newModel["media"] as! String
                            var fullUrl = ""
                            if media != "" {
                                fullUrl = APIAddress.BASE_URL + (media)
                            }
                            else{
                                fullUrl =   "\(APIAddress.BASE_URL)users/1594969818876_5465.png"
                            }
                            let url = URL(string:(fullUrl))
                            
                            if newModel["type"] as! Int == 2
                            {
                                
                                let media = newModel["media"] as! String
                                var fullUrl = ""
                                if media != "" {
                                    fullUrl = APIAddress.BASE_URL + (media)
                                }
                                else{
                                    fullUrl =   "\(APIAddress.BASE_URL)users/1594969818876_5465.png"
                                }
                                let url = URL(string:(fullUrl))
                                
                                
                                if let data = try? Data(contentsOf: url!)
                                {
                                    if let image: UIImage = UIImage(data: data)
                                    {
                                        if let mediaItem = JSQPhotoMediaItem(image: nil){
                                            if(newModel["senderId"] as? String == AppDefaults.shared.userID)
                                            {
                                                mediaItem.appliesMediaViewMaskAsOutgoing = true
                                            }
                                            else{
                                                self.txtViewMessage.isUserInteractionEnabled = true
                                                mediaItem.appliesMediaViewMaskAsOutgoing = false
                                            }
                                            mediaItem.image = UIImage(data: (image).jpegData(compressionQuality: 0.5)!)
                                            
                                            if(newModel["senderId"] as? String == AppDefaults.shared.userID)
                                            {
                                                let sendMessage = JSQMessage(senderId: newModel["senderId"] as? String, senderDisplayName: newModel["senderName"] as? String, date: self.messageTime, media: mediaItem)
                                                self.messages.append(sendMessage!) }
                                            else{
                                                if let message = JSQMessage(senderId: newModel["adminId"] as? String, senderDisplayName: "Admin", date: self.messageTime, media: mediaItem)
                                                {
                                                    self.messages.append(message)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else if(newModel["type"] as! Int == 7)
                            {
                                let media = newModel["media"] as! String
                                var fullMediaUrl = ""
                                if media != "" {
                                    fullMediaUrl = APIAddress.BASE_URL + (media)
                                }
                                else
                                {
                                    fullMediaUrl =   "\(APIAddress.BASE_URL)users/1594969818876_5465.png"
                                }
                                let mediaurl = URL(string:(fullMediaUrl))
                                if let url = mediaurl{
                                    let fileExtension =  url.pathExtension
                                    if (fileExtension == "pdf")
                                    {
                                        self.pdfImage = UIImage(named: "pdf")
                                    }
                                    else{
                                        self.pdfImage = UIImage(named: "worddoc")
                                        
                                    }
                                }
                                if let mediaItem = JSQPhotoMediaItem(image: self.pdfImage){
                                    if(newModel["senderId"] as? String == AppDefaults.shared.userID)
                                    {
                                        mediaItem.appliesMediaViewMaskAsOutgoing = true
                                    }
                                    else{
                                        self.txtViewMessage.isUserInteractionEnabled = true
                                        mediaItem.appliesMediaViewMaskAsOutgoing = false
                                    }
                                    
                                    mediaItem.videoUrl = fullMediaUrl
                                    let sendMessage = JSQMessage(senderId: newModel["senderId"] as? String, displayName: newModel["senderName"] as? String, media: mediaItem)
                                    self.messages.append(sendMessage!)
                                }
                            }
                            else
                            {
                                let thumbnail = newModel["thumbnail"] as! String
                                let thumbnailUrl = APIAddress.BASE_URL + (thumbnail)
                                let _url = URL(string:(thumbnailUrl))
                                
                                if let data = try? Data(contentsOf: _url!)
                                {
                                    
                                    if let image: UIImage = UIImage(data: data)
                                    {
                                        self.thumbImage = image
                                    }
                                }
                                if let createdthumb = self.thumbImage
                                {
                                    let mediaItem = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true, thumbnailImage: createdthumb)
                                    mediaItem?.thumbnailImage = createdthumb
                                    if(newModel["senderId"] as? String == AppDefaults.shared.userID)
                                    {
                                        mediaItem?.appliesMediaViewMaskAsOutgoing = true
                                    }
                                    else{
                                        mediaItem?.appliesMediaViewMaskAsOutgoing = false
                                    }
                                    let sendMessage = JSQMessage(senderId: newModel["senderId"] as? String, displayName: newModel["senderName"] as? String, media: mediaItem)
                                    self.messages.append(sendMessage!)
                                }
                            }
                            
                        }
                        
                    }
                }
            }
            self.finishSendingMessage(animated: true)
            self.automaticallyScrollsToMostRecentMessage = true
            self.collectionView?.reloadData()
            self.collectionView?.layoutIfNeeded()
            
            self.socketIOClient.emit("deliveredMessage", ["authToken":AppDefaults.shared.userJWT_Token,"messageId":messageId,"groupId":self.newGroupId])
            
        }
        
        socketIOClient.on("deliveredMessage"){data, ack in
            print(data)
        }
        socketIOClient.on("readMessage")
        { (data, ack) in
            
            print(data)
        }
        
        socketIOClient.on("chatHistory") { (chatHistory, ack) in
            self.chatHistoryData.removeAll()
            print(chatHistory.count)
            
            if chatHistory.count > 0
            {
                
                
                for listData in chatHistory
                {
                    
                    if let model = listData as? [[String:Any]]{
                        if model.count > 0
                        {
                            for listChat in model
                            {
                                let newModel = ChatListModel(dict: listChat)
                                self.chatHistoryData.append(newModel)
                                self.isFirstTime = true
                                self.setView(Model : newModel)
                                self.StopIndicator()
                            }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                self.StopIndicator()
                                self.isFirstTime = true
                                self.showOptions()
                            }
                            
                        }
                        
                    }
                    else{
                        self.isFirstTime = true
                        self.showOptions()
                        self.StopIndicator()
                        return
                    }
                }
                
                
                // inputToolbar.contentView.leftBarButtonItem = nil
                self.incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: korangeTheme)
                
                self.outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: kpurpleTheme)
                
                self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
                self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
                
                self.automaticallyScrollsToMostRecentMessage = true
                
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
                
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
                
            }
            else{
                self.isFirstTime = true
                self.StopIndicator()
                self.showOptions()
            }
            
            
        }
        
        socketIOClient.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
        }
        socketIOClient.connect()
    }
    //MARK:- other functions
    func readMessage()
    {
        if chatHistoryData.count > 0
        {
            for listData in chatHistoryData
            {
                socketIOClient.emit("readMessage", ["authToken":AppDefaults.shared.userJWT_Token,"messageId":listData["id"],"groupId":self.selectedGroupId ?? ""])
            }
        }
    }
    
    
    
    func setView(Model : ChatListModel)
    {
        
        
        let listData = Model
        
        
        if self.chatHistoryData.count > 0
        {
            
            // for listData in self.chatHistoryData
            // {
            let type = listData.type
            // self.title = listData.senderName
            messageTime = converTime(time: listData.sentAt)
            
            
            //textmessage
            if (type == 1)
            {
                print(listData)
                
                if(listData.senderId  == AppDefaults.shared.userID)
                {
                    if listData.senderName != nil {
                        if listData.senderName != "" {
                            if let message = JSQMessage(senderId: AppDefaults.shared.userID, senderDisplayName: listData.senderName ,date: messageTime , text: listData.message)
                            {
                                
                                
                                self.messages.append(message)
                            }
                        }
                    }
                        
                    else{
                        if let message = JSQMessage(senderId: AppDefaults.shared.userID, senderDisplayName: "Guest User",  date: messageTime ,text: listData.message)
                        {
                            self.messages.append(message)
                        }
                    }
                }
                else{
                    
                    
                    if let message = JSQMessage(senderId: listData.adminId , senderDisplayName: "Admin",date: messageTime , text: listData.message)
                    {
                        self.messages.append(message)
                    }
                    
                }
                
                
            }
                
                //imageMessage
            else if (type == 2)
            {
                let media = listData.media
                print(media)
                var fullUrl = ""
                if media != "" {
                    fullUrl = APIAddress.BASE_URL + (media!)
                }
                else{
                    fullUrl =   "\(APIAddress.BASE_URL)users/1594969818876_5465.png"
                }
                let url = URL(string:(fullUrl))
                
                if let data = try? Data(contentsOf: url!)
                {
                    if let image: UIImage = UIImage(data: data)
                    {
                        if let mediaItem = JSQPhotoMediaItem(image: image){
                            if(listData.senderId == AppDefaults.shared.userID)
                            {
                                mediaItem.appliesMediaViewMaskAsOutgoing = true
                                if listData.senderName != nil {
                                    
                                    let sendMessage = JSQMessage(senderId:  listData.senderId, senderDisplayName: listData.senderName , date: messageTime , media:mediaItem)
                                    
                                    self.messages.append(sendMessage!) }
                                else{
                                    let sendMessage = JSQMessage(senderId:  listData.senderId, senderDisplayName: "Guest User",date: messageTime , media:mediaItem)
                                    
                                    self.messages.append(sendMessage!)
                                }
                                
                            }
                            else{
                                mediaItem.appliesMediaViewMaskAsOutgoing = false
                                let sendMessage = JSQMessage(senderId:  listData.adminId as? String, senderDisplayName: "Admin",  date: messageTime , media:mediaItem)
                                
                                self.messages.append(sendMessage!)
                            }
                            // mediaItem.image = UIImage(data:image)//.jpegData(compressionQuality: 0.5)!)
                            
                        }
                    }
                    
                }
                
                
            }
            
            // }
            //   DispatchQueue.main.async {
            // self.collectionView?.reloadData()
            //     self.collectionView?.layoutIfNeeded()
            //           }
            
        }
        else{
            
        }
        
    }
    
    @objc func options()
    {
        //Atinderjit editDeleteAlert(titleStr: "", option1: "Add participants", option2: "Delete participants", option3: nil, editDeleteDelegate: self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- ConvertTime
       func converTime(time:Int?) ->Date
        {
            let tt = Double(time ?? 0)
            let date = NSDate(timeIntervalSince1970: tt)

            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMM yyyy, hh:mm a"

            localDate = dayTimePeriodFormatter.string(from: date as Date)
            let datee  = dayTimePeriodFormatter.date(from: localDate ?? "")!

            return datee
        }
    
    
  
    
    //MARK:- Actions
    @IBAction func sendMessageAction(_ sender: Any) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        print(indexPath.item)
        if message.senderId == senderId
        {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return nil
        } else {
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        //return 17.0
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return 0.0
        } else {
            
            return 14.0
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item]
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 17.0
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message: JSQMessage = self.messages[indexPath.item]
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            cell.cellBottomLabel.textAlignment = .right
        }
        else{
            cell.cellBottomLabel.textAlignment = .left
            cell.cellTopLabel.textColor = UIColor.red
        }
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        isImageSelected = false
        self.showTypingIndicator = self.showTypingIndicator
        
        // self.socketIOClient.emit("joinRoom", ["authToken":AppDefaults.shared.userJWT_Token,"receiverId":"89624900-a974-4849-9048-c32d6bed220a"])
        
        self.socketIOClient.emit("sendMessage", ["authToken":AppDefaults.shared.userJWT_Token,"groupId":self.newGroupId,"type": 1,"message": text,"usertype": "user", "receiverId":"89624900-a974-4849-9048-c32d6bed220a"])
        
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        self.finishSendingMessage(animated: true)
    }
    private func isAnOutgoingMessage(_ indexPath: IndexPath!) -> Bool
    {
        return messages[indexPath.row].senderId == senderId
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }
    //MARK:- clickOnImageBubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message: JSQMessage? = messages[indexPath.row]
        if message?.isMediaMessage != nil {
            let mediaItem: JSQMessageMediaData? = message?.media
            if (mediaItem is JSQPhotoMediaItem) {
                print("Tapped photo message bubble!")
                let photoItem = mediaItem as? JSQPhotoMediaItem
                let pdfUrl = photoItem?.videoUrl
                if let pdffile = pdfUrl
                {
                    let vc = UIStoryboard.init(name: "Chat", bundle: Bundle.main).instantiateViewController(withIdentifier: "OpenPdfFileVC") as! OpenPdfFileVC
                    vc.pdffile = pdffile
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let newImageView = UIImageView(image: photoItem?.image)
                    newImageView.frame = UIScreen.main.bounds
                    newImageView.backgroundColor = .gray
                    newImageView.isUserInteractionEnabled = true
                    newImageView.contentMode = .scaleAspectFit
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                    newImageView.addGestureRecognizer(tap)
                    self.view.addSubview(newImageView)
                    self.tabBarController?.tabBar.isHidden = true // tabBarController exists
                    self.navigationController?.isNavigationBarHidden = false // default  navigationController
                }
                
            }
            else{
                let mediaItem: JSQMessageMediaData? = message?.media
                if (mediaItem is JSQVideoMediaItem)
                {
                    let videoItem = mediaItem as? JSQVideoMediaItem
                    let newImageView = videoItem?.fileURL
                    playVideo(url: newImageView!)
                }
                //
            }
        }
        
    }
    //MARK:- playVideo
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    //MARK:- showImage in FullView
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview() // This will remove image from full screen
    }
    //MARK:- Attachment Action
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Open Attachment")
        selectPhotos()
    }
    
    
    //MARK: SELECT IMAGE
    func selectPhotos()
    {
        self.GoingForImage = true
        self.imagePicker.delegate = self
        self.imagePickerDelegate = self
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "", style: .default) { (_) in
            print("camera action")
            self.OpenCamera(pickerController: self.imagePicker,imagePicker_Delegate: self)//
            
        }
        cameraAction.mode = .camera
        sheet.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: "", style: .default) { (_) in
            
            
            
            self.OpenGallery(pickerController: self.imagePicker, imagePicker_Delegate: self)
        }
        galleryAction.mode = .gallery
        
        sheet.addAction(galleryAction)
        
        sheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    //MARK:-open Doc
    func documents()
    {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}
extension ChatVC: UIImagePickerDelegate
{
    
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?) {
        
        
        if videoURL == nil
        {
            let compressData = image!.jpegData(compressionQuality: 0.5)
            guard let base = compressData?.base64EncodedString(options: .lineLength64Characters) else {return}
            print(base)
            
            self.socketIOClient.emit("sendMessage", ["authToken":AppDefaults.shared.userJWT_Token,"groupId":self.newGroupId ,"type": 2,"media": base ,"extension" : "jpeg","usertype": "user", "receiverId":"89624900-a974-4849-9048-c32d6bed220a"])
            
            
        }
        
        self.finishSendingMessage()
    }
    
    func selectedImageUrl(url: URL)
    {
        print(url)
    }
    
    func cancelSelectionOfImg()
    {
        
    }
    
}

extension ChatVC: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as? URL
        
        //    self.socketIOClient.emit("joinRoom", ["authToken":AppDefaults.shared.userJWT_Token,"receiverId":"89624900-a974-4849-9048-c32d6bed220a"])
        
        print(url.lastPathComponent)
        print(url.pathExtension)
        do {
            let fileData = try Data.init(contentsOf: cico!)
            let fileBase64 = fileData.base64EncodedString(options: .lineLength64Characters)
            self.socketIOClient.emit("sendMessage", ["authToken":AppDefaults.shared.userJWT_Token,"groupId":self.selectedGroupId ?? "","type": 7,"media":";base64,"+fileBase64,"extension" : "."+url.pathExtension])
        }
        catch {
            
        }
        self.finishSendingMessage()
        
    }
}


extension ChatVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        imagePickerDelegate?.cancelSelectionOfImg()
        self.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        var isImage:Bool = false
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        print(mediaType)
        switch mediaType{
        case "public.image":
            isImage = true;
            break;
        case "public.video":
            isImage = false;
            break;
        default:
            break;
        }
        if(isImage == true){
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                if #available(iOS 11.0, *) {
                    if (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil {
                        
                        //   pickedImage =  pickedImage.fixedOrientation()!
                        
                        var urlImage:URL?
                        guard let chosenImagee = info[.editedImage] as? UIImage else {
                            fatalError("\(info)")
                        }
                        let chosenImage =  chosenImagee.fixedOrientation()!
                        
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // choose a name for your image
                        let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                        // create the destination file url to save your image
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)
                        
                        if let data = chosenImage.jpegData(compressionQuality: 0.5),
                            !FileManager.default.fileExists(atPath: fileURL.path) {
                            do {
                                // writes the image data to disk
                                try data.write(to: fileURL)
                                
                                let url = fileURL
                                urlImage = url
                                
                            } catch {
                                
                            }
                        }
                        if let url = urlImage{
                            imageURL = url
                            //  imagePickerDelegate?.selectedImageUrl(url: url)
                            imagePickerDelegate?.SelectedMedia(image: pickedImage, imageURL: imageURL, videoURL: nil)
                            
                        }
                    }
                    dismiss(animated: true, completion: nil)
                    
                } else {
                    //                  Fallback on earlier versions
                    var urlImage:URL?
                    guard let chosenImage = info[.editedImage] as? UIImage else {
                        fatalError("\(info)")
                    }
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // choose a name for your image
                    let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                    // create the destination file url to save your image
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    
                    if let data = chosenImage.jpegData(compressionQuality: 1.0),
                        !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            // writes the image data to disk
                            try data.write(to: fileURL)
                            let url = fileURL
                            urlImage = url
                        } catch {
                            //       CommonFunctions.sharedmanagerCommon.println(object: "Exception while writing the url image")
                        }
                    }
                    if let url = urlImage{
                        imageURL = url
                        //imagePickerDelegate?.selectedImageUrl(url: url)\
                        imagePickerDelegate?.SelectedMedia(image: pickedImage, imageURL: imageURL, videoURL: nil)
                        
                    }
                }
                print(imageURL!)
            }
            dismiss(animated: true, completion: nil)
        }
        else{
            guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
            
            do {
                let asset = AVURLAsset(url: videoURL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                imagePickerDelegate?.SelectedMedia(image: thumbnail,imageURL:nil,videoURL:videoURL )
            } catch let error {
                //     CommonFunctions.sharedmanagerCommon.println(object: "*** Error generating thumbnail: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        // When showing the ImagePicker update the status bar and nav bar properties.
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        //164 13 28
        navigationController.topViewController?.title = "Select photo"
        navigationController.navigationBar.isTranslucent = false
        
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.barStyle = .default
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
}
