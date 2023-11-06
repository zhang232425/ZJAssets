//
//  CodeField.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/14.
//

import UIKit

class CodeField: BaseView, GetCaptchaResponder {
    
    private lazy var textField = ZJTextField().then {
        $0.keyboardType = .numberPad
        $0.font = UIFont.regular15
        $0.textColor = UIColor(hexString: "#333333")
    }
    
    /**
     sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
     sendButton.setContentHuggingPriority(.required, for: .horizontal)
     */
    private lazy var sendButton = CountdownButton().then {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.layer.cornerRadius = 14.auto
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.titleLabel?.font = UIFont.bold14
    }
    
    private lazy var line = UIView().then {
        $0.backgroundColor = UIColor(hexString: "#E9E9E9")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        sendButton.onClick = { [weak self] in
            let requester = self?.getCaptachaRequester()
            requester?.performGetCaptchaRequest(onSuccess: { [weak self] in
                self?.textField.text = $0
                self?.sendButton.startCountdown()
            })
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CodeField {
    
    func setupViews() {
        
        sendButton.add(to: self).snp.makeConstraints {
            $0.right.centerY.equalToSuperview()
            $0.height.equalTo(28.auto)
            $0.width.greaterThanOrEqualTo(68.auto)
        }
        
        textField.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(sendButton.snp.left).offset(-12.auto)
            $0.top.bottom.equalToSuperview()
        }
        
        line.add(to: self).snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
}

extension CodeField {
    
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


