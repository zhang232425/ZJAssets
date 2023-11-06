//
//  PasswordLoginContainerView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/26.
//

import RxSwift
import RxCocoa
import ZJLoginManager

class PasswordLoginContainerView: UIScrollView {
    
    // MARK: - Preperty
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
    
    private lazy var passwordField = PasswordField().then {
        $0.placeholder = Locale.enterPassword.localized
    }
    
    private lazy var confirmButton = PageMainButton(title: Locale.login.localized.capitalized)
    
    private lazy var line = UIView().then {
        $0.backgroundColor = UIColor.standard.orange
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 12
    }

    private lazy var codeLoginButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        $0.setTitleColor(UIColor.standard.orange, for: .normal)
        $0.setTitleColor(UIColor.standard.orange.withAlpha(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont.regular12
        $0.setTitle(Locale.loginWithCode.localized, for: .normal)
    }
    
    private lazy var forgotPwdButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
        $0.setTitleColor(UIColor.standard.orange, for: .normal)
        $0.setTitleColor(UIColor.standard.orange.withAlpha(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont.regular12
        $0.setTitle(Locale.forgotPassword.localized, for: .normal)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PasswordLoginContainerView {
    
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
        
        passwordField.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        confirmButton.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(25.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        line.add(to: codeLoginButton).snp.makeConstraints {
            $0.right.equalToSuperview().offset(6.auto)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(8)
        }
        
        stackView.addArrangedSubview(codeLoginButton)
        stackView.addArrangedSubview(forgotPwdButton)
        
        stackView.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(5.auto)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36.auto)
            $0.bottom.equalToSuperview().inset(10.auto)
        }
        
    }
    
}

extension PasswordLoginContainerView {
    
    var codeLoginTap: ControlEvent<()> { codeLoginButton.rx.tap }
    
    var forgotPwdTap: ControlEvent<()> { forgotPwdButton.rx.tap }
    
    var confirmTap: ControlEvent<()> { confirmButton.rx.tap }
    
    var phoneNumber: String { phoneField.text }
    
    var password: String { passwordField.text }
    
}

