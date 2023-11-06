//
//  RegisterViewModel.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import Action
import RxSwift
import ZJExtension

final class RegisterViewModel: InputChecker {
    
    private(set) var registerTipsAction: Action<Void, NSAttributedString>!
    
    private(set) var registerCaptcha: Action<(account: String,
                                              imageCaptcha: String?), Request.getCaptcha.Result>!
    
    private(set) var registerAction: Action<(agreementChecked: Bool,
                                             account: String,
                                             captcha: String), Request.account.RegisterResult>!
        
    private(set) var setReferralCode: Action<String, Void>!
    
    init() {
        
        registerTipsAction = .init(workFactory: { _ in
            
            Request.account.registerTips().map { model -> NSAttributedString in
                
                guard let tips = model else { return .init() }
                
                let attrStr = NSMutableAttributedString(string: tips.full)
                let fullRange = NSMakeRange(0, tips.full.count)
                attrStr.addAttribute(.foregroundColor, value: UIColor(hexString: "#666666"), range: fullRange)
                attrStr.addAttribute(.font, value: UIFont.regular16, range: fullRange)
                
                let boldRange = attrStr.mutableString.range(of: tips.bold)
                if boldRange.location != NSNotFound {
                    attrStr.addAttribute(.font, value: UIFont.bold16, range: boldRange)
                }
                
                return attrStr
                
            }
        })
        
        registerCaptcha = .init(workFactory: { [weak self] input -> Single<Request.getCaptcha.Result> in
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            return Request.getCaptcha.onRegister(account: input.account, imageCaptcha: input.imageCaptcha)
            
        })
        
        registerAction = .init(workFactory: { [weak self] input -> Single<Request.account.RegisterResult> in
            
            if !input.agreementChecked {
                return .error(InputError.agreementNotChecked)
            }
            
            if let error = self?.checkAccountInputError(input.account) {
                return .error(error)
            }
            
            if let error = self?.checkCodeInputError(input.captcha) {
                return .error(error)
            }
            
            return Request.account.register(account: input.account, captha: input.captcha)
            
        })
        
        setReferralCode = .init(workFactory: { input -> Single<Void> in
            
            if input.isEmpty {
                return .error(InputError.referralCodeEmpty)
            }
            
            return Request.account.inputReferralCode(input)
            
        })
        
    }
    
}

private enum InputError: LocalizedError {
    
    case agreementNotChecked
    case referralCodeEmpty
    
    var errorDescription: String? {
        switch self {
        case .agreementNotChecked:
            return Locale.makeSureApprovedTerms.localized
        case .referralCodeEmpty:
            return Locale.enterVerficationCode.localized
        }
    }
    
}

