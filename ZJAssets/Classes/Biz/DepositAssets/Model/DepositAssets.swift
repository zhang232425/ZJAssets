//
//  DepositAssets.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import HandyJSON

struct DepositAssets {

    /// 总金额
    var balance = NSNumber(value: 0)
    /// 总收益
    var totalIncome = NSNumber(value: 0)
    /// 昨日收益
    var lastIncome = NSNumber(value: 0)
    /// 待签名订单数量
    var unsignCount = 0
    /// 预约订单入口是否显示
    var displayAppointment = false
    /// 待确认的预约订单数
    var appointOrderToConfirmCount = 0
    
}

extension DepositAssets: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< unsignCount <-- "signingCount"
        
        mapper <<< displayAppointment   <-- "appointEntrance"
        
    }
    
}
