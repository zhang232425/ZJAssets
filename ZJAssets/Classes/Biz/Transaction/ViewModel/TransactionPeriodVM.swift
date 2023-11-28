//
//  TransactionPeriodVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import Foundation

final class TransactionPeriodVM {
    
    enum ModuleType: Int {
        case all        = 0
        case deposit    = 1
    }
    
    typealias DateInfo = PeriodsPickerView.DateInfo
    
    typealias PeriodsType = TimePeriodsView.SelectType
    
    let minPeriods: DateInfo = .init(year: 2016, month: 1, day: 1)
    
    let maxPeriods: DateInfo
    
    var startPeriods: DateInfo
    
    var endPeriods: DateInfo
    
    var selectMonth: DateInfo
    
    var selectedTypeIndex = 0
    
    var selectedPeriodsType = PeriodsType.lastMonth
    
    private let type: ModuleType
    
    init(type: ModuleType) {
        
        self.type = type
        
        let date = Date()
        
        maxPeriods = .init(year: date.year, month: date.month, day: date.day)
        
        startPeriods = .init(year: date.year, month: date.month, day: 1)
        
        endPeriods = .init(year: date.year, month: date.month, day: date.day)
        
        selectMonth = .init(year: date.year, month: date.month, day: 1)
        
    }
    
    func isPeriodValid() -> Bool {
        
        guard let end = endTime,
              let start = startTime,
              start.nextYear >= end else {
            return false
        }
        
        return true
        
    }
    
}

extension TransactionPeriodVM {
    
    var trackMonth: String? {
        if let start = startMonthTime?.timeInterval,
           let end = endMonthTime?.timeInterval {
            return "\(start)-\(end)"
        }
        return nil
    }
    
    var trackPeriod: String? {
        if let start = startTime?.timeInterval,
           let end = endTime?.timeInterval {
            return "\(start)-\(end)"
        }
        return nil
    }
    
    var trackStartInterval: String? {
        if let start = startTime?.timeInterval {
            return "\(start)"
        }
        return nil
    }
    
    var trackEndInterval: String? {
        if let end = endTime?.timeInterval {
            return "\(end)"
        }
        return nil
    }
    
}

extension TransactionPeriodVM {
    
    var startTime: Date? { startPeriods.date }
    
    var endTime: Date? { endPeriods.date }
    
    var startMonthTime: Date? { selectMonth.date }
    
    var endMonthTime: Date? { startMonthTime?.nextMonth }
    
}

extension TransactionPeriodVM {
    
    var startPeriodsFormat: String { startPeriods.format }
    
    var endPeriodsFormat: String { endPeriods.format }
    
}

private extension TransactionPeriodVM.DateInfo {
    
    var format: String {
        numFormat(day) + "/" + numFormat(month) + "/" + "\(year)"
    }
    
    func numFormat(_ num: Int) -> String {
        num > 9 ? "\(num)" : "0\(num)"
    }
    
    var date: Date? {
        format.toDate(style: .custom("dd/MM/yyyy"))?.date
    }
    
}
