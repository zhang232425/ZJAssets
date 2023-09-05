//
//  ZJNotification.swift
//  Pods-ZJCommonDefines_Example
//
//  Created by Jercan on 2023/9/5.
//

import Foundation

public struct ZJNotification {}

public extension ZJNotification {
    
    /// 登录
    static let didLogin = NSNotification.Name(rawValue: "notification.name.as.didLogin")
    
    /// 登录完成（登录成功且离开时才发送 eg: 密码登录后，若进入手势页面，通知在手势设置完成或返回时发送）
    static let didLoginCompletion = Notification.Name(rawValue: "notification.name.as.didLoginCompletion")
    
    static let didLogout = Notification.Name(rawValue: "notification.name.as.didLogout")
    
    /// 注册成功（设置登录密码成功）
    static let didRegister = Notification.Name(rawValue: "notification.name.as.didRegister")
    
    /// 被踢下线
    static let didKickOff = Notification.Name(rawValue: "notification.name.as.didKickOff")
    
    /// token过期
    static let tokenExpired = Notification.Name(rawValue: "notification.name.as.tokenExpired")
    
    /// 下单成功
    static let didOrder = Notification.Name(rawValue: "notification.name.as.didOrder")
    
    /// 支付成功
    static let didPay = Notification.Name(rawValue: "notification.name.as.didPay")
    
    /// 收到推送消息（用户中心刷新、消息列表刷新）
    static let receiveNews = Notification.Name(rawValue: "notification.name.as.receiveNews")
    
    /// RM/BA下线支付成功
    static let didRMPay = Notification.Name(rawValue: "notification.name.as.didRMPay")
        
    /// deeplink处理，object: {"type": 2 输入邀请码页/3优惠券列表页 "referrerCode": 字符串，type为2的时候才有值}
    static let handleDeeplink = Notification.Name(rawValue: "notification.name.as.handleDeeplink")
    
    /// 用户信息已刷新
    static let userProfileUpdated = Notification.Name(rawValue: "notification.name.as.userProfileUpdated")
    
    /// 回到tabbar指定位置通知
    static let tabbarIndexShow = Notification.Name(rawValue: "notification.name.as.tabbarIndexShow")
    
    /// 回到首页home，进入到p2p
    static let homeEnterP2P = Notification.Name(rawValue: "notification.name.as.homeEnterP2P")
    
    /// 授权登录通知
    static let authorizeLogin = Notification.Name(rawValue: "notification.name.as.authorizeLogin")

    /// 完善信息(完成后通知)
    static let completeInfoFinish = Notification.Name(rawValue: "notification.name.as.completeInfoFinish")
    
    /// kyc邮箱输入
    static let kycEmailInput = Notification.Name(rawValue: "notification.name.as.kycEmailInput")
    
    /// kyc邮箱验证码校验
    static let kycEmailCode = Notification.Name(rawValue: "notification.name.as.kycEmailCode")
    
}
