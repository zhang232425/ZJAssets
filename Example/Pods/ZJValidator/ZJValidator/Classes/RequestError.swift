//
//  RequestError.swift
//  Pods-ZJValidator_Example
//
//  Created by Jercan on 2022/10/19.
//

import ZJLocalizable

public enum RequestError: String {
    
    //MARK: -App 转码错误
    case APP0001        = "APP.0001"

    //MARK: - 网络错误
    case TimeOut        = "TimeOut"

    //MARK: - System
    case SYSTEM0001     = "SYSTEM.0001"
    case SYSTEM0002     = "SYSTEM.0002"
    case SYSTEM0003     = "SYSTEM.0003"
    case SYSTEM0004     = "SYSTEM.0004"
    case SYSTEM0005     = "SYSTEM.0005"
    case SYSTEM0006     = "SYSTEM.0006"
    case SYSTEM0007     = "SYSTEM.0007"
    case SYSTEM0008     = "SYSTEM.0008"
    case SYSTEM0009     = "SYSTEM.0009"
    case SYSTEM0010     = "SYSTEM.0010"
    case SYSTEM0011     = "SYSTEM.0011"
    case SYSTEM0012     = "SYSTEM.0012"

    //MARK: - Profile
    case PROFILE0001    = "PROFILE.0001"
    case PROFILE0002    = "PROFILE.0002"
    case PROFILE0003    = "PROFILE.0003"
    case PROFILE0004    = "PROFILE.0004"
    case PROFILE0005    = "PROFILE.0005"
    case PROFILE0006    = "PROFILE.0006"
    case PROFILE0007    = "PROFILE.0007"
    case PROFILE0008    = "PROFILE.0008"
    case PROFILE0009    = "PROFILE.0009"
    case PROFILE0010    = "PROFILE.0010"
    case PROFILE0011    = "PROFILE.0011"
    case PROFILE0012    = "PROFILE.0012"
    case PROFILE0013    = "PROFILE.0013"

    //MARK: - HTTP
    case HTTP0001       = "HTTP.0001"
    case HTTP0002       = "HTTP.0002"

    //MARK: - Money
    case MONEY0001      = "MONEY.0001"
    case MONEY0002      = "MONEY.0002"

    //MARK: - Product
    case PRODUCT0001    = "PRODUCT.0001"
    case PRODUCT0002    = "PRODUCT.0002"
    case PRODUCT0003    = "PRODUCT.0003"
    case PRODUCT0004    = "PRODUCT.0004"

    //MARK: - Register/Validation
    case REGISTER0001   = "REGISTER.0001"
    case REGISTER0002   = "REGISTER.0002"
    case REGISTER0003   = "REGISTER.0003"
    case REGISTER0004   = "REGISTER.0004"
    case REGISTER0005   = "REGISTER.0005"
    case REGISTER0006   = "REGISTER.0006"
    case REGISTER0007   = "REGISTER.0007"
    case REGISTER0008   = "REGISTER.0008"
    case REGISTER0009   = "REGISTER.0009"

    //Mark: - Withdraw
    case WITHDRAW0001   = "WITHDRAW.0001"
    case WITHDRAW0002   = "WITHDRAW.0002"
    case WITHDRAW0003   = "WITHDRAW.0003"
    case WITHDRAW0004   = "WITHDRAW.0004"
    case WITHDRAW0005   = "WITHDRAW.0005"
    case WITHDRAW0006   = "WITHDRAW.0006"

    //Mark: - Balance
    case BALANCE0001    = "BALANCE.0001"

    //Mark: - Recharge
    case RECHARGE0001   = "RECHARGE.0001"
    case RECHARGE0002   = "RECHARGE.0002"
    case RECHARGE0003   = "RECHARGE.0003"
    case RECHARGE0004   = "RECHARGE.0004"
    case RECHARGE0005   = "RECHARGE.0005"

    //Mark: - Api
    case API0001        = "API.0001"
    case API0002        = "API.0002"

    //Mark: - Bankcard
    case BANKCARD0001   = "BANKCARD.0001"
    case BANKCARD0002   = "BANKCARD.0002"

    //Mark: - Pay
    case PAY0001        = "PAY.0001"
    case PAY0002        = "PAY.0002"

    //Mark: - Referrer
    case REFERRER0001   = "REFERRER.0001"
    case REFERRER0002   = "REFERRER.0002"
    case REFERRER0003   = "REFERRER.0003"
    case REFERRER0004   = "REFERRER.0004"

    //Mark: - Usertask
    case USERTASK0002   = "USERTASK.0002"

    //Mark: - Captcha
    case CAPTCHA0001    = "CAPTCHA.0001"
    case CAPTCHA0002    = "CAPTCHA.0002"
    case CAPTCHA0003    = "CAPTCHA.0003"

    //Mark: - SMS
    case SMS0002        = "SMS.0002"
    case SMS0003        = "SMS.0003"
    
    case PROFILE0106    = "PROFILE.0106"
    case PROFILE0112    = "PROFILE.0112"
    
}

extension RequestError: ZJLocalizable {
    
    public var key: String {
        return rawValue
    }
    
    public var table: String {
        return "RequestError"
    }
    
    public var bundle: Bundle {
        return .framework_ZJValidator
    }
    
}


extension Bundle {
    
    static var framework_ZJValidator: Bundle {
        let frameworkName = "ASValidator"
        let resourcePath: NSString = .init(string: Bundle(for: ZJValidatorClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJValidatorClass {}
    
}
