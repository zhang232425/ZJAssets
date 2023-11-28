//
//  PeriodsPickerView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import SwiftDate

class PeriodsPickerView: BaseView {
    
    struct DateInfo {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
    }
    
    private lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var years = [Int]()
    
    private lazy var months = [Int]()
    
    private lazy var days = [Int]()
        
    private var minDate = DateInfo(year: 2016, month: 1, day: 1)
    
    private var maxDate = DateInfo(year: Date().year, month: Date().month, day: Date().day)
    
    private var selectedDate = DateInfo()
    
    var selectHandler: ((DateInfo) -> Void)?
    
    func setInfo(minDate: DateInfo, maxDate: DateInfo, selectedDate: DateInfo) {
        
        self.minDate = minDate
        
        self.maxDate = maxDate
        
        self.selectedDate = selectedDate
        
        initData()
        
        selectRow()
        
    }
    
    override func setupViews() {
        
        pickerView.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        initData()
        
        selectRow()
        
    }
    
}

extension PeriodsPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        pickerView.bounds.width / 3.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        pickerView.bounds.height / 3.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel().then {
            $0.textColor = .init(hexString: "333333")
            $0.font = .regular16
            $0.textAlignment = .center
        }
        
        switch component {
        case 0:
            label.text = numFormat(days[row])
        case 1:
            label.text = numFormat(months[row])
        case 2:
            label.text = "\(years[row])"
        default:
            break
        }
        
        return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            selectedDate.day = days[row]
            
        case 1:
            selectedDate.month = months[row]
            reloadDay()
            
        case 2:
            selectedDate.year = years[row]
            reloadMonth()
            reloadDay()
            
        default:
            return
        }
        
        selectHandler?(selectedDate)
        
    }
    
}

extension PeriodsPickerView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }

}

private extension PeriodsPickerView {
    
    func initData() {
        
        years.removeAll()
        
        (minDate.year...maxDate.year).forEach { years.append($0) }
        
        months.removeAll()
        
        let maxMonth = selectedDate.year == maxDate.year ? maxDate.month : 12
        
        let minMonth = selectedDate.year == minDate.year ? minDate.month : 1
        
        (minMonth...maxMonth).forEach { months.append($0) }
        
        reloadDay()
        
    }
    
    func selectRow() {
        
        let yearIndex = getIndex(item: selectedDate.year, arrs: years)
        
        let monthIndex = getIndex(item: selectedDate.month, arrs: months)
        
        let dayIndex = getIndex(item: selectedDate.day, arrs: days)
        
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(dayIndex, inComponent: 0, animated: true)
        
        pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        
        pickerView.selectRow(yearIndex, inComponent: 2, animated: true)
        
    }
    
}

private extension PeriodsPickerView {

    func reloadMonth() {
        
        let maxMonth = selectedDate.year == maxDate.year ? maxDate.month : 12
        
        let minMonth = selectedDate.year == minDate.year ? minDate.month : 1
        
        // 数据未改变时， 打断
        if let first = months.first,
           let last = months.last,
            first == minMonth,
            last == maxMonth {
            return
        }
        
        months.removeAll()
        
        (minMonth...maxMonth).forEach { months.append($0) }
        
        if selectedDate.month > maxMonth {
            selectedDate.month = maxMonth
        }
        
        if selectedDate.month < minMonth {
            selectedDate.month = minMonth
        }
        
        pickerView.reloadComponent(1)
        
        pickerView.selectRow(getIndex(item: selectedDate.month, arrs: months), inComponent: 1, animated: false)
        
    }
    
    func reloadDay() {
     
        let minDay = selectedDate.year == minDate.year && selectedDate.month == minDate.month ? minDate.day : 1
        
        var maxDay: Int
        
        if selectedDate.year == maxDate.year, selectedDate.month == maxDate.month {
            maxDay = maxDate.day
        } else {
            
            switch selectedDate.month {
            case 1, 3, 5, 7, 8, 10, 12:
                maxDay = 31
                
            case 4, 6, 9, 11:
                maxDay = 30
                
            default:
                
                if selectedDate.year % 400 == 0 {
                    maxDay = 29
                } else if selectedDate.year % 100 == 0 {
                    maxDay = 28
                } else if selectedDate.year % 4 == 0 {
                    maxDay = 29
                } else {
                    maxDay = 28
                }
                
            }
            
        }
        
        if selectedDate.day > maxDay {
            selectedDate.day = maxDay
        }
        
        if selectedDate.day < minDay {
            selectedDate.day = minDay
        }
        
        days.removeAll()
        
        (minDay...maxDay).forEach { days.append($0) }
        
        pickerView.reloadComponent(0)
        
        pickerView.selectRow(getIndex(item: selectedDate.day, arrs: days), inComponent: 0, animated: false)
        
    }
    
    func numFormat(_ num: Int) -> String {
        num > 9 ? "\(num)" : "0\(num)"
    }
    
    func getIndex(item: Int, arrs: [Int]) -> Int {
        arrs.firstIndex(of: item) ?? 0
    }
    
}

