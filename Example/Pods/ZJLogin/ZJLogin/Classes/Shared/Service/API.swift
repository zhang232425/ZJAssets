//
//  API.swift
//  Pods-ZJLogin_Example
//
//  Created by Jercan on 2023/9/12.
//

import ZJCommonDefines
import ZJRequest
import Moya

enum API {

    // MARK: -  ------ 注册 --------
    /// 注册页面文案
    case registerTips
    /// 注册
    case register(account: String, captcha: String, deviceToken:String?, analyticsId: String?)
    /// 是否设置了字符密码
    case isSetStringPassword
    
    // MARK: -  ------ 登录 --------
    /// 密码登录
    case loginByPassword(account: String, password: String, captcha: String?)
    /// 短验登录
    case loginBySMSCode(account: String, smsCode: String)
    /// 设置字符密码
    case setStringPassword(password: String, accessToken: String)
    /// 校验:忘记密码获取的验证码
    case checkForgotPasswordCaptcha(account: String, captcha: String)
    /// 忘记密码后重置密码
    case resetStringPasswordWhenForgot(account: String, captcha: String, newPasswordMask: String)
    
    //// // biometricsType: 1 - 指纹，2 - 人脸
    /// 获取生物特征信息(TouchId或FaceId)
    case fetchBiometricInfo(account: String, biometricsType: Int)
    /// 校验生物特征登录(TouchId或FaceId)
    case checkBiometrics(account: String, biometricsType: Int, biometricsId: String)
    
    // MARK: - ------- 获取验证码 -------
    /// 获取验证码-登录
    case getCaptcha_login(account: String, imageCaptcha: String?)
    /// 获取验证码-注册
    case getCaptcha_register(account: String, imageCaptcha: String?)
    /// 获取验证码-忘记密码
    case getCaptcha_forgotPwd(account: String, imageCaptcha: String?)
    /// 输入邀请码
    case inputReferralCode(code: String)
    
    /// MARK: - 手势密码
    case setGesture(gesture: String, loginPwd: String)
    case resetGesture(loginPwd: String?, gesture: String?, newGesture: String?)
    case checkGesture(gesture: String, type: Int)
    
    
}

extension API: ZJRequestTargetType {
    
    var baseURL: URL { URL(string: ZJUrl.server)! }
    
    var headers: [String : String]? {
        switch self {
        case .setStringPassword(_, let accessToken):
            return ["Authorization": accessToken]
        default:
            return nil
        }
    }

    var path: String {
        switch self {
            
        case .registerTips:
            return "/api/app/user/register/tips"
        case .register:
            return "/api/app/user/register"
        case .getCaptcha_register:
            return "/api/app/user/sms/captcha"
        case .getCaptcha_login:
            return "/api/app/user/sms/captcha"
        case .getCaptcha_forgotPwd:
            return "/api/app/user/getCaptchaNoToken"
        case .isSetStringPassword:
            return "/api/app/user/pwd/setting"
            
        case .checkForgotPasswordCaptcha:
            return "/api/app/user/checkCaptchaForNoToken"
            
        case .setStringPassword:
            return "/api/app/user/setLoginPassword"
        case .inputReferralCode:
            return "/api/app/user/setReferrer"
            
        case .resetStringPasswordWhenForgot:
            return "/api/app/user/resetLoginPassword"
            
        // 登录
        case .loginByPassword, .loginBySMSCode:
            return "/api/app/user/login"
        case .fetchBiometricInfo:
            return "/api/app/user/biometrics/enable"
        case .checkBiometrics:
            return "/api/app/user/biometrics/check"
            
        // 手势密码
        case .setGesture:
            return "/api/app/user/gesture/password/set"
        case .resetGesture:
            return "/api/app/user/gesture/password/reset"
        case .checkGesture:
            return "/api/app/user/gesture/password/check"
        
    
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerTips:
            return .get
        case .register:
            return .post
        case .getCaptcha_login:
            return .get
        case .getCaptcha_register:
            return .get
        case .getCaptcha_forgotPwd:
            return .get
        case .isSetStringPassword:
            return .get
            
        case .checkForgotPasswordCaptcha:
            return .post
            
        case .setStringPassword:
            return .post
        case .inputReferralCode:
            return .post
            
        case .resetStringPasswordWhenForgot:
            return .post
        
        case .loginByPassword, .loginBySMSCode:
            return .post
            
        case .checkBiometrics, .fetchBiometricInfo:
            return .post
            
        case .setGesture, .resetGesture, .checkGesture:
            return .post
            
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .registerTips:
            return .requestPlain
            
        case .register(let account, let captcha, let deviceToken, let analyticsId):
            var params: [String: Any] = ["phoneNumber": account,
                                        "captcha": captcha,
                                        "channel": "ios"]
            params["deviceToken"] = deviceToken
            params["adId"] = analyticsId
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .getCaptcha_login(let account, let captcha):
            var params: [String: Any] = ["phoneNumber": account, "smsBizType": 2]
            params["imageCaptcha"] = captcha
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .getCaptcha_register(let account, let captcha):
            var params: [String: Any] = ["phoneNumber": account, "smsBizType": 1]
            params["imageCaptcha"] = captcha
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .getCaptcha_forgotPwd(let account, let captcha):
            var params: [String: Any] = ["phoneNumber": account]
            params["imageCaptcha"] = captcha
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .setStringPassword(let password, _):
            let params: [String: Any] = ["password": password]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .inputReferralCode(let code):
            let params: [String: Any] = ["referrerCode": code]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .loginByPassword(let account, let password, let captcha):
            var params: [String: Any] = ["phoneNumber": account,
                                         "password": password,
                                         "passwordType": 1]
            params["captcha"] = captcha
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .loginBySMSCode(let account, let smsCode):
            let params: [String: Any] = ["phoneNumber": account,
                                        "password": smsCode,
                                        "passwordType": 3]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .isSetStringPassword:
            return .requestPlain
            
        case.checkBiometrics(let account, let biometricsType, let biometricsId):
            let params: [String: Any] = ["phoneNumber": account,
                                        "biometricsType": biometricsType,
                                        "biometricsId": biometricsId]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .fetchBiometricInfo(let account, let biometricsType):
            let params: [String: Any] = ["phoneNumber": account,
                                        "biometricsType": biometricsType]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .setGesture(let gesture, let loginPwd):
            let params: [String: Any] = ["gesture": gesture,
                                         "loginPwd": loginPwd]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .resetGesture(let loginPwd, let gesture, let newGesture):
            var params: [String: Any] = [:]
            params["loginPwd"] = loginPwd
            params["gesture"] = gesture
            params["newGesture"] = newGesture
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        case .checkGesture(let gesture, let type):
            let params: [String: Any] = ["gesture": gesture,
                                         "type": type]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .checkForgotPasswordCaptcha(let account, let captcha):
            var params: [String: Any] = [:]
            params["phoneNumber"] = account
            params["captcha"] = captcha
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .resetStringPasswordWhenForgot(let account, let captcha, let newPasswordMask):
            var params: [String: Any] = [:]
            params["phoneNumber"] = account
            params["captcha"] = captcha
            params["newPassword"] = newPasswordMask
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        }
    }

    var sampleData: Data { ".".data(using: .utf8)! }
    
    
}



