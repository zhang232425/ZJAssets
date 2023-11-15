//
//  ChartInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/14.
//

import HandyJSON

struct ChartInfo: HandyJSON {
    
    var date = NSNumber(value: 0)
    
    var income = NSNumber(value: 0)
    
}

struct ChartResult: HandyJSON {
    
    var items: [ChartInfo]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< items <-- "monthlyIncommeTrend"
    }
    
}
