//
//  ResetPasswordController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/17.
//

import UIKit
import RxSwift

class ResetPasswordController: BaseViewController {
    
    private let account: String
    
    private let captcha: String
    
    private let viewModel = PasswordViewModel()
    
    // MARK: - Lazy load
    private lazy var introduceView = PageCommonTitleView(title: Locale.setLoginPassword.localized, plainSubTitle: Locale.usePasswordLoginLater.localized)
    
    private lazy var textField = PasswordField().then {
        $0.placeholder = Locale.passwordPlaceholder.localized
    }
    
    private lazy var hintLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.regular12
        $0.textColor = UIColor(hexString: "#666666")
        $0.text = Locale.correctPasswordHint.localized
    }
    
    private lazy var button = PageMainButton(title: Locale.confirm.localized.capitalized)
    
    init(account: String, captcha: String) {
        self.account = account
        self.captcha = captcha
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

}

private extension ResetPasswordController {
    
    func setupViews() {
        
        introduceView.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        textField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(introduceView.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(50.auto)
        }
        
        hintLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12.auto)
            $0.left.right.equalTo(textField)
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.top.equalTo(hintLabel.snp.bottom).offset(16.auto)
            $0.left.right.equalTo(hintLabel)
            $0.height.equalTo(45.auto)
        }
        
    }
    
    func bindViewModel() {
        
        button.rx.tap.map { [weak self] in
            (self?.account ?? "", self?.captcha ?? "", self?.textField.text ?? "")
        }.bind(to: viewModel.resetPasswordAction.inputs).disposed(by: disposeBag)
        
        viewModel.resetPasswordAction.errors
            .subscribeNext(weak: self, type(of: self).onError)
            .disposed(by: disposeBag)
        
        viewModel.resetPasswordAction.executing
            .subscribeNext(weak: self, type(of: self).onProgress)
            .disposed(by: disposeBag)
        
        viewModel.resetPasswordAction.elements
            .subscribeNext(weak: self, type(of: self).onResult)
            .disposed(by: disposeBag)
        
    }
    
}

private extension ResetPasswordController {
    
    func onResult(_: Void) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}
