//
//  AssetsExtraInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/14.
//

import HandyJSON
import ZJCommonDefines

struct AssetsInfo: HandyJSON {
    
    enum AssetsType: String, CaseIterable, HandyJSONEnum {
        case flex     = "flexible"
        case deposit  = "fixed"
        case fund     = "fund"
        case gold     = "gold"
    }
    
    var amount = NSNumber(value: 0)
    
    var earning = NSNumber(value: 0)
    
    var name = ""
    
    var type = AssetsType.deposit
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< amount <-- "totalAmount"
        
        mapper <<< earning <-- "yesterdayEarnings"
        
    }
    
}

extension AssetsInfo.AssetsType {
    
    var tag: Int {
        switch self {
        case .flex:
            return 0
        case .deposit:
            return 1
        case .fund:
            return 2
        case .gold:
            return 3
        }
    }
    
}

struct InsureInfo: HandyJSON {
    
    var personCount = NSNumber(value: 0)
    
    var insureCount = NSNumber(value: 0)
    
    var isShowInsure: Bool?
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< personCount <-- "familyCount"
        
        mapper <<< insureCount <-- "insuranceCount"
        
        mapper <<< isShowInsure <-- "isShow"
        
    }
    
}

extension InsureInfo {
    
    var insuranceUrl: String { ZJUrl.insuranceService }
    
}

struct AssetsExtraInfo: HandyJSON {
    
    var assets: [AssetsInfo]?
    
    var insure: InsureInfo?
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< assets <-- "assetList"

        mapper <<< insure <-- "insurance"
        
    }
    
}
