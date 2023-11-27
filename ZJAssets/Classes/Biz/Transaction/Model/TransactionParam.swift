//
//  TransactionParam.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import HandyJSON
import SwiftDate

struct TransactionParam {
    
    var page: Int?
    
    var startTime: Date?
    
    var endTime: Date?
    
    var tradeType: Int?
    
    var productType: Int?
    
}

extension TransactionParam: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
                
        mapper <<< startTime   <-- ("beginTime", TransformOf<Date, String>(fromJSON: { _ in nil },
                                                                           toJSON: { $0?.timeInterval }))
        
        mapper <<< endTime     <-- TransformOf<Date, String>(fromJSON: { _ in nil },
                                                             toJSON: { $0?.timeInterval })
        
        mapper <<< tradeType   <-- "typeGroup"
        
        mapper <<< productType <-- "systemGroup"
        
    }
    
}
