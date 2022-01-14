//
//  ConnectionManager.swift
//  LanguageLocalizer
//
//  Created by Gurleen Osahan on 11/21/19.
//  Copyright © 2019 Gurleen Osahan. All rights reserved.
//

import Foundation
import UIKit

protocol checkConnectionDelegates : class
{
    func internetGetConnected()
    func internetDisconnected()
}

class ConnectionManager
{
    
    static let sharedInstance = ConnectionManager()
    private var reachability : Reachability!
    weak var delegateInternet : checkConnectionDelegates?
    
    func observeReachability(){
        if let rchability = try? Reachability() {
            self.reachability = rchability
        }
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification)
    {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            self.delegateInternet?.internetGetConnected()
            print("Network available via Cellular Data.")
            break
        case .wifi:
            self.delegateInternet?.internetGetConnected()
            print("Network available via WiFi.")
            break
        case .none:
            self.delegateInternet?.internetDisconnected()
            print("Network is not available.")
            break
        case .unavailable:
            self.delegateInternet?.internetDisconnected()
            print("no connection")
            break
        
        }
    }
}
