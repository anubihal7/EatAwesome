
//

import Foundation
import SocketIO

class SocketHelper
{
    
    static let shared = SocketHelper()
    var socket: SocketIOClient!
    
    let manager = SocketManager(socketURL: URL(string: APIAddress.BASE_URL)!, config: [.log(true), .compress])
    
    private init()
    {
        socket = manager.defaultSocket
    }
    
    func connectSocket(completion: @escaping(Bool) -> () )
    {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
            completion(true)
        }
        
        socket.connect()
    }
    
    func disconnectSocket()
    {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }
    
    func checkConnection() -> Bool
    {
        if socket.manager?.status == .connected
        {
            return true
        }
        return false
        
    }
    
    enum Events
    {
        case data
        
        var emitterName: String
        {
            switch self
            {
            case .data:
                return "data"
            }
        }
        
        
        func emit(params: [String : Any])
        {
            SocketHelper.shared.socket.emit("socketFromClient", params)
        }
        
        func listen(completion: @escaping (Any) -> Void)
        {
            SocketHelper.shared.socket.on("responseFromServer")
            { (response, emitter) in
                completion(response)
            }
        }
    }
}
