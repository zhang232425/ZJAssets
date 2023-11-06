//
//  RegisterViewController.swift
//  Pods-ZJLogin_Example
//
//  Created by Jercan on 2023/9/12.
//

import UIKit
import ZJHUD
import ZJExtension

class RegisterViewController: BaseViewController {
    
    private var captchaSuccess: ((String?) -> Void)?
    
    let viewModel = RegisterViewModel()
    
    // MARK: - Lazy load
    private lazy var containerView = RegisterContainerView()
    
    private lazy var ojkLoginView = OJKLogoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.registerTipsAction.execute()
    }

}

private extension RegisterViewController {
    
    func setupViews() {
        
        if navigationController?.viewControllers.first == self {
            navigationItem.leftBarButtonItem = .custom(image: UIImage.dd.named("nav_close"), action: {
                self.navigationController?.dismiss(animated: true)
            })
        }
        
        navigationItem.rightBarButtonItem = .custom(title: Locale.login.localized, action: {
            print("我要登录")
        })
            
        containerView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSafeArea(of: view)
        }
        
        ojkLoginView.add(to: view).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSafeArea(of: view).inset(20.auto)
        }
        
    }
    
    func bindViewModel() {
        
        containerView.onAgreementClick = { [weak self] in
            self?.route.enter(.agreement(url: $0.url))
        }
        
        containerView.confirmTap
            .subscribeNext(weak: self, type(of: self).enterAgreement)
            .disposed(by: disposeBag)
        
        viewModel.registerTipsAction.elements
            .subscribeNext(weak: containerView, RegisterContainerView.setSubTitle)
            .disposed(by: disposeBag)
        
        viewModel.registerCaptcha.errors
            .subscribeNext(weak: self, type(of: self).onError)
            .disposed(by: disposeBag)
        
        viewModel.registerCaptcha.executing
            .subscribeNext(weak: self, type(of: self).onProgress)
            .disposed(by: disposeBag)
        
        viewModel.registerCaptcha.elements
            .subscribeNext(weak: self, type(of: self).captchaResult)
            .disposed(by: disposeBag)
    
    }
    
    func captchaResult(_ result: Request.getCaptcha.Result) {
        
        switch result {
        case .success(let code):
            captchaSuccess?(code)
        case .needImageCaptcha:
            print("需要图片验证码")
        case .imageCapthaError(let msg):
            ZJHUD.noticeOnlyText(msg)
        case .bizError(let msg):
            ZJHUD.noticeOnlyText(msg)
        }
        
    }

    func enterAgreement(_: Void) {
        
        let account = containerView.phoneNumber
        let code = containerView.code
        let vc = LivedemoAgreementController()
        vc.account = account
        vc.code = code
        UIApplication.shared.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = InitPasswordController(account: "0812300000000", accessToken: "12123821789e782732272323")
//        let vc = SetReferralcodeController()
//        UIApplication.shared.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension RegisterViewController: GetCaptchaRequester {
    
    func performGetCaptchaRequest(onSuccess: @escaping (String?) -> Void) {
        
        captchaSuccess = onSuccess
        
        let account = containerView.phoneNumber
        viewModel.registerCaptcha.execute((account: account, imageCaptcha: nil))
        
    }
    
}
