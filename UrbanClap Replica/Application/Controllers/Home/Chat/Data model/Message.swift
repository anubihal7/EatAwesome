//
//  Message.swift
//  ScaledroneChatTest
//
//  Created by Marin Benčević on 08/09/2018.
//  Copyright © 2018 Scaledrone. All rights reserved.
//

//import Foundation
//import UIKit
//import MessageKit
//
//struct Message {
//  let member: Member
//  let text: String
//  let messageId: String
//}
//
//extension Message: MessageType {
//    var sender: SenderType {
//            return Sender(id: member.name, displayName: member.name)
//
//    }
//
//
//  var sentDate: Date {
//    return Date()
//  }
//
//  var kind: MessageKind {
//    return .text(text)
//  }
//}
//
//struct Member {
//  let name: String
//  let color: UIColor
//}
//
//extension Member {
//  var toJSON: Any {
//    return [
//      "name": name,
//      "color": color.hexString
//    ]
//  }
//
//  init?(fromJSON json: Any) {
//    guard
//      let data = json as? [String: Any],
//      let name = data["name"] as? String,
//      let hexColor = data["color"] as? String
//      else {
//        print("Couldn't parse Member")
//        return nil
//    }
//
//    self.name = name
//    self.color = UIColor(hex: hexColor)
//  }
//}
//
//extension UIColor {
//  convenience init(hex: String) {
//    var hex = hex
//    if hex.hasPrefix("#") {
//      hex.remove(at: hex.startIndex)
//    }
//
//    var rgb: UInt64 = 0
//    Scanner(string: hex).scanHexInt64(&rgb)
//
//    let r = (rgb & 0xff0000) >> 16
//    let g = (rgb & 0xff00) >> 8
//    let b = rgb & 0xff
//
//    self.init(
//      red: CGFloat(r) / 0xff,
//      green: CGFloat(g) / 0xff,
//      blue: CGFloat(b) / 0xff, alpha: 1
//    )
//  }
//
//  var hexString: String {
//    var r: CGFloat = 0
//    var g: CGFloat = 0
//    var b: CGFloat = 0
//    var a: CGFloat = 0
//
//    self.getRed(&r, green: &g, blue: &b, alpha: &a)
//
//    return String(
//      format: "#%02X%02X%02X",
//      Int(r * 0xff),
//      Int(g * 0xff),
//      Int(b * 0xff)
//    )
//  }
//}
