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
        
    }
    
    static let shared = AppData()
    
    var jsonData : [String: Any] = [:]
}
