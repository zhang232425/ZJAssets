//
//  DepositOrder.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import HandyJSON

//20 投资方待签名， 1- 区分是否产生Va码 payId有值就是待支付，payid没值就属于等待生成Va码， 2-已支付(和匹配中相同处理)，4-订单到期，602-匹配中，606-持有中，702-预期
enum DepositOrderStatus: Int, HandyJSONEnum {
    case unpaid           = 1
    case paid             = 2
    case expired          = 4
    case investWaitSign   = 20
    case matching         = 602
    case hold             = 606
    case overdue          = 702
}

// 续投状态 1-正常已到期，2-续投中，3-续投失败
enum DepositRenewStatus: Int, HandyJSONEnum {
    case expired    = 1
    case renew      = 2
    case failed     = 3
}

enum DepositOrderType: Int, HandyJSONEnum {
    case fixed    = 1  //定期 0、1、2都是定期
    case flexible = 3  //活期
    case advance  = 20 //消分
}

// 去签名（1-跳转投资人签名，2-调整投资人签借款人协议）
enum ToSigning: Int, HandyJSONEnum {
    case investorSign = 1
    case borrowerSign = 2
}

struct DepositOrder {
    
    var orderId = ""
    
    var productId = ""
    
    var name = ""
    
    var orderType = DepositOrderType.fixed
    
    var status = DepositOrderStatus.paid
    
    var continueStatus = DepositRenewStatus.expired
    
    var statusDesc = ""
    
    //订单总资产
    var totalAmount = NSNumber(value: 0)
    
    //剩余总资产
    var remainAmount = NSNumber(value: 0)
    
    var lastIncome = NSNumber(value: 0)
    
    var renewRate = NSNumber(value: 0)
    
    //控制自动续投按钮显示是否开启
    var autoBtn = false
    
    //使用绝对值判断 是否开启自动续投（0-未开启，1-已开启 ）
    var autoContinue = false
    
    var isRead = false
    
    //剩余到期天数
    var matureDays = "0"
    
    var autoTmplId = ""
    
    var autoTmplName = ""
    
    var endTime = ""
    
    //已有payId的情况下倒计时支付时间
    var expiredTime = NSNumber(value: 0)
    
    //没有payId的情况下待签名时间 或者 自己待签名时间
    var scheduledTime = NSNumber(value: 0)
    
    var payId = 0
    
    /// 去签名(1 默认跳转投资人签名， 2 投资人签借款人协议)
    var toSigning: ToSigning = .investorSign
    
    /// 逾期文案说明，status = 702
    var overdueExplain = ""
    
}

extension DepositOrder: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< orderId     <-- "id"
        
        mapper <<< statusDesc  <-- "statusFormat"
        
        mapper <<< totalAmount <-- "amount"
        
        mapper <<< renewRate   <-- "continueInterest"
        
        mapper <<< endTime     <-- TransformOf<String, NSNumber>(fromJSON: { $0?.seconds.dateString(format: "dd/MM/yyyy") }, toJSON: { _ in nil })
        
    }
    
}

struct DepositOrderPage: HandyJSON {
    
    var list: [DepositOrder]?
    
    var nextPage: Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< list <-- "content"
    }
    
}
