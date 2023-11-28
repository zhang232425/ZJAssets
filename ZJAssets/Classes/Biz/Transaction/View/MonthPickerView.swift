//
//  MonthPickerView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import SwiftDate

class MonthPickerView: BaseView {
    
    struct DateInfo {
        var year: Int = 0
        var month: Int = 0
    }
    
    private let minYear = 2016
    
    private let initialYear = Date().year
    
    private let initialMonth = Date().month
    
    private lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var years = [Int]()
    
    private lazy var months = [Int]()
    
    private var selectedDate = DateInfo()
    
    var selectHandler: ((DateInfo) -> Void)?
    
    override func setupViews() {
        
        initData()
        
        pickerView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        pickerView.selectRow(initialMonth - 1, inComponent: 0, animated: true)
        
        pickerView.selectRow(initialYear - minYear, inComponent: 1, animated: true)

    }
    
    func setInfo(year: Int, month: Int) {
        
        guard year != 0, month != 0 else { return }
        
        selectedDate = .init(year: year, month: month)
        
        // 更新年
        let yearRow = years.firstIndex(of: selectedDate.year) ?? initialYear - minYear
        
        pickerView.selectRow(yearRow, inComponent: 1, animated: false)
        
        // 更新月
        reloadMonth() // 检查月数组
        
        pickerView.reloadComponent(0) // 刷新月
        
        pickerView.selectRow(getIndex(item: selectedDate.month, arrs: months), inComponent: 0, animated: false) //选中月
        
    }
    
}

extension MonthPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        pickerView.bounds.width / 2.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel().then {
            $0.textColor = .init(hexString: "333333")
            $0.font = .regular16
            $0.textAlignment = .center
        }
        
        switch component {
        case 0:
            label.text = numFormat(months[row])
        case 1:
            label.text = "\(years[row])"
        default:
            break
        }
        
        return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            selectedDate.month = months[row]
            
        case 1:
            selectedDate.year = years[row]
            reloadMonth()
            
        default:
            return
        }
        
        selectHandler?(selectedDate)
        
    }
    
}

extension MonthPickerView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

}

private extension MonthPickerView {
    
    func initData() {
        
        selectedDate.year = initialYear
        
        selectedDate.month = initialMonth
        
        years.removeAll()
        
        (minYear...initialYear).forEach{ years.append($0) }
        
        months.removeAll()
        
        (1...initialMonth).forEach{ months.append($0) }

    }
    
    func reloadMonth() {
        
        let maxMonth = selectedDate.year == initialYear ? initialMonth : 12
        
        // 数据未改变时， 打断
        guard months.count != maxMonth else { return }
        
        months.removeAll()
        
        (1...maxMonth).forEach { months.append($0) }
        
        if selectedDate.month > maxMonth {
            selectedDate.month = maxMonth
        }
        
        pickerView.reloadComponent(0)
        
        pickerView.selectRow(getIndex(item: selectedDate.month, arrs: months), inComponent: 0, animated: false)
    }
    
    func numFormat(_ num: Int) -> String {
        num > 9 ? "\(num)" : "0\(num)"
    }
    
    func getIndex(item: Int, arrs: [Int]) -> Int {
        arrs.firstIndex(of: item) ?? 0
    }
    
}
