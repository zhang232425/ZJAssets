//
//  Double+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation

extension Double: NamespaceWrappable {}

extension NamespaceWrapper where T == Double {
    
    /// 带符号金额 + RP 10.000
    func money() -> String {
        
        let isNegative = warppedValue < 0
        let m = isNegative ? warppedValue * -1 : warppedValue
        return (isNegative ? "-" : "+") + NSNumber(value: m).money()
        
    }
    
}
