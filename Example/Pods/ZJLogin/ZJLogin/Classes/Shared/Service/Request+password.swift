//
//  Request+password.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import RxSwift
import ZJRequest

extension Request {
    enum password {}
}

extension Request.password {
    
    static func setPassword(password: String, accessToken: String) -> Single<()> {
        
        API.setStringPassword(password: password, accessToken: accessToken).rx.request()
            .mapObject(ZJRequestResult<Any>.self)
            .flatMap {
                if !$0.success {
                    throw RequestError(msg: $0.mappedMsg)
                }
                return .just(())
            }
        
    }

    static func verifyForgottenCaptcha(account: String, captcha: String) -> Single<()> {
        
        API.checkForgotPasswordCaptcha(account: account, captcha: captcha).rx.request()
            .mapObject(ZJRequestResult<Any>.self)
            .flatMap {
                if !$0.success {
                    throw RequestError(msg: $0.mappedMsg)
                }
                return .just(())
            }
        
    }
    
    static func resetStringPassword(account: String, captcha: String, newPassword: String) -> Single<()> {
        
        API.resetStringPasswordWhenForgot(account: account, captcha: captcha, newPasswordMask: newPassword).rx.request()
            .mapObject(ZJRequestResult<Any>.self)
            .flatMap {
                if !$0.success {
                    throw RequestError(msg: $0.mappedMsg)
                }
                return .just(())
            }
        
    }
    
    
}
