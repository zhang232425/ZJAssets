//
//  DepositAssetsHeaderInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import Foundation
import RxSwift

struct DepositAssetsHeaderInfo: AssetsSecureProtocol {
    
    let totalAmount: NSNumber
    
    let totalEarning: NSNumber
    
    let yestdayEarning: NSNumber
        
    let isSecureText: Observable<Bool>
    
}

extension DepositAssetsHeaderInfo {
    
    init(assets: DepositAssets, isSecureText: Observable<Bool>) {
        self.init(totalAmount: assets.balance,
                  totalEarning: assets.totalIncome,
                  yestdayEarning: assets.lastIncome,
                  isSecureText: isSecureText)
    }
    
}
