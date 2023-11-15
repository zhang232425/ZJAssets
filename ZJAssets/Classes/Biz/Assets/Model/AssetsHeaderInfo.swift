//
//  AssetsHeaderInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import RxSwift

struct AssetsHeaderInfo: AssetsSecureProtocol {
 
    let totalAmount: NSNumber
    
    let totalEarning: NSNumber
    
    let yestdayEarning: NSNumber
    
    let unpayCount: Int
    
    let vipLevel: VipLevel
    
    let isSecureText: Observable<Bool>
    
}

extension AssetsHeaderInfo {
    
    init(baseInfo: AssetsBaseInfo, isSecureText: Observable<Bool>) {
        self.init(totalAmount: baseInfo.totalAmount,
                  totalEarning: baseInfo.totalIncome,
                  yestdayEarning: baseInfo.lastIncome,
                  unpayCount: baseInfo.unpaidCount,
                  vipLevel: baseInfo.vipLevel,
                  isSecureText: isSecureText)
    }
    
}

extension AssetsHeaderInfo {
    
    var unpayDesc: String {
        if unpayCount > 1 {
            return Locale.unpayOrdersTip.localized(arguments: "\(unpayCount)")
        }
        return Locale.unpayOrderTip.localized(arguments: "\(unpayCount)")
    }
    
}
