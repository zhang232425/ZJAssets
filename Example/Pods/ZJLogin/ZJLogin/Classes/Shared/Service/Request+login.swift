//
//  Request+login.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/26.
//

import Moya
import RxSwift
import HandyJSON
import ZJRequest

extension Request {
    enum login {}
}

extension Request.login {
    
    enum Result {
        
        case success(Self.Data)
        case needSmsCaptcha(msg: String?)
        case accountNotExist
        case accountBeFrozen
        case bizError(RequestError)
        
        struct Data: HandyJSON {
            
            var accessToken = ""
            var isSetGesture = false
            
            mutating func mapping(mapper: HelpingMapper) {
                mapper <<< isSetGesture <-- "gesture"
            }
            
        }
        
    }
    
    static func byPassword(account: String,
                           password: String,
                           captcha: String?) -> Single<Request.login.Result> {
        
        let r = API.loginByPassword(account: account, password: password, captcha: captcha).rx.request()
        return _mapLoginResult(r)
        
    }
    
    static func bySMSCode(account: String, smsCode: String) -> Single<Request.login.Result> {
        
        let r = API.loginBySMSCode(account: account, smsCode: smsCode).rx.request()
        return _mapLoginResult(r)
        
    }
    
    static func getPassword() -> Single<Bool> {
        
        API.isSetStringPassword.rx.request()
            .mapObject(ZJRequestResult<[String: Any]>.self)
            .map { root -> Bool in
                (root.data?["hasLoginPassword"] as? Bool) ?? true
            }
        
    }
    
    private static func _mapLoginResult(_ r: Single<Response>) -> Single<Request.login.Result> {
        
        return r.mapObject(ZJRequestResult<Result.Data>.self)
            .map { root -> Result in
                
                if root.errCode == "USERINFO.1000" {
                    return .accountNotExist
                }
                
                if root.errCode == "USER.0014" {
                    return .accountBeFrozen
                }
                
                if root.errCode == "SMS.002" {
                    return .needSmsCaptcha(msg: root.mappedMsg)
                }
                
                if root.success, let data = root.data {
                    return .success(data)
                } else {
                    return .bizError(.init(code: root.errCode, msg: root.mappedMsg))
                }
                
            }
        
    }
    
    
}

