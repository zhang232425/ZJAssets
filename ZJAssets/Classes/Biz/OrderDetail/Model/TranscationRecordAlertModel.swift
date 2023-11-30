//
//  TranscationRecordAlertModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import Foundation
import HandyJSON

struct TranscationRecordAlertResult: HandyJSON {
    
    var `in` = [TranscationRecordAlertModel]()
    var out = [TranscationRecordAlertModel]()
    
}

struct TranscationRecordAlertModel: HandyJSON {
    
    var name = ""
    var amount = Double(0)
    var createTime = NSNumber(value: 0)
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< name         <-- "note"
        mapper <<< createTime    <-- "operationTime"
    }
    
}

