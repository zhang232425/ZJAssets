//
//  String+Extension.swift
//  ZJExtension
//
//  Created by Jercan on 2023/9/25.
//

import CryptoSwift

public extension String {
    
    var isAlpha: Bool {
        let regex = "^[A-Za-z]+$"
        return executeRegex(regex)
    }
    
    var trimWhitespacesAndNewlines: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func executeRegex(_ regex: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
}

public extension String {
    
    enum EncryptType {
        case md5
        case sha256
    }
    
    func encrypt(_ type: EncryptType = .md5) -> String {
        switch type {
        case .md5: return md5()
        case .sha256: return sha256()
        }
    }
    
}
