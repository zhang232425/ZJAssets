//
//  ZJLocalAuth.swift
//  ZJLocalAuth
//
//  Created by Jercan on 2023/10/9.
//

import DeviceKit
import ZJKeychain
import LocalAuthentication

public struct ZJLocalAuth {
    
    public enum Result {
        /// 成功
        case success
        /// 失败
        case failed
        /// 用户取消验证(点击弹出框的取消按钮)
        case userCancel
        /// 应用程序取消了身份认证
        case appCancel
        /// 系统取消授权
        case systemCancel
        /// 用户选择使用密码 - 【通常-跳转到登录页使用密码进行解锁】
        case userFallBack
        /// 系统未设置密码
        case passcodeNotSet
        /// 未录入
        case biometryNotEnrolled
        /// 尝试次数过多被锁，需要用户输入密码解锁
        case biometryLockout
        /// 不可用，例如未打开、未获取权限
        case biometryNotAvailable
        /// 指纹有变化
        case credentialChanged
    }
    
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
    private let key: String
    
    /// uid用于区分不同的用户
    public init(uid: String) {
        self.key = "ZJLocalAuth-\(uid)"
    }
    
}

public extension ZJLocalAuth {
    
    static var isBiometryCapable: Bool { isTouchIDCapable || isFaceIDCapable }
    
    static var isTouchIDCapable: Bool { Device.current.isTouchIDCapable }
    
    static var isFaceIDCapable: Bool { Device.current.isFaceIDCapable }
    
    /// 标记用户是否启用touch id或者face id
    var isUserEnabled: Bool {
        set { UserDefaults.standard.setOpenBiometry(newValue, key: key) }
        get { UserDefaults.standard.isOpenBiometry(key: key) }
    }
    
}

/// MARK: - 后端生成的用户认证ID相关操作
public extension ZJLocalAuth {
    
    var biometryID: String? {
        set {
            if let id = newValue {
                ZJKeychain.set(id, forKey: key)
            } else {
                ZJKeychain.delete(key)
            }
        }
        get { ZJKeychain.get(key) }
    }
    
}

public extension ZJLocalAuth {

    func evaluate(reason: String, result: @escaping ((Result) -> ())) {
        evaluate(reason: reason, fallbackTitle: "", result: result)
    }

    func evaluate(reason: String, fallbackTitle: String?, result: @escaping ((Result) -> ())) {
        
        let context = LAContext()
        
        if let title = fallbackTitle {
            context.localizedFallbackTitle = title
        }
        
        var error: NSError?
        
        if context.canEvaluatePolicy(policy, error: &error) {
            
            if let old = getBiometryData(), let new = context.evaluatedPolicyDomainState, old != new {
                executeInMain { result(.credentialChanged) }
                return
            }
            
            context.evaluatePolicy(policy, localizedReason: reason) {
                if $0 {
                    saveBiometryData(context.evaluatedPolicyDomainState)
                    executeInMain { result(.success) }
                } else if let code = ($1 as? LAError)?.code {
                    executeInMain { result(serializeErrorCode(code)) }
                } else {
                    executeInMain { result(.failed) }
                }
            }
            
        } else if let code = (error as? LAError)?.code {
            executeInMain { result(serializeErrorCode(code)) }
        } else {
            executeInMain { result(.failed) }
        }
        
    }
    
    /// 用户使用其他方式登录成功之后调用
    func resetBiometryData() {
        deleteBiometryData()
    }

}

private extension ZJLocalAuth {
    
    func saveBiometryData(_ data: Data?) {
        UserDefaults.standard.biometryData = data
    }
    
    func getBiometryData() -> Data? {
        UserDefaults.standard.biometryData
    }
    
    func deleteBiometryData() {
        UserDefaults.standard.biometryData = nil
    }
    
    func executeInMain(action: @escaping () -> ()) {
        DispatchQueue.main.async(execute: action)
    }
    
    func serializeErrorCode(_ code: LAError.Code) -> Result {
        
        let res: Result
        
        switch code {
        case .systemCancel:
            res = .systemCancel
        case .userCancel:
            return .userCancel
        case .appCancel:
            res = .appCancel
        case .passcodeNotSet:
            res = .passcodeNotSet
        case .touchIDNotAvailable:
            res = .biometryNotAvailable
        case .userFallback:
            res = .userFallBack
        case .touchIDLockout:
            res = .biometryLockout
        case .touchIDNotEnrolled:
            res = .biometryNotEnrolled
        case .invalidContext:
            debugPrint("invalidContext")
            res = .failed
        case .authenticationFailed:
            res = .failed
        case .notInteractive:
            res = .failed
        default:
            res = .failed
        }
        
        return res
        
    }
    
}

private extension UserDefaults {
    
    var biometryData: Data? {
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
    
    func setOpenBiometry(_ open: Bool, key: String) {
        set(open, forKey: key)
        synchronize()
    }
    
    func isOpenBiometry(key: String) -> Bool {
        bool(forKey: key)
    }
    
}
