//
//  GestureSetupViewModel.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/12.
//

import RxSwift
import ZJHUD

struct GestureSetupViewModel {
    
    let title = Locale.set_password_gesture.localized
    
    let remind = Locale.set_password_gesture.localized
    
    let skip = Locale.skip_gesture.localized
    
    var type: GestureType = .enable
    
    var isFromLogin = false
    
    var isConfirmPage = false
        
    var newGesture: String?
    
    var oldGesture: String?
    
    var loginPassword: String?
    
    var isSkipHidden: Bool { return !isFromLogin }
    
    var desc: String {
        
        guard let _ = newGesture else { return Locale.set_password_login_gesture.localized }
        
        return Locale.draw_again_gesture.localized
        
    }
    
    var indicatorGesture: String {
        
        guard let news = newGesture else { return "" }
        
        return news
        
    }
    
    let lengthError = Locale.length_error_gesture.localized
    
    let tryAgain = Locale.try_agin_gesture.localized
    
    var isPopGestureEnabled: Bool {
        return !isCustomBack
    }
    
    var isCustomBack: Bool {
        return isSettingConfirm || isLoginSetup
    }

    var isSettingConfirm: Bool {
        return !isFromLogin && newGesture != nil
    }
    
    var isLoginSetup: Bool {
        return isFromLogin && type == .enable && !isConfirmPage
    }
    
}

extension GestureSetupViewModel {
    
    func setGesture(gesture: String, loginPassword: String, result: ((Bool, String?) -> Void)?) {
        
        ZJHUD.showProgress()
        
        Request.setGesture(gesture: gesture.md5(), loginPwd: loginPassword.md5()) { (response, errMsg) in
            
            ZJHUD.hideProgress()
            
            guard let response = response else {
                
                ZJHUD.noticeOnlyText(errMsg)
                
                result?(false, errMsg)
                
                return
            }
            
            result?(response.success, response.errMsg)
            
        }
        
        
        
    }
    
    
}

