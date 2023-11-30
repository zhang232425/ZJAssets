//
//  OrderDetailVM+Handle.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import Foundation

extension OrderDetailVM {
    
    func getTransactionInfo(_ model: OrderModel) -> OrderDetailTransactionInfo {
        let transactionNo = Locale.transaction.localized + "\(model.id)"
        let transactionRecords = Locale.transcation_records.localized + ">"
        return OrderDetailTransactionInfo(transactionNo: transactionNo, transactionRecords: transactionRecords)
    }
    
}
