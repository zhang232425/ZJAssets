//
//  Date+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import SwiftDate
import ZJLocalizable

extension Date {
    
    var lastMonth: Date { self - 1.months }
    
    var last3Month: Date { self - 3.months }
    
    var lastYear: Date { self - 1.years }
    
    var nextDay: Date { self + 1.days }
    
    var nextMonth: Date { self + 1.months }
    
    var nextYear: Date { self + 1.years }
    
    var timeInterval: String? {
        
        let format = "yyyy/MM/dd"
        
        if let interval = DateInRegion(self, region: .current).toString(.custom(format))
            .toDate(style: .custom(format), region: .current)?.timeIntervalSince1970 {
            return "\(interval * 1000)".components(separatedBy: ".").first
        }
        
        return nil
        
    }
    
    var monthFormat: String {
        toString(.custom("MM/yyyy"))
    }
    
    var periodFormat: String {
        toString(.custom("dd/MM/yyyy"))
    }
    
}

extension TimeInterval {
    
    var countDownTime: String {
        
        let now = Date()
        
        let future = now.addingTimeInterval(self)
        
        guard now < future else { return "00:00:00" }
        
        let gap = future - now
        
        var totalHours = 0
        
        var totalMinutes = 0
        
        var totalSeconds = 0
        
        if let year = gap.year {
            totalHours += year * 365 * 24
        }
        
        if let month = gap.month {
            totalHours += month * 30 * 24
        }
        
        if let day = gap.day {
            totalHours += day * 24
        }
        
        if let hour = gap.hour {
            totalHours += hour
        }
        
        if let minute = gap.minute {
            totalMinutes += minute
        }
        
        if let second = gap.second {
            totalSeconds += second
        }
        
        let hourStr = totalHours < 10 ? "0\(totalHours)" : "\(totalHours)"
        
        let minuteStr = totalMinutes < 10 ? "0\(totalMinutes)" : "\(totalMinutes)"
        
        let secondStr = totalSeconds < 10 ? "0\(totalSeconds)" : "\(totalSeconds)"
        
        return "\(hourStr):\(minuteStr):\(secondStr)"
        
    }
    
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
