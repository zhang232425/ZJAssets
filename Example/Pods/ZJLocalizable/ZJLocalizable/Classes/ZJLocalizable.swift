//
//  ZJLocalizable.swift
//  Pods-ZJLocalizable_Example
//
//  Created by Jercan on 2022/10/12.
//

import Foundation

public enum ZJLocalizedCode: String, CaseIterable {
    /// 英语
    case en
    /// 印尼
    case id
}

public protocol ZJLocalizable {
    
    var key: String { get }
    
    var table: String { get }
    
    var bundle: Bundle { get }
    
}

public extension ZJLocalizable {
    
    var localized: String {
        
        let language = ZJLocalizer.currentLanguage.rawValue
        
        let defaultValue = "Unlocalized String"
        
        var languageBundle = bundle.path(forResource: language, ofType: "lproj").flatMap(Bundle.init)
        
        if let str = languageBundle?.localizedString(forKey: key, value: defaultValue, table: table), !str.isEmpty {
            return str
        }
                      
        let bundleName = bundle.infoDictionary?[kCFBundleNameKey as String] as? String
        
        languageBundle = bundle.path(forResource: bundleName, ofType: "bundle").flatMap(Bundle.init)
        
        languageBundle = languageBundle?.path(forResource: language, ofType: "lproj").flatMap(Bundle.init)
        
        return languageBundle?.localizedString(forKey: key, value: defaultValue, table: table) ?? ""
                                                                                        
    }
    
    func localized(arguments: String...) -> String {
        String(format: localized, arguments: arguments)
    }
    
}

