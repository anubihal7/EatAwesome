
////
//
// import UIKit
//  import SocketIO
//
// class SocketIOManager: NSObject {
////static let socket = manager.defaultSocket
// var socket: SocketIOClient!
//    static let shared = SocketIOManager()
//    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
//
//    override init() {
//        super.init()
//        socket = manager.defaultSocket
//        }
//func connectSocket() {
//    let token = UserDefaults.standard.getAccessToken()
//
//    self.manager.config = SocketIOClientConfiguration(
//        arrayLiteral: .connectParams(["token": token]), .secure(true)
//        )
//        socket.connect()
//}
//
//func receiveMsg() {
//    socket.on("new message here") { (dataArray, ack) in
//
//        print(dataArray.count)
//
//    }
//}
//}
