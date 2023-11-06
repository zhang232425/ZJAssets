//
//  RegisterTipsModel.swift
//  Action
//
//  Created by Jercan on 2023/9/13.
//

import HandyJSON

struct RegisterTipsModel: HandyJSON {
    
    var full = ""
    var bold = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< full <-- "fullText"
        mapper <<< bold <-- "boldText"
    }
    
}
