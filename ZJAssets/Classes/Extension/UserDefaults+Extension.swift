//
//  UserDefaults+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/14.
//

import Foundation

extension UserDefaults {
    
    static let secureTextStateDidChange = Notification.Name(rawValue: "notification.name.assets.secure")
    
    static let depositSecureTextStateDidChange = Notification.Name(rawValue: "notification.name.deposit.assets.secure")
    
    var isSecureText: Bool {
        
        set {
            set(newValue, forKey: #function)
            synchronize()
            NotificationCenter.default.post(name: UserDefaults.secureTextStateDidChange, object: newValue)
        }
        
        get { bool(forKey: #function) }
        
    }
    
}
