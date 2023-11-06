//
//  PasswordField.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/22.
//

import UIKit

class PasswordField: UIView {

    // MARK: - Property
    private lazy var textField = ZJTextField().then {
        $0.font = UIFont.regular15
        $0.textColor = UIColor.standard.black33
        $0.isSecureTextEntry = true
    }
    
    private lazy var button = UIButton(type: .custom).then {
        $0.setBackgroundImage(UIImage(), for: .highlighted)
        $0.setImage(UIImage.dd.named("ic_security_on"), for: .normal)
        $0.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    private lazy var line = UIView().then {
        $0.backgroundColor = UIColor.standard.grayE9
    }
    
    // MARK: - Lazy load
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PasswordField {
    
    func setupViews() {
        
        button.add(to: self).snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.size.equalTo(40.auto)
            $0.centerY.equalToSuperview()
        }
        
        textField.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(button.snp.left).offset(-12.auto)
            $0.top.bottom.equalToSuperview()
        }
        
        line.add(to: self).snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
    @objc func toggle() {
        
        textField.isSecureTextEntry.toggle()
        let name = textField.isSecureTextEntry ? "ic_security_on" : "ic_security_off"
        button.setImage(UIImage.dd.named(name), for: .normal)
        
    }

}

extension PasswordField {
    
    var placeholder: String {
        get {
            textField.attributedPlaceholder?.string ?? ""
        }
        set {
            let hint = newValue
            textField.attributedPlaceholder = .init(string: hint,
                                                    attributes: [.foregroundColor: UIColor.standard.textHint])
        }
    }
    
    var text: String { textField.text ?? "" }
    
}
