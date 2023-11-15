//
//  AssetsBalanceInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import RxSwift

struct AssetsBalanceInfo: AssetsSecureProtocol {
    
    let rate: NSNumber
    
    let balance: NSNumber
    
    let isSecureText: Observable<Bool>
    
}

extension AssetsBalanceInfo {
    
    var rateDesc: String? {
        Int(truncating: rate) > 0 ? rate.rateValue : nil
    }
    
    var balanceDesc: String? {
        balance.amountValue
    }
    
}
