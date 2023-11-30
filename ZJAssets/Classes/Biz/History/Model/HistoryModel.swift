//
//  HistoryModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import HandyJSON

enum HistoryRecordType: Int, HandyJSONEnum {
    case refund                      = 2  // 退款(旧状态)
    case withdrawalSuccessfulOld     = 3  // 提现成功(旧状态)
    case withdrawalSuccessfulNew     = 31 // 提现成功(新状态)
    case payment                     = 5  // 支付成功
    case reLendTransferOut           = 7  // 订单续投转出
    case dividendSuccess             = 8  // 利息发送完毕(旧状态)
    case coupons                     = 9  // 使用优惠券
    case dailyDividend               = 10 // 每天派息
    case other                       = -999// 异常类型
    case insurancePaid               = 59 // 保险支付
    case insuranceRefund             = 29 // 保险退款
    case returnPremium               = 100 // P2P提前还款退还的保费
    case badDebt                     = 15  // 坏账
}

struct HistoryResult: HandyJSON {
    
    var nextPage: String?
    
    var content: [HistoryModel]?
    
}

struct HistoryModel: HandyJSON {
    
    var id: String = ""
    
    var amount: Double = 0
    
    var name = ""
    
    // 业务Id(当前指OrderId)
    var refId: String = ""
    
    // 流水类型
    var type = HistoryRecordType.other
    
    // 交易时间
    var createTime = NSNumber(value: 0)
    
    // 订单类型
//    var orderType = OrderType.fixed
    
    // 优惠券描述(决定cell展示样式)
    var coupon: String?
    
    // 理财中的金额
    var financing: Double = 0
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< refId            <-- TransformOf<String, Int64>(fromJSON: { "\($0 ?? 0)" },
                                                                   toJSON: { _ in nil })
    }
    
}

