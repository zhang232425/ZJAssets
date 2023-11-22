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
    
    static let testSecureTextStateDidChange = Notification.Name(rawValue: "notification.name.test.secure")
    
    var isSecureText: Bool {
        
        set {
            set(newValue, forKey: #function)
            synchronize()
            NotificationCenter.default.post(name: UserDefaults.secureTextStateDidChange, object: newValue)
        }
        
        get { bool(forKey: #function) }
        
    }
    
    var isDepositSecureText: Bool {
        
        set {
            set(newValue, forKey: #function)
            synchronize()
            NotificationCenter.default.post(name: UserDefaults.depositSecureTextStateDidChange, object: newValue)
        }
        
        get { bool(forKey: #function) }
        
    }
    
    var isDisplayAssetsBubble: Bool {
        
        set {
            setValue(newValue, forKey: #function)
            synchronize()
        }
        
        get { bool(forKey: #function) }
        
    }
    
    var isTestSecureText: Bool {
        
        set {
            set(newValue, forKey: #function)
            synchronize()
            NotificationCenter.default.post(name: UserDefaults.testSecureTextStateDidChange, object: newValue)
        }
        
        get { bool(forKey: #function) }
        
    }
    
}
