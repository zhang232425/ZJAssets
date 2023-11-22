//
//  Date+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import SwiftDate
import ZJLocalizable

extension TimeInterval {
    
    func dateString(format: String = "dd/MM/yyyy HH:mm") -> String? {
        
        let date = Date(seconds: self)
        
        let locale: Locales
        
        switch ZJLocalizer.currentLanguage {
        case .en:
            locale = Locales.english
        case .id:
            locale = Locales.indonesianIndonesia
        }
        
        return date.formatter(format: format) {
            $0.locale = locale.toLocale()
            $0.timeZone = Zones.current.toTimezone()
        }.string(from: date)
        
    }
    
}

extension Int64 {
    
    var getCountDownTime: String {
        
        if self == 0 {
            return "00:00:00"
        }
        let minute: Int = Int(self / 60) % 60
        let hour: Int = Int(self / (60 * 60))
        let second: Int = Int(self % 60)
        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        let secondStr = second < 10 ? "0\(second)" : "\(second)"
        return "\(hourStr):\(minuteStr):\(secondStr)"
        
    }
    
    var getMinutesAndSecondsTime: String {
        
        if self == 0 {
            return "00:00"
        }
        let minute: Int = Int(self / 60)
        let second: Int = Int(self % 60)
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        let secondStr = second < 10 ? "0\(second)" : "\(second)"
        return "\(minuteStr):\(secondStr)"
        
    }
    
}
