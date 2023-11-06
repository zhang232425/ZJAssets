//
//  ForgotPasswordController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/17.
//

import UIKit
import ZJHUD
import RxSwift

class ForgotPasswordController: BaseViewController {
    
    // MARK: - Lazy load
    private lazy var phoneField = PhoneNumberField().then {
        $0.placeholder = Locale.enterPhoneNumer.localized
    }
    
    private lazy var codeField = CodeField().then {
        $0.placeholder = Locale.enterVerficationCode.localized
    }
    
    private lazy var button = PageMainButton(title: Locale.next.localized.capitalized)
    
    private let viewModel = PasswordViewModel()
    
    private var onGetCaptchaSuccess: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
}

private extension ForgotPasswordController {
    
    func setupViews() {
        
        navigationItem.title = Locale.forgotPassword.localized
        
        phoneField.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.top.equalToSuperview().offset(32.auto)
            $0.height.equalTo(50.auto)
        }
        
        codeField.add(to: view).snp.makeConstraints {
            $0.left.right.equalTo(phoneField)
            $0.top.equalTo(phoneField.snp.bottom).offset(32.auto)
            $0.height.equalTo(50.auto)
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.left.right.equalTo(codeField)
            $0.top.equalTo(codeField.snp.bottom).offset(40.auto)
            $0.height.equalTo(45.auto)
        }
        
    }

    func bindViewModel() {
        
        button.rx.tap.map { [weak self] in
            (self?.phoneField.text ?? "",
             self?.codeField.text ?? "")
        }.bind(to: viewModel.captchaVerifyAction.inputs).disposed(by: disposeBag)
        
        Observable.merge(viewModel.captchaVerifyAction.errors,
                         viewModel.getForgotPwdCaptcha.errors)
        .subscribeNext(weak: self, type(of: self).onError)
        .disposed(by: disposeBag)
        
        Observable.merge(viewModel.captchaVerifyAction.executing,
                         viewModel.getForgotPwdCaptcha.executing)
        .subscribeNext(weak: self, type(of: self).onProgress)
        .disposed(by: disposeBag)
        
        viewModel.getForgotPwdCaptcha.elements.subscribe(onNext: { [weak self] in
            switch $0 {
            case .success(let code):
                self?.onGetCaptchaSuccess?(code)
            case .needImageCaptcha:
                /**
                 let account = self?.phoneTextField.text ?? ""
                 self?.route.present(.imageCaptcha(account: account, onConfirm: { [weak self] text in
                     self?.viewModel.getForgotPwdCaptcha.execute((account: account, imageCaptcha: text))
                 }))
                 */
                break
            case .imageCapthaError(let msg):
                break
            case .bizError(let msg):
                ZJHUD.noticeOnlyText(msg)
            }
        }).disposed(by: disposeBag)
        
        viewModel.captchaVerifyAction.elements
            .subscribeNext(weak: self, type(of: self).onVerifySuccess)
            .disposed(by: disposeBag)
        
    }
    
}

private extension ForgotPasswordController {
    
    func onVerifySuccess(_: Void) {
        
        let account = phoneField.text
        let captcha = codeField.text
        route.enter(.resetPassword(account: account, captcha: captcha))
        
    }

}

extension ForgotPasswordController: GetCaptchaRequester {
    
    func performGetCaptchaRequest(onSuccess: @escaping (String?) -> Void) {
        
        onGetCaptchaSuccess = onSuccess
        
        let account = phoneField.text
        viewModel.getForgotPwdCaptcha.execute((account: account, imageCaptcha: nil))
        
    }
    
}

