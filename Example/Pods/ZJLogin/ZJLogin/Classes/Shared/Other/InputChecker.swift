//
//  InputChecker.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/18.
//

import Foundation

protocol InputChecker {}

extension InputChecker {
    
    func checkAccountInputError(_ string: String) -> Swift.Error? {
        
        if string.isEmpty {
            return AccountInputError.empty
        }
        
        if !(10...13).contains(string.count) {
            return AccountInputError.countError
        }
        
        if !string.hasPrefix(Locale.phonePrefix) {
            return AccountInputError.prefixError
        }
        
        return nil
        
    }
    
    func checkCodeInputError(_ string: String) -> Swift.Error? {
        
        if string.isEmpty {
            return CodeInputError.empty
        }
        
        return nil
        
    }
    
    func checkPasswordInputError(_ string: String) -> Swift.Error? {
        
        if string.isEmpty {
            return PasswordInputError.passwordEmpty
        }
        
        if !(8...16).contains(string.count) {
            return PasswordInputError.passwordFormatError
        }
        
        if !string.dd.isPassword() {
            return PasswordInputError.passwordCorrentError
        }
        
        return nil
        
    }

}


private enum AccountInputError: LocalizedError {
    
    case empty
    case countError
    case prefixError
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return Locale.enterPhoneNumer.localized
        case .countError:
            return Locale.phoneCountError.localized
        case .prefixError:
            return Locale.phonePrefixError.localized
        }
    }
    
}

private enum CodeInputError: LocalizedError {
    
    case empty
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return Locale.enterVerficationCode.localized
        }
    }
    
}

private enum PasswordInputError: LocalizedError {
    
    case passwordEmpty
    case passwordFormatError
    case passwordCorrentError
    
    var errorDescription: String? {
        switch self {
        case .passwordEmpty:
            return Locale.enterPassword.localized
        case .passwordFormatError:
            return Locale.passwordFormatError.localized
        case .passwordCorrentError:
            return Locale.correctPasswordToast.localized
        }
    }
    
}
