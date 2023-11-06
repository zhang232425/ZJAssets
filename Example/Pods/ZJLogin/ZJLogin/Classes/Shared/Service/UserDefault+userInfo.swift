//
//  UserDefault+userInfo.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/9.
//

import HandyJSON
import ZJLoginManager

struct LastUserInfo: HandyJSON {
    
    var uid = ""
    
    var account = ""
    
    var userName = ""
    
    var avatarUrl = ""
    
    var isSetGesture = false
    
    init() {}
    
    private init(form profile: ZJUserProfile) {
        self.uid = profile.userId
        self.account = profile.phoneNumber
        self.userName = profile.userName
        self.avatarUrl = profile.avatarUrl
        self.isSetGesture = profile.isSetGesture
    }
    
    var profileTitle: String {
        
        if !userName.isEmpty {
            return userName
        }
        
        switch account.count {
        case 0...6:
            return account
        case 7...:
            let head = account.prefix(2)
            let tail = account.suffix(4)
            let maskCount = account.count - 6
            return "\(head)" + [String](repeating: "*", count: maskCount).joined() + "\(tail)"
        default:
            return ""
        }
        
    }
    
}

extension LastUserInfo {
    
    static func get() -> Self? {
        return UserDefaults.standard.lastUserInfo
    }
    
    static func save(_ profile: ZJUserProfile) {
        let info = Self.init(form: profile)
        UserDefaults.standard.lastUserInfo = info
    }
    
    static func refreshIsSetGesture(_ newValue: Bool) {
        guard var info = UserDefaults.standard.lastUserInfo else { return }
        info.isSetGesture = newValue
        UserDefaults.standard.lastUserInfo = info
    }
    
}

private extension UserDefaults {
    
    var lastUserInfo: LastUserInfo? {
        set {
            if let json = newValue?.toJSON() {
                let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                lastUserData = data
            }
        }
        get {
            guard let data = lastUserData else { return nil }
            if let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                let info = LastUserInfo.deserialize(from: dict)
                return info
            }
            return nil
        }
    }

}

private extension UserDefaults {
    
    var keyPrefix: String { "loginmodule_" }
    
    var lastUserData: Data? {
        set {
            if let data = newValue, !data.isEmpty {
                set(data, forKey: keyPrefix + #function)
            } else {
                removeObject(forKey: keyPrefix + #function)
            }
            synchronize()
        }
        get { data(forKey: keyPrefix + #function) }
    }
    
}
