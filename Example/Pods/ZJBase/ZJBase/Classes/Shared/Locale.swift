//
//  Locale.swift
//  ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import ZJLocalizable

enum Locale: String {
    
    case locationHint
    case cancel
    case yes
    
}

extension Locale: ZJLocalizable {
    
    var key: String { rawValue }
    
    var table: String { "Locale" }
    
    var bundle: Bundle { .framework_ZJBase }

}


