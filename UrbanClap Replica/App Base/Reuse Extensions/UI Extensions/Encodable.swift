//
//  Encodable.swift
//  UnionGoods
//
//  Created by Rakesh Kumar on 11/21/19.
//  Copyright © 2019 UnionGoods. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct JSONEnCode {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEnCode.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
