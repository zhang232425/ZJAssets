//
//  RegisterContainerView.swift
//  Action
//
//  Created by Jercan on 2023/9/12.
//

import UIKit
import ZJActiveLabel
import RxSwift
import RxCocoa

class RegisterContainerView: UIScrollView {
    
    private lazy var containerView = UIView()
    
    private lazy var titleView = PageCommonTitleView(title: Locale.register.localized, subTitle: .init())
    
    private lazy var phoneField = PhoneNumberField().then {
        $0.placeholder = Locale.enterPhoneNumer.localized
    }
    
    private lazy var codeField = CodeField().then {
        $0.placeholder = Locale.enterVerficationCode.localized
    }
    
    private lazy var confirmBtn = PageMainButton(title: Locale.next.localized)
    
    private lazy var agreementCheckBtn = AgreementCheckButton().then {
        $0.onChangeState = { isChecked in
            if isChecked {
                print("勾选了")
            } else {
                print("取消勾选了")
            }
        }
    }

    private lazy var agreementLabel = AgreementLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RegisterContainerView {
    
    func setupViews() {
        
        containerView.add(to: self).snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
        titleView.add(to: containerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(40.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        phoneField.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(50.auto)
        }
            
        codeField.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(30.auto)
            $0.left.right.height.equalTo(phoneField)
        }
        
        confirmBtn.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(codeField.snp.bottom).offset(40.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
        agreementCheckBtn.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(confirmBtn.snp.bottom).offset(8.auto)
            $0.left.equalTo(12.auto)
            $0.size.equalTo(32.auto)
        }
        
        agreementLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(confirmBtn.snp.bottom).offset(16.auto)
            $0.left.equalTo(44.auto)
            $0.right.equalToSuperview().inset(20.auto)
            $0.bottom.equalToSuperview().inset(10.auto)
        }
    
    }
    
}

extension RegisterContainerView {
    
    var phoneNumber: String { phoneField.text }
    
    var code: String { codeField.text }
    
    var agreementChecked: Bool { true }
    
    var confirmTap: ControlEvent<Void> { confirmBtn.rx.tap }
    
    var onAgreementClick: ((Agreement) -> Void)? {
        get { agreementLabel.onClick }
        set { agreementLabel.onClick = newValue }
    }
    
    func setSubTitle(_ subTitle: NSAttributedString) {
        titleView.setSubTitle(subTitle)
    }
    
}

fileprivate class AgreementLabel: ActiveLabel {
    
    var onClick: ((Agreement) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        textColor = UIColor.standard.gray99
        font = UIFont.regular12
        numberOfLines = 0
        
        let types = Agreement.allCases.map {
            ActiveType.custom(pattern: $0.title)
        }
        enabledTypes = types
        text = Locale.agreementDescription.localized(arguments: Agreement.allCases.map{ $0.title })
        types.forEach {
            handleCustomTap(for: $0) { [weak self] str in
                switch str {
                case Agreement.tnc.title:
                    self?.onClick?(.tnc)
                case Agreement.privacy.title:
                    self?.onClick?(.privacy)
                default:
                    break
                }
            }
            customColor[$0] = UIColor.standard.gray66
            customSelectedColor[$0] = UIColor.standard.gray66.withAlpha(0.5)
            customUnderLineStyle[$0] = .styleSingle
        }
        
    }
    
}
