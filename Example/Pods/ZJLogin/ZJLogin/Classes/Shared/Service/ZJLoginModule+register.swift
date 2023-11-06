//
//  ZJLoginModule+register.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import ZJHUD
import ZJLoginManager
//import ASDataAnalytics

extension ZJLoginModule {
    
    static func notifyInitPasswordSuccess(account: String,
                                          accessToken: String,
                                          completion: (() -> Void)?) {
        
        let manager = ZJLoginManager.shared
        manager.login(accessToken: accessToken)
        manager.lastLoginAccount = account
        manager.fetchUserProfile(success: { _ in
//            ReportEvent.trackSignUp(userId: $0?.userId)
            completion?()
        }, failure: {
            ZJHUD.noticeOnlyText($0.localizedDescription)
        })
        
    }
    
}

