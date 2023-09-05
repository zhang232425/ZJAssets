//
//  ZJLocalizer.swift
//  Pods-ZJLocalizable_Example
//
//  Created by Jercan on 2022/10/12.
//

import Foundation

public final class ZJLocalizer {
    
    public static let languageDidChangeNotification = Notification.Name(rawValue: "notification.name.as.localized.change")
    
    private static let shared = ZJLocalizer()
    
    public var currentLanguage: ZJLocalizedCode
    
    public static var currentLanguage: ZJLocalizedCode { shared.currentLanguage }
    
    private init() {
        
        if let language = UserDefaults.standard.currentLanguage, let code = ZJLocalizedCode(rawValue: language) {
            currentLanguage = code
        } else {
            if let language = Locale.preferredLanguages.first?.components(separatedBy: .init(charactersIn: "-_")).first?.lowercased(), let code = ZJLocalizedCode(rawValue: language) {
                UserDefaults.standard.currentLanguage = language
                currentLanguage = code
            } else {
                UserDefaults.standard.currentLanguage = "id"
                currentLanguage = .id
            }
                
        }
        
    }
    
    public static func change(language: ZJLocalizedCode) {
        
        guard language != currentLanguage else { return }
        
        shared.currentLanguage = language
        
        UserDefaults.standard.currentLanguage = language.rawValue
        
        NotificationCenter.default.post(name: languageDidChangeNotification, object: nil)
        
    }
    
}

private extension UserDefaults {
    
    var currentLanguage: String? {
        
        get { string(forKey: #function) }
        
        set {
            set(newValue, forKey: #function)
            synchronize()
        }
        
    }
    
}


