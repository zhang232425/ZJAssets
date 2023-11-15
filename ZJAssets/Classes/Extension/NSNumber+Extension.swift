//
//  NSNumber+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import ZJCommonDefines
import SwiftDate

extension NSNumber {
    
    var seconds: TimeInterval { .init(doubleValue / 1000) }
    
    var amountValue: String? {
        string(withScale: 0, symbol: "\(ZJCountry.currencyCode) ")
    }
    
    var assetsValue: String? {
        if Int(truncating: self) >= 0 {
            return string(withScale: 0, symbol: "+\(ZJCountry.currencyCode) ")
        }
        return string(withScale: 0, symbol: "\(ZJCountry.currencyCode) ")
    }
    
    var rateValue: String? {
        
        let formtter = NumberFormatter()
        formtter.numberStyle = .decimal
        formtter.maximumFractionDigits = 0
        formtter.minimumFractionDigits = 0
        formtter.decimalSeparator = "."
        formtter.roundingMode = .down
        
        if let val = formtter.string(from: self) {
            return "+\(val)%"
        }
        
        return nil
        
    }
    
    func string(withScale scale: Int = 2, symbol: String = "") -> String? {
        
        let formtter = NumberFormatter()
        formtter.groupingSize = 3
        formtter.numberStyle = .currency
        formtter.currencySymbol = symbol
        formtter.roundingMode = .down
        formtter.decimalSeparator = ","
        formtter.maximumFractionDigits = scale
        formtter.minimumFractionDigits = scale
        formtter.currencyGroupingSeparator = "."
        formtter.locale = Locales.indonesianIndonesia.toLocale()
        
        return formtter.string(from: self)
        
    }
    
}

extension NSNumber {
    
    var earningColor: UIColor {
        
        if Int(truncating: self) > 0 {
            return .init(hexString: "1CB395")
        } else if Int(truncating: self) < 0 {
            return .init(hexString: "FF4D4F")
        } else {
            return .init(hexString: "999999")
        }
        
    }
    
}
