//
//  DepositIncome.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import Foundation
import HandyJSON

enum IncomeStatus: Int, HandyJSONEnum {
    //已支付
    case paid = 2
    //匹配中
    case matching = 602
    //匹配成功
    case matched = 604
    //持有中
    case hold = 606
    //正常到期
    case expired = 4
    //已转出
    case withdraw = 16
    //已续投
    case renew = 512
}

struct DepositIncome {
    
    var orderId = ""
    
    var productId = ""
    
    var type = DepositOrderType.fixed
    
    var name = ""
    
    var status: IncomeStatus?
    
    var statusDesc = ""
    
    var amount = NSNumber(value: 0)
    
}

extension DepositIncome: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< orderId      <-- "id"
        
        mapper <<< type         <-- "orderType"
        
        mapper <<< amount       <-- "totalIncome"
        
        mapper <<< statusDesc   <-- "statusFormat"
        
    }
    
}

struct DepositIncomePage: HandyJSON {
    
    var list: [DepositIncome]?
    
    var nextPage: Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< list <-- "content"
    }
    
}
