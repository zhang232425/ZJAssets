//
//  LoginResultRouter.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/7.
//

import ZJHUD
import Action
import RxSwift
import ZJRequest
import ZJLoginManager
import ZJCommonDefines

final class LoginResultRouter {
    
    typealias LoginData = Request.login.Result.Data
    
    enum UserEntry {
        case sms(accessToken: String, account: String)
        case pwd(pwd: String, account: String)
        case biometry(accessToken: String, account: String)
    }
    
    private var checkHasPasswordAction = Action<Void, Bool>(workFactory: { Request.checkHasPassword() })
    private var fetchUserProfileAction = Action<Void, ZJUserProfile?>(workFactory: { Request.fetchUserProfile() })
    
    private let entry: UserEntry
    
    private let data: LoginData
    
    var routeCompletion : (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    init(entry: UserEntry, data: LoginData) {
        
        self.entry = entry
        self.data = data
        
        ZJLoginModule.loginResultRouter = self
        
        Observable.merge(checkHasPasswordAction.underlyingError,
                         fetchUserProfileAction.underlyingError)
        .subscribe(onNext: {
            ZJHUD.noticeOnlyText($0.localizedDescription)
        }).disposed(by: disposeBag)
                
        let executing1 = checkHasPasswordAction.executing
        let executing2 = fetchUserProfileAction.executing
        Observable.combineLatest(executing1, executing2)
            .map { $0 || $1 }.distinctUntilChanged()
            .subscribe(onNext: {
                if $0 {
                    ZJHUD.showProgress(type: .dimBackground(color: nil))
                } else {
                    ZJHUD.hideProgress()
                }
            }).disposed(by: disposeBag)
        
        
        Observable.zip(checkHasPasswordAction.elements,
                       fetchUserProfileAction.elements)
        .subscribe(onNext: { [weak self] in
            self?.handleResult(hasPassword: $0.0, profile: $0.1)
        }).disposed(by: disposeBag)
    
    }
    
}

private extension LoginResultRouter {
    
    func handleResult(hasPassword: Bool, profile: ZJUserProfile?) {
        
        if let uid = profile?.userId, let account = profile?.phoneNumber {
            let mgr = BiometricsAuthManager(uid: uid, account: account)
            switch entry {
            case .sms, .pwd:
                mgr.clearLastBiometryData()
            case .biometry: break
            }
            mgr.refreshBiometricsIdIfNeeded()
        }
        
        if let data = profile {
            LastUserInfo.save(data)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: ZJNotification.didLogin, object: nil)
        }
        
        Self.onLoginSuccess(hasPassword: hasPassword,
                            hasGesture: data.isSetGesture,
                            entry: entry,
                            completion: routeCompletion)
        
    }
    
    static func onLoginSuccess(hasPassword: Bool,
                               hasGesture: Bool,
                               entry:UserEntry,
                               completion: (() -> Void)?) {
        
        if hasPassword, hasGesture {
            dismissOnLoginSuccess(completion: completion)
        } else if hasPassword, !hasGesture {
            switch entry {
            case .sms, .biometry:
                dismissOnLoginSuccess(completion: completion)
            case .pwd(let pwd, _):
                setGestureOnLoginSuccess(password: pwd, completion: completion)
            }
        } else if !hasPassword, !hasGesture {
            switch entry {
            case .sms(let accessToken, _), .biometry(let accessToken, _):
                setPasswordOnLoginSuccess(accessToken: accessToken, completion: completion)
            case .pwd:
                break
            }
        }
        
    }
    
    static func setPasswordOnLoginSuccess(accessToken: String, completion: (() -> Void)?) {
        
        let topvc = UIApplication.shared.topViewController
        topvc?.route.enter(.setPassword(accessToken: accessToken, onSuccess: { pwd in
            setGestureOnLoginSuccess(password: pwd, completion: completion)
        }, onSkip: {
            dismissOnLoginSuccess(completion: completion)
        }))
    }
    
    static func setGestureOnLoginSuccess(password: String, completion: (() -> Void)?) {
        
        let topvc = UIApplication.shared.topViewController
        topvc?.route.enter(.initGesture(password: password, loginCompletion: completion))
        
    }
    
    static func dismissOnLoginSuccess(completion: (() -> Void)?) {
        
        let topvc = UIApplication.shared.topViewController
        topvc?.navigationController?.dismiss(animated: true) {
            NotificationCenter.default.post(name: ZJNotification.didLoginCompletion, object: nil)
            completion?()
        }
        
    }
    
}

extension LoginResultRouter {
    
    func routeOnLoginSuccess() {
        
        let manager = ZJLoginManager.shared
        manager.login(accessToken: data.accessToken)
        switch entry {
        case .sms(_, let account),
             .pwd(_, let account),
             .biometry(_, let account):
            manager.lastLoginAccount = account
        }
        
        checkHasPasswordAction.execute()
        fetchUserProfileAction.execute()
    }
    
}

private extension Request {
    
    static func fetchUserProfile() -> Single<ZJUserProfile?> {
        
        .create { single -> Disposable in
            ZJLoginManager.shared.fetchUserProfile(success: {
                single(.success($0))
            }, failure: {
                single(.failure($0))
            })
            return Disposables.create {}
        }
    }
    
    static func checkHasPassword() -> Single<Bool> {
        
        API.isSetStringPassword.rx.request()
            .mapObject(ZJRequestResult<[String: Any]>.self)
            .map { root -> Bool in
                (root.data?["hasLoginPassword"] as? Bool) ?? true
            }
        
    }
    
}

