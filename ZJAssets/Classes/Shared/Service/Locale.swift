//
//  Locale.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import ZJLocalizable

enum Locale: String {
    case unpayOrderTip
    case unpayOrdersTip
    case assets
    case totalAsset
    case yestdayIncome
    case totalIncome
}

extension Locale: ZJLocalizable {
    
    var key: String { rawValue }
     
    var table: String { "Locale" }
    
    var bundle: Bundle { .framework_ZJAssets }
    
}
