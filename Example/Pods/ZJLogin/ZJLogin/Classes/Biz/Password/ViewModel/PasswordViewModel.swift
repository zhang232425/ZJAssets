//
//  PasswordViewModel.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/22.
//

import RxSwift
import Action
import CryptoSwift

final class PasswordViewModel: InputChecker {
    
    private(set) var initPasswordAction: Action<(password: String, accessToken: String), Void>!
    
    private(set) var getForgotPwdCaptcha: Action<(account: String, imageCaptcha: String?), Request.getCaptcha.Result>!
    
    private(set) var captchaVerifyAction: Action<(account: String, captcha: String), Void>!
    
    private(set) var resetPasswordAction: Action<(account: String, captcha: String, newPassword: String), Void>!
    
    init() {
        
        initPasswordAction = .init(workFactory: { input -> Single<Void> in
            
            /*
            if input.password.isEmpty {
                return .error(InputError.passwordEmpty)
            }
            
            if !(8...16).contains(input.password.count) {
                return .error(InputError.passwordFormatError)
            }
            
            if !input.password.dd.isPassword() {
                return .error(InputError.passwordCorrentError)
            }
             */
            
            if let error = self.checkPasswordInputError(input.password) {
                return .error(error)
            }
            
            return Request.password.setPassword(password: input.password.md5(), accessToken: input.accessToken)
            
        })
        
        getForgotPwdCaptcha = .init(workFactory: { [weak self] input -> Single<Request.getCaptcha.Result> in
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            return Request.getCaptcha.onForgotPwd(account: input.account, imageCaptcha: input.imageCaptcha)
            
        })
        
        captchaVerifyAction = .init(workFactory: { [weak self] input -> Single<Void> in
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            if let error = self?.checkCodeInputError(input.captcha) {
                return .error(error)
            }
            
            return Request.password.verifyForgottenCaptcha(account: input.account, captcha: input.captcha)
            
        })
        
        resetPasswordAction = .init(workFactory: { [weak self] input -> Single<Void> in
            
            if let error = self?.checkCodeInputError(input.account) {
                return .error(error)
            }
            
            if let error = self?.checkCodeInputError(input.captcha) {
                return .error(error)
            }
            
            if let error = self?.checkPasswordInputError(input.newPassword) {
                return .error(error)
            }
            
            return Request.password.resetStringPassword(account: input.account, captcha: input.captcha, newPassword: input.newPassword.md5())
            
        })
        
    }
    
}

