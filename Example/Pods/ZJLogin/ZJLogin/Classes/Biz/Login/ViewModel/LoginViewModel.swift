//
//  LoginViewModel.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import RxSwift
import Action

final class LoginViewModel: InputChecker {
    
    private(set) var getCaptchaOnLogin: Action<(account: String,
                                                imageCaptcha: String?), Request.getCaptcha.Result>!
    
    private(set) var loginByPassword: Action<(account: String,
                                              password: String,
                                              captcha: String?), Request.login.Result>!
        
    private(set) var loginBySMS: Action<(account: String, smsCode: String), Request.login.Result>!
    
    private(set) var getPassword: Action<(), Bool>!
    
    init() {
        
        getCaptchaOnLogin = .init(workFactory: { [weak self] input -> Single<Request.getCaptcha.Result> in
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            return Request.getCaptcha.onLogin(account: input.account, imageCaptcha: input.imageCaptcha)
            
        })
        
        loginByPassword = .init(workFactory: { [weak self] input -> Single<Request.login.Result> in
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            if input.password.isEmpty {
                return .error(InputError.passwordEmpty)
            }
            
            return Request.login.byPassword(account: input.account,
                                            password: input.password.md5(),
                                            captcha: input.captcha)
            
        })
        
        loginBySMS = .init(workFactory: { [weak self] input -> Single<Request.login.Result> in
        
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            if let error = self?.checkCodeInputError(input.smsCode) {
                return .error(error)
            }
            
            return Request.login.bySMSCode(account: input.account, smsCode: input.smsCode)
            
        })
        
        getPassword = .init(workFactory: {
            
            return Request.login.getPassword()
            
        })
    
    }
    
}

private enum InputError: LocalizedError {
    
    case passwordEmpty
    
    var errorDescription: String? {
        switch self {
        case .passwordEmpty:
            return Locale.enterLoginPwd.localized
        }
    }
    
}
