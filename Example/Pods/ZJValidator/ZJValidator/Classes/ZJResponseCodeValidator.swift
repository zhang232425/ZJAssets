//
//  ZJResponseCodeValidator.swift
//  Pods-ZJValidator_Example
//
//  Created by Jercan on 2022/10/19.
//

import Foundation

public struct ZJResponseCodeValidator {
    
    public struct ValidateResult {
        public var success: Bool
        public var code: String?
        public var message: String?
    }
    
}

public extension ZJResponseCodeValidator {
    
    static func validate(success: Bool, code: String?, msg: String?) -> ValidateResult {
        let errMsg: String?
        if let errCode = code, let error = RequestError(rawValue: errCode), !error.localized.isEmpty {
            errMsg = error.localized
        } else if let message = msg, !message.isEmpty {
            errMsg = message
        } else {
            errMsg = code
        }
        
        return .init(success: success, code: code, message: errMsg)
    }
    
}

