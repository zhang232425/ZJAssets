//
//  UIViewController+route.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/20.
//

import ZJBase
import ZJCommonDefines

struct Route<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol Routable {
    associatedtype RouteBase
    var route: Route<RouteBase> { get }
}

extension Routable {
    var route: Route<Self> { Route(self) }
}

enum PageRouteTarget {
    case login(completion: (() -> Void)?)
    case register
    case initGesture(password: String, loginCompletion: (() -> Void)?)
    case agreement(url: URL)
    case forgotPassword
    case initPassword(account: String, accessToken: String)
    case setPassword(accessToken: String, onSuccess: (String) -> Void, onSkip: ()-> ())
    case resetPassword(account: String, captcha: String)
    case setReferralcode
}

enum AlertRouteTarget {
    case imageCaptch(account: String, onConfirm: (String) -> Void)
    case smsCaptcha(account: String, onConfirm: (String) -> Void)
    case newRegistration(account: String, captcha: String)
    case duplicatedAccount(account: String, smsCode: String)
}

extension UIViewController: Routable {}

extension Route where Base: UIViewController {
    
    func enter(_ target: PageRouteTarget) {
        UIApplication.shared.enter(target)
    }
    
    func present(_ target: AlertRouteTarget) {
        UIApplication.shared.present(target)
    }
    
}

private extension UIApplication {
    
    func enter(_ target: PageRouteTarget) {
        
        switch target {
        case .login(let completion):
            print("登录")
            
        case .register:
            print("注册")
            
        case .initGesture(let password, let loginCompletion):
            if let nav = topViewController?.navigationController {
                let vc = GestureSetupViewController(type: .enable, isFromLogin: true, loginPassword: password)
                vc.loginCompletion = {
                    NotificationCenter.default.post(name: ZJNotification.didLoginCompletion, object: nil)
                    loginCompletion?()
                }
                nav.pushViewController(vc, animated: true)
            }
            
        case .agreement(let url):
            print("同意协议")
            
        case .forgotPassword:
            
            if let nav = topViewController?.navigationController {
                nav.pushViewController(ForgotPasswordController(), animated: true)
            }
            
        case .initPassword(let account, let accessToken):
            if let nav = topViewController?.navigationController {
                let vc = InitPasswordController(account: account, accessToken: accessToken)
                nav.pushViewController(vc, animated: true)
            }
            
        case .setPassword(let accessToken, let onSuccess, let onSkip):
            print("设置密码")
            
        case .resetPassword(let account, let captcha):
            
            if let nav = topViewController?.navigationController {
                nav.pushViewController(ResetPasswordController(account: account, captcha: captcha), animated: true)
            }
            
        case .setReferralcode:
            
            if let nav = topViewController?.navigationController {
                let vc = SetReferralcodeController()
                nav.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    func present(_ target: AlertRouteTarget) {
        
        
        guard let topvc = topViewController else { return }
        
        switch target {
        case .imageCaptch(let account, let onConfirm):
            print("imageCaptch")
        case .smsCaptcha(let account, let onConfirm):
            print("smsCaptcha")
        case .newRegistration(let account, let captcha):
            print("newRegistration")
        case .duplicatedAccount(let account, let smsCode):
            let vc = DuplicatedAccountAlertController(account: account, smsCode: smsCode)
            topvc.present(vc, animated: true)
        }
        
    }
    
}
