//
//  TimePeriodsView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit

class TimePeriodsView: BaseView {
    
    private enum TimeType: CaseIterable {
        
        case lastMonth
        case last3Month
        case lastYear
        
        var title: String {
            switch self {
            case .lastMonth:
                return Locale.lastMonth.localized
            case .last3Month:
                return Locale.last3Month.localized
            case .lastYear:
                return Locale.lastYear.localized
            }
        }
        
        var tag: Int {
            switch self {
            case .lastMonth:
                return 0
            case .last3Month:
                return 1
            case .lastYear:
                return 2
            }
        }
        
    }
    
    enum SelectType {
        case lastMonth
        case last3Month
        case lastYear
        case customStart
        case customEnd
    }

    private lazy var timeLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.transactionTime.localized
    }
    
    private lazy var customLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.custom.localized
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var startButton = UIButton(type: .custom).then {
        $0.backgroundColor = .init(hexString: "#F3F3F3")
        $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexString: "#F3F3F3").cgColor
        $0.titleLabel?.font = .regular14
        $0.addTarget(self, action: #selector(customButtonClick(sender:)), for: .touchUpInside)
    }
    
    private lazy var endButton = UIButton(type: .custom).then {
        $0.backgroundColor = .init(hexString: "#F3F3F3")
        $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexString: "F3F3F3").cgColor
        $0.titleLabel?.font = .regular14
        $0.addTarget(self, action: #selector(customButtonClick(sender:)), for: .touchUpInside)
    }
    
    private lazy var pickerContainerView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var pickerView = PeriodsPickerView().then {
        $0.selectHandler = { [weak self] in
            self?.handlePickerSelect($0)
        }
    }
    
    var currentType: SelectType = .lastMonth {
        didSet {
            if currentType != oldValue {
                updateUI()
                typeChangeHandler?(currentType)
            }
        }
    }
    
    var typeChangeHandler: ((SelectType) -> Void)?
    
    var pickerSelectHandler: ((SelectType, PeriodsPickerView.DateInfo) -> Void)?
    
    func setPeriods(start: String, end: String) {
        startButton.setTitle(start, for: .normal)
        endButton.setTitle(end, for: .normal)
    }
    
    func setPickerInfo(minDate: PeriodsPickerView.DateInfo,
                       maxDate: PeriodsPickerView.DateInfo,
                       selectDate: PeriodsPickerView.DateInfo) {
        pickerView.setInfo(minDate: minDate, maxDate: maxDate, selectedDate: selectDate)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        typeChangeHandler?(currentType)
    }
    
    override func setupViews() {
        
        TimeType.allCases.map { type in
            UIButton(type: .custom).then {
                $0.layer.cornerRadius = 20
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor(hexString: "F0F0F0").cgColor
                $0.backgroundColor = .white
                $0.setTitleColor(.init(hexString: "333333"), for: .normal)
                $0.titleLabel?.font = .regular14
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
                $0.setTitle(type.title, for: .normal)
                $0.tag = type.tag
                $0.addTarget(self, action: #selector(timeButtonClick(sender:)), for: .touchUpInside)
            }
        }.forEach(stackView.addArrangedSubview)
        
        timeLabel.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        stackView.add(to: self).snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(12)
            $0.left.right.equalTo(timeLabel)
            $0.height.equalTo(40)
        }
        
        customLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        startButton.add(to: self).snp.makeConstraints {
            $0.top.equalTo(customLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        let lineView = UIView()
        
        lineView.add(to: self).then {
            $0.backgroundColor = .init(hexString: "E9E9E9")
        }.snp.makeConstraints {
            $0.left.equalTo(startButton.snp.right).offset(8)
            $0.centerY.equalTo(startButton)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(1)
        }
                
        endButton.add(to: self).snp.makeConstraints {
            $0.left.equalTo(lineView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(lineView)
            $0.height.equalTo(startButton)
        }
        
        pickerContainerView.add(to: self).snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(38)
        }
        
        updateUI()
        
    }

}

private extension TimePeriodsView {
    
    func handlePickerSelect(_ info: PeriodsPickerView.DateInfo) {
        pickerSelectHandler?(currentType, info)
    }
    
    @objc
    func timeButtonClick(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            currentType = .lastMonth
        case 1:
            currentType = .last3Month
        case 2:
            currentType = .lastYear
        default:
            break
        }
                
    }
    
    @objc
    func customButtonClick(sender: UIButton) {
        
        switch sender {
        case startButton:
            currentType = .customStart
        case endButton:
            currentType = .customEnd
        default:
            break
        }
                
    }
    
    func updateUI() {
        
        pickerContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch currentType {
        case .lastMonth:
            
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                if $0.tag == 0 {
                    updateButton($0, textColor: "#FF7D0F", borderColor: "#FF7D0F")
                } else {
                    updateButton($0, textColor: "#333333", borderColor: "#F0F0F0")
                }
            }
            
            updateButton(startButton, textColor: "#999999", borderColor: "#F3F3F3")
            
            updateButton(endButton, textColor: "#999999", borderColor: "#F3F3F3")
            
        case .last3Month:
            
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                if $0.tag == 1 {
                    updateButton($0, textColor: "#FF7D0F", borderColor: "#FF7D0F")
                } else {
                    updateButton($0, textColor: "#333333", borderColor: "#F0F0F0")
                }
            }
            
            updateButton(startButton, textColor: "#999999", borderColor: "#F3F3F3")
            
            updateButton(endButton, textColor: "#999999", borderColor: "#F3F3F3")
            
        case .lastYear:
            
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                if $0.tag == 2 {
                    updateButton($0, textColor: "#FF7D0F", borderColor: "#FF7D0F")
                } else {
                    updateButton($0, textColor: "#333333", borderColor: "#F0F0F0")
                }
            }
            
            updateButton(startButton, textColor: "#999999", borderColor: "#F3F3F3")
            
            updateButton(endButton, textColor: "#999999", borderColor: "#F3F3F3")
            
        case .customStart:
            
            updateButton(startButton, textColor: "#FF7D0F", borderColor: "#FF7D0F")
            
            updateButton(endButton, textColor: "#999999", borderColor: "#F3F3F3")
            
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                updateButton($0, textColor: "#333333", borderColor: "#F0F0F0")
            }
            
            pickerContainerView.addArrangedSubview(pickerView)
            
        case .customEnd:
            
            updateButton(endButton, textColor: "#FF7D0F", borderColor: "#FF7D0F")
            
            updateButton(startButton, textColor: "#999999", borderColor: "#F3F3F3")
            
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                updateButton($0, textColor: "#333333", borderColor: "#F0F0F0")
            }
            
            pickerContainerView.addArrangedSubview(pickerView)
            
        }
        
    }
    
    func updateButton(_ button: UIButton, textColor: String, borderColor: String) {
        button.layer.borderColor = UIColor(hexString: borderColor).cgColor
        button.setTitleColor(.init(hexString: textColor), for: .normal)
    }
    
}
