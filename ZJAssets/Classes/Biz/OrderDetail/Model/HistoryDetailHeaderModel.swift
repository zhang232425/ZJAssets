//
//  HistoryDetailHeaderModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation

struct HistoryDetailHeaderModel {
        
    struct Info {

        let title: String
        
        let amount: String
        
        let content: String?
        
        init(model: HistoryDetailProduct) {
            
            title = model.productName
            amount = model.amount.dd.money()
            content = Locale.order_id.localized + ":" + (model.orderId ?? "")
            
        }
        
    }
    
    let title: String
    
    let amount: String
    
    let time: String?
    
    /// 区分样式（提现与非提现）
    let isWithdraw: Bool
    
    let infos: [Info]
    
    init(model: HistoryDetailModel) {
        
        title = model.title
        amount = model.totalAmount.dd.money()
        
        if case .withdrawalSuccessfulNew = model.type {
            isWithdraw = true
        } else {
            isWithdraw = false
        }
        
        time = model.createTime.dmyDateMinute()
        
        infos = model.products.map { Info(model: $0) }
        
    }
    
}
