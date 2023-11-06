//
//  Locale.swift
//  Pods-ZJLogin_Example
//
//  Created by Jercan on 2023/9/12.
//

import ZJLocalizable

enum Locale: String {
    
    case register
    case enterPhoneNumer
    case enterVerficationCode
    case send
    case resend
    case next
    case tncLendingBorrowing
    case privacyPolicy
    case agreementDescription
    case login
    case phoneCountError
    case phonePrefixError
    case makeSureApprovedTerms
    case enterReferralCode
    case loginNow
    case accountAlreadyExists
    
    case passwordPlaceholder
    case confirm
    
    case setLoginPassword
    case usePasswordLoginLater
    case skip
    case enterPassword
    case passwordFormatError
    case setPasswordSuccessfully
    case correctPasswordHint
    case correctPasswordToast
    case passwordTlaceholder
    
    // MARK: - 输入邀请码
    case referralCode
    case referralCodeDescription
    case submit
    case referralEmpty
    case success
    
    // MARK: - 密码登录
    case loginWithPassword
    case welcomeToAsetku
    case enterLoginPwd
    case forgotPassword
    case loginWithCode
    case accountNotExistOrPasswordWrong
    case loginSuccessful
    case ok
    case accountFrozenNotice
    case accountFrozenPhonePrefix
    case iKnow
    case phoneCopied
    case frozenTitle
    
    // MARK: - 指纹/人脸登录
    case touchLoginButtonTitle
    case faceLoginButtonTitle
    case switchLoginMethod
    case gestureLoginButtonTitle
    case passwordLoginButtonTitle
    case gestureNotyetSetToast
    
    case passcodeNotSetToast
    case biometryLockoutToast
    case touchIdunavailableToast
    case faceIdunavailableToast
    case touchNotEnrolledToast
    case faceNotEnrolledToast
    case touchChangedToast
    case faceChangedToast
    case touchInvalidToast
    case faceInvalidToast
    case touchIdEvaluateReason
    case faceIdEvaluateReason
    case evaluationFailToast
    
    // MARK: - Gesture
    case set_password_gesture
    case set_password_login_gesture
    case length_error_gesture
    case draw_again_gesture
    case try_agin_gesture
    case login_gesture
    case times_error_gesture
    case login_move_gesture
    case enable_gesture
    case disable_gesture
    case reset_gesture
    case gesture_password_gesture
    case login_verify_gesture
    case verify_gesture
    case disable_move_gesture
    case disable_verify_gesture
    case enter_gesture
    case submit_gesture
    case enter_verify_gesture
    case login_remind_gesture
    case login_reset_verify_gesture
    case reset_verify_gesture
    case max_times_error_gesture
    case incorrect_gesture
    case disable_will_verify_gesture
    case login_enter_remind_gesture
    case enter_remind_gesture
    case skip_gesture
    case success_gesture
    case hi_gesture
    
}

extension Locale: ZJLocalizable {
    
    var key: String {
        return rawValue
    }
    
    var table: String {
        return "Locale"
    }
    
    var bundle: Bundle {
        return .framework_ZJLogin
    }
    
}

extension Locale {
    
    func localized(arguments: [String]) -> String {
        String(format: localized, arguments: arguments)
    }
    
}

extension Locale {
    
    static let phonePrefix = "08"
    
}

