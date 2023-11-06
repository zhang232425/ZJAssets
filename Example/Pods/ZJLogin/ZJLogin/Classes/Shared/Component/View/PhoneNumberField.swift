//
//  PhoneNumberTextField.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import UIKit
import ZJRegion

class PhoneNumberField: BaseView {
    
    private lazy var textField = ZJTextField().then {
        $0.keyboardType = .numberPad
        $0.font = UIFont.regular15
        $0.textColor = UIColor(hexString: "#333333")
    }
    
    private lazy var areaCodeLabel = UILabel().then {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.font = UIFont.regular14
        $0.textColor = UIColor(hexString: "#333333")
        $0.textAlignment = .right
        $0.text = ZJRegion.current.areaCode
    }
    
    private lazy var line = UIView().then {
        $0.backgroundColor = UIColor(hexString: "#E9E9E9")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PhoneNumberField {
    
    func setupViews() {
        
        areaCodeLabel.add(to: self).snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        textField.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(areaCodeLabel.snp.left).offset(-12)
            $0.top.bottom.equalToSuperview()
        }
        
        line.add(to: self).snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
}

extension PhoneNumberField {
    
    var placeholder: String {
        get {
            textField.attributedPlaceholder?.string ?? ""
        }
        set {
            let hint = newValue
            textField.attributedPlaceholder = .init(string: hint,
                                                    attributes: [.foregroundColor: UIColor(hexString: "#BFBEC2")])
        }
    }
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
}

