//
//  GetCaptchaRequester.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/18.
//

import Foundation

protocol GetCaptchaRequester {
    
    func performGetCaptchaRequest(onSuccess: @escaping (String?) -> Void)
    
}

protocol GetCaptchaResponder {
    
    func getCaptachaRequester() -> GetCaptchaRequester?
    
}

extension GetCaptchaResponder where Self: UIResponder {
    
    func getCaptachaRequester() -> GetCaptchaRequester? {
        for responder in sequence(first: next, next: { $0?.next }) {
            if let obj = responder as? GetCaptchaRequester {
                return obj
            }
        }
        return nil
    }
    
}

