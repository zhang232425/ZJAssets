//
//  TransactionFilterItem.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import HandyJSON

struct FilterProductItem: HandyJSON {
    
    var name = ""
    
    var value = 0
    
    var enabledTradeItems: [Int]?
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< value             <-- "systemGroup"
        
        mapper <<< enabledTradeItems <-- "transactionTypeRelation"
        
    }
    
}

struct FilterTradeItem: HandyJSON {
    
    var name = ""
    
    var value = 0
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< value <-- "typeGroup"
    }
    
}

class FilterCategory: HandyJSON {
    
    var productItems: [FilterProductItem]?
    
    var tradeItems: [FilterTradeItem]?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<< productItems <-- "productType"
        
        mapper <<< tradeItems   <-- "transactionType"
        
    }
    
}

