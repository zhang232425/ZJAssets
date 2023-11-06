//
//  CodeLoginContainerView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/26.
//

import RxSwift
import RxCocoa
import ZJLoginManager

class CodeLoginContainerView: UIScrollView {
    
    // MARK: - Property
    var inputPhone: String {
        set {
            phoneField.text = newValue
        }
        get {
            phoneField.text
        }
    }
    
    // MARK: - Lazy load
    private lazy var containerView = UIView()
    
    private lazy var titleView = PageCommonTitleView(title: Locale.loginWithPassword.localized, plainSubTitle: Locale.welcomeToAsetku.localized)
    
    private lazy var phoneField = PhoneNumberField().then {
        $0.placeholder = Locale.enterPhoneNumer.localized
        $0.text = ZJLoginManager.shared.lastLoginAccount ?? ""
    }
    
    private lazy var codeField = CodeField().then {
        $0.placeholder = Locale.enterVerficationCode.localized
    }
    
    private lazy var confirmButton = PageMainButton(title: Locale.login.localized.capitalized)
    
    private lazy var pwdLoginButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        $0.setTitleColor(UIColor.standard.orange, for: .normal)
        $0.setTitleColor(UIColor.standard.orange.withAlpha(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont.regular12
        $0.setTitle(Locale.loginWithPassword.localized, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CodeLoginContainerView {
    
    func setupViews() {
        
        containerView.add(to: self).snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
        titleView.add(to: containerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        phoneField.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        codeField.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        confirmButton.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(codeField.snp.bottom).offset(25.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        pwdLoginButton.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(8.auto)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36.auto)
            $0.bottom.equalToSuperview().inset(10.auto)
        }
        
    }
    
}

extension CodeLoginContainerView {
    
    var passwordLoginTap: ControlEvent<()> { pwdLoginButton.rx.tap }
    
    var confirmTap: ControlEvent<()> { confirmButton.rx.tap }

    var phoneNumber: String { phoneField.text }
    
    var code: String { codeField.text }
    
}
