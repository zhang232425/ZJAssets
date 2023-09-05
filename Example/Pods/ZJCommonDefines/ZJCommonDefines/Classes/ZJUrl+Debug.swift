//
//  ZJUrl+Debug.swift
//  Pods-ZJCommonDefines_Example
//
//  Created by Jercan on 2023/9/4.
//

#if DEBUG

public extension ZJUrl {
    
    enum Environment: String, CaseIterable {
        case dev
        case test
        case preonline
        case uat
        case prod
    }
    
}

public extension ZJUrl.Environment {
    
    static var current: Self {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "ZJURLEnvironment")
            UserDefaults.standard.synchronize()
        }
        get {
            if let str = UserDefaults.standard.string(forKey: "ZJURLEnvironment"),
               let env = Self(rawValue: str) {
                return env
            }
            return .test
        }
    }
    
    var desc: String {
        switch self {
        case .dev:
            return "开发环境"
        case .test:
            return "测试环境"
        case .preonline:
            return "预发环境"
        case .uat:
            return "UAT环境"
        case .prod:
            return "正式环境"
        }
    }
    
}

extension ZJUrl.Environment {
    
    var server: String {
        switch self {
        case .prod:
            return "https://app.asetku.co.id"
        default:
            return "\(scheme)://\(rawValue)-app.asetku.com"
        }
    }
    
    var scheme: String {
        switch self {
        case .dev:
            return "http"
        default:
            return "https"
        }
    }
    
    var loan: String {
        switch self {
        case .prod:
            return "https://asetloan.asetku.co.id"
        case .dev:
            return "http://dev-asetloan.asetku.com"
        default:
            return "https://\(rawValue)-asetloan.asetku.com"
        }
    }
    
    var betch: String {
        switch self {
        case .prod:
            return "https://asetloan.asetku.com"
        default:
            return "https://\(rawValue)-asetloan.asetku.com"
        }
    }
    
    var borrowUrl: String {
        switch self {
        case .prod:
            return "https://cash.asetku.co.id/h5-loan/thirdparty"
        default:
            return "https://test-cash.asetku.com/h5-loan/thirdparty"
        }
    }
    
}

#endif

