//
//  Request+account.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/18.
//

import RxSwift
import HandyJSON
import ZJRequest

extension Request {
    enum account {}
}

extension Request.account {
    
    enum RegisterResult {
        case success(token: String)
        case accountExists
        case codeError(msg: String?)
        case bizError(msg: String?)
    }
    
    static func registerTips() -> Single<RegisterTipsModel?> {
        API.registerTips.rx.request()
            .mapObject(ZJRequestResult<RegisterTipsModel>.self)
            .map { $0.data }
    }
    
    static func register(account: String, captha: String) -> Single<RegisterResult> {
        
        return API.register(account: account, captcha: captha, deviceToken: nil, analyticsId: nil).rx.request()
            .mapObject(ZJRequestResult<[String: Any]>.self)
            .map {
                
                if $0.errCode == "PROFILE.0004" {
                    return .accountExists
                }
                
                if $0.errCode == "PROFILE.0002" {
                    return .codeError(msg: $0.mappedMsg)
                }
                
                if $0.success, let dict = $0.data, let token = dict["accessToken"] as? String {
                    return .success(token: token)
                } else {
                    return .bizError(msg: $0.mappedMsg)
                }
                
            }
        
    }
    
    static func inputReferralCode(_ code: String) -> Single<()> {
    
        API.inputReferralCode(code: code).rx.request()
            .mapObject(ZJRequestResult<Any>.self)
            .flatMap {
                if !$0.success {
                    throw RequestError(code: $0.errCode, msg: $0.mappedMsg)
                }
                return .just(())
            }
        
    }
    
}


