//
//  Request+getCaptcha.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/18.
//

import RxSwift
import ZJRequest

extension Request {
    enum getCaptcha {}
}

extension Request.getCaptcha {
    
    enum Result {
        case success(code: String?)
        case needImageCaptcha
        case imageCapthaError(msg: String?)
        case bizError(msg: String?)
    }
    
    static func onRegister(account: String, imageCaptcha: String?) -> Single<Result> {
        
        let r = API.getCaptcha_register(account: account, imageCaptcha: imageCaptcha)
            .rx.request().mapObject(ZJRequestResult<[String: Any]>.self)
        return _mapGetCaptchaResult(r)
        
    }
    
    static func onLogin(account: String, imageCaptcha: String?) -> Single<Result> {
        
        let r = API.getCaptcha_login(account: account, imageCaptcha: imageCaptcha)
            .rx.request().mapObject(ZJRequestResult<[String: Any]>.self)
        return _mapGetCaptchaResult(r)
        
    }
    
    static func onForgotPwd(account: String, imageCaptcha: String?) -> Single<Result> {
        
        return API.getCaptcha_forgotPwd(account: account, imageCaptcha: imageCaptcha)
            .rx.request().mapObject(ZJRequestResult<String>.self).map { root -> Result in
                
                if root.errCode == "CAPTCHA.0001" {
                    return .needImageCaptcha
                }
                
                if root.errCode == "CAPTCHA.0003" {
                    return .imageCapthaError(msg: root.mappedMsg)
                }
                
                if root.success {
                    let captcha = root.data
                    return .success(code: captcha)
                } else {
                    return .bizError(msg: root.mappedMsg)
                }
                
            }
        
    }
    

    static private func _mapGetCaptchaResult(_ r: Single<ZJRequestResult<[String: Any]>>) -> Single<Result> {
        
        return r.map { root -> Result in
            
            if root.errCode == "CAPTCHA.0001" {
                return .needImageCaptcha
            }
            
            if root.errCode == "CAPTCHA.0030" {
                return .imageCapthaError(msg: root.mappedMsg)
            }
            
            if root.success {
                let captcha = root.data?["captcha"] as? String
                return .success(code: captcha)
            } else {
                return .bizError(msg: root.mappedMsg)
            }
            
        }
        
    }
    
    
}
