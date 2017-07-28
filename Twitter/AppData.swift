//
//  AppData.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

final class AppData {
    private init() {
        self.username = nil
    }
    
    static let shared = AppData()
    
    var username : String?
    var jsonData : [String: Any] = [:]
    var credits : Int = 0
}
