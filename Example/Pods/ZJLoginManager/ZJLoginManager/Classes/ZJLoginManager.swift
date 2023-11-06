//
//  ZJLoginManager.swift
//  Pods-ZJLoginManager_Example
//
//  Created by Jercan on 2023/9/11.
//

import ZJRequest
import ZJKeychain
import ZJCommonDefines
import HandyJSON

public final class ZJLoginManager {
    
    public static let shared = ZJLoginManager()
    
    public private(set) var isGestureLogin = false
    
    public var isShowUpdate = false
    
    private var _profile: ZJUserProfile?
    
    private var _lastLoginAccount: String?
    
    private var accessToke: String?
    
    private let accessTokenKey = "accessToken"
    
    /// OneAset授权登录标记
    private var authorize = false
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(registerNotification), name: ZJNotification.didLogin, object: nil)
        registerNotification()
        isGestureLogin = UserDefaults.standard.isGestureLogin
    }
    
}

public extension ZJLoginManager {
    
    var isLogin: Bool {
        
        guard UserDefaults.standard.loadAccessToke else {
            ZJKeychain.delete(accessTokenKey)
            UserDefaults.standard.loadAccessToke = true
            return false
        }
        
        if accessToke == nil {
            accessToke = ZJKeychain.get(accessTokenKey)
            ZJRequest.accessToken = accessToke
        }
        
        return accessToke != nil
        
    }
    
    /// 注销显示开关
    var destroySwith: DestroySwitchStatus {
        return isLogin ? (profile?.destroySwitch ?? .close) : .close
    }
    
    /// 是否注销过
    var isDestory: DestroyStatus {
        return profile?.isDestroy ?? .none
    }

    var lastLoginAccount: String? {
        set {
            _lastLoginAccount = newValue
            UserDefaults.standard.lastLoginAccount = newValue
        }
        get {
            if _lastLoginAccount == nil {
                _lastLoginAccount = UserDefaults.standard.lastLoginAccount
            }
            return _lastLoginAccount
        }
    }
    
}

public extension ZJLoginManager {
    
    var profile: ZJUserProfile? {
        set {
            _profile = newValue
            if let json = newValue?.toJSON(),
               let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                UserDefaults.standard.currentUser = data
            } else {
                UserDefaults.standard.currentUser = nil
            }
        }
        get {
            if _profile == nil {
                if let data = UserDefaults.standard.currentUser,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    _profile = ZJUserProfile.deserialize(from: dict)
                }
            }
            return _profile
        }
    }
    
}

public extension ZJLoginManager {
    
    func start() {}
    
    func login(accessToken: String?) {
        self.accessToke = accessToken
        ZJRequest.accessToken = accessToken
        if let toke = accessToken {
            ZJKeychain.set(toke, forKey: accessTokenKey)
        } else {
            ZJKeychain.delete(accessTokenKey)
        }
    }
    
    func logout() {
//        unRegisterNotification()
        profile = nil
        accessToke = nil
        ZJRequest.accessToken = nil
        ZJKeychain.delete(accessTokenKey)
        isGestureLogin = false
        UserDefaults.standard.isGestureLogin = false
    }
    
    func fetchUserProfile(success: @escaping (ZJUserProfile?) -> Void, failure: @escaping (Error) -> Void) {
        
        ZJUserProfileAPI.fetch.requestObject(success: { [weak self] (res: ZJRequestResult<ZJUserProfile>) in
            
            if res.success {
                
                if let profile = res.data {
                    self?.profile = profile
                    if profile.activeStatus == .yet {
                        UserDefaults.standard.removeObject(forKey: String.activeStatus)
                    }
                }
                
                success(self?.profile)
                
            } else {
                
                var userInfo = [String: Any]()
                userInfo[NSLocalizedDescriptionKey] = res.errMsg
                userInfo["errorCode"] = res.errCode
                failure(NSError(domain: "RequestFailureDomain", code: -1, userInfo: userInfo))
                
            }
            
        }, failure: failure)
        
    }
    
}

private extension ZJLoginManager {
     
    @objc func handleStatusCodeUnauthorizedNotification() {
         
        let userProfile = profile
         
        logout()
         
        if let hasGesture = userProfile?.isSetGesture, hasGesture {
             
            isGestureLogin = true
             
            UserDefaults.standard.isGestureLogin = true
             
        }
         
        NotificationCenter.default.post(name: ZJNotification.tokenExpired, object: nil)
         
    }
     
    @objc func registerNotification() {
         
         [ZJRequest.statusCodeUnauthorizedNotification, ZJNotification.didKickOff].forEach {
             NotificationCenter.default.removeObserver(self, name: $0, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(handleStatusCodeUnauthorizedNotification), name: $0, object: nil)
         }
         
    }
     
    func unRegisterNotification() {
         
        [ZJRequest.statusCodeUnauthorizedNotification, ZJNotification.didKickOff].forEach {
             NotificationCenter.default.removeObserver(self, name: $0, object: nil)
        }
         
    }
     
}


private extension UserDefaults {
    
    var currentUser: Data? {
        set {
            if let data = newValue, !data.isEmpty {
                set(data, forKey: #function)
            } else {
                removeObject(forKey: #function)
            }
            synchronize()
        }
        get { data(forKey: #function) }
    }
    
    var isGestureLogin: Bool {
        set {
            set(newValue, forKey: #function)
            synchronize()
        }
        get { bool(forKey: #function) }
    }
    
    var lastLoginAccount: String? {
        set {
            if let account = newValue, !account.isEmpty {
                set(account, forKey: #function)
                synchronize()
            }
        }
        get { string(forKey: #function) }
    }
    
    var loadAccessToke: Bool {
        set {
            if newValue == true {
                set(newValue, forKey: #function)
                synchronize()
            }
        }
        get { bool(forKey: #function) }
    }
    
}

fileprivate extension String {
    static var activeStatus: String {
        return "user.kyc.activeStatus"
    }
}

