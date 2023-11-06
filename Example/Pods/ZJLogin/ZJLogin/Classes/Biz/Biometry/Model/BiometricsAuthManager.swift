//
//  BiometricsAuthManager.swift
//  Pods
//
//  Created by Jercan on 2023/10/9.
//

import Then
import Action
import RxSwift
import ZJLocalAuth

enum BiometricsType: Int {
    
    case touch = 1
    case face  = 2
    
    static var current: BiometricsType? {
        if ZJLocalAuth.isFaceIDCapable { return .face }
        if ZJLocalAuth.isTouchIDCapable { return .touch }
        return nil
    }
    
    fileprivate static var evaluateReason: String {
        switch current {
        case .touch:
            return Locale.touchIdEvaluateReason.localized
        case .face:
            return Locale.faceIdEvaluateReason.localized
        case .none:
            return ""
        }
    }
    
}

final class BiometricsAuthManager {
    
    let uid: String
    
    let account: String
    
    private var util: ZJLocalAuth
    
    private let disposeBag = DisposeBag()
    
    let loginAction = Action<(account: String, id: String), Request.biometry.LoginResult> {
        Request.biometry.login(account: $0.account, id: $0.id)
    }
    
    init(uid: String, account: String) {
        self.uid = uid
        self.account = account
        util = .init(uid: uid)
        bindAction()
    }
    
    private func bindAction() {
        
        loginAction.elements.subscribe(onNext: { [weak self] in
            
            if case .success(let data) = $0 {
                self?.util.biometryID = data.biometricsId
            } else if case .invalid = $0 {
                self?.util.biometryID = nil
                self?.util.isUserEnabled = false
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}

extension BiometricsAuthManager {
    
    static func canLoginByBiometrics(uid: String) -> Bool {
        
        let auth = ZJLocalAuth(uid: uid)
        return auth.isUserEnabled && (auth.biometryID != nil)
        
    }

    func evaluate(completion: @escaping (ZJLocalAuth.Result) -> Void) {
        
        util.evaluate(reason: BiometricsType.evaluateReason) {
            debugPrint($0)
            completion($0)
        }
        
    }
    
    func loginByBiometrics() {
        
        let bioId = util.biometryID ?? ""
        
        if bioId.isEmpty {
            debugPrint("biometry is null when login")
        }
        
        loginAction.execute((account: account, id: bioId))
        
    }
    
    func refreshBiometricsIdIfNeeded() {
        
        guard util.isUserEnabled, util.biometryID == nil else { return }
        
        Request.biometry.fetchBiometricsId(account: account) {
            switch $0 {
            case .success(let id):
                self.util.biometryID = id
            case .failure(let err):
                debugPrint(err.localizedDescription)
            }
        }
        
    }
    
    func disbleBiometryLogin() {
        util.biometryID = nil
        util.isUserEnabled = false
    }
    
    func clearLastBiometryData() {
        util.resetBiometryData()
    }
    
}

extension ZJLocalAuth.Result {
    
    var errorToast: String? {
        switch self {
        case .success:
            return nil
        case .failed:
            return Locale.evaluationFailToast.localized
        case .userCancel, .appCancel, .systemCancel, .userFallBack:
            return nil
        case .passcodeNotSet:
            return Locale.passcodeNotSetToast.localized
        case .biometryNotEnrolled:
            switch BiometricsType.current {
            case .touch:
                return Locale.touchNotEnrolledToast.localized
            case .face:
                return Locale.faceNotEnrolledToast.localized
            case .none:
                return nil
            }
        case .biometryLockout:
            return Locale.biometryLockoutToast.localized
        case .biometryNotAvailable:
            switch BiometricsType.current {
            case .touch:
                return Locale.touchIdunavailableToast.localized
            case .face:
                return Locale.faceIdunavailableToast.localized
            case .none:
                return nil
            }
        case .credentialChanged:
            switch BiometricsType.current {
            case .touch:
                return Locale.touchChangedToast.localized
            case .face:
                return Locale.faceChangedToast.localized
            case .none:
                return nil
            }
        }
    }
    
}
