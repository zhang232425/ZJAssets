//
//  HistoryDetailModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import HandyJSON

struct HistoryDetailProduct: HandyJSON {
    
    var orderId: String?
    
    var productName = ""
    
    var amount = Double(0)
    
}

struct HistoryDetailFlow: HandyJSON {
    
    var flowTime: Double = 0
    
    var title = ""
    
    var subTitle: String?
    
}

struct HistoryDetailModel: HandyJSON{
    
    var id = ""
    
    var type = HistoryRecordType.other
    
    var orderId = ""
    
//    var orderType = OrderType.fixed
    
    var title = ""
    
    var totalAmount = Double(0)
    
    var createTime = NSNumber(value: 0)
    
    var products: [HistoryDetailProduct] = []
    
    var transactionFlow: [HistoryDetailFlow] = []
    
}

