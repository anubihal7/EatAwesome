//
//  AppDelegate.swift
//  UnionGoods
//
//  Created by Rakesh Kumar on 11/26/19.
//  Copyright © 2019 UnionGoods. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
extension AppDelegate
{
    @available(iOS 13.0, *)
    static var shared: AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
