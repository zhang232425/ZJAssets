//
//  CodeLoginController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import UIKit
import ZJHUD
import RxSwift
import RxSwiftExt

class CodeLoginController: BaseViewController {
    
    // MARK: - Property
    var inputPhone: String {
        get {
            containerView.inputPhone
        }
        set {
            containerView.inputPhone = newValue
        }
    }
    
    private var onGetCaptchaSuccess: ((String?) -> Void)?
    
    private let viewModel: LoginViewModel
    
    // MARK: - Lazy load
    private lazy var containerView = CodeLoginContainerView()
    
    private lazy var ojkLogoView = OJKLogoView()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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

private extension CodeLoginController {
    
    func setupViews() {
        
        containerView.add(to: view).snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
        ojkLogoView.add(to: view).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSafeArea(of: view).inset(25.auto)
        }
        
    }
    
    func bindViewModel() {
        
        containerView.passwordLoginTap.subscribe(onNext: { [weak self] in
            (self?.parent as? LoginContainerController)?.transition(to: .password)
        }).disposed(by: disposeBag)
        
        containerView.confirmTap.map { [weak self] in
            (self?.containerView.phoneNumber ?? "",
             self?.containerView.code ?? "")
        }.bind(to: viewModel.loginBySMS.inputs).disposed(by: disposeBag)
        
        Observable.merge(viewModel.getCaptchaOnLogin.errors,
                         viewModel.loginBySMS.errors)
        .subscribeNext(weak: self, type(of: self).onError)
        .disposed(by: disposeBag)
        
        Observable.merge(viewModel.loginBySMS.executing,
                         viewModel.getCaptchaOnLogin.executing)
        .subscribeNext(weak: self, type(of: self).onProgress)
        .disposed(by: disposeBag)
        
        viewModel.getCaptchaOnLogin.elements.subscribe(onNext: { [weak self] in
            switch $0 {
            case .success(let code):
                self?.onGetCaptchaSuccess?(code)
            case .needImageCaptcha:
                print("需要图像验证码")
            case .imageCapthaError(let msg):
                print("头像验证码错误 - \(msg ?? "0")")
            case .bizError(let msg):
                ZJHUD.noticeOnlyText(msg)
            }
        }).disposed(by: disposeBag)
        
        viewModel.loginBySMS.elements
            .subscribeNext(weak: self, type(of: self).onLoginResult)
            .disposed(by: disposeBag)
        
        viewModel.getPassword.elements.subscribe(onError: {
            print("获取是否有密码接口成功 - \($0)")
        }).disposed(by: disposeBag)
        
    }
    
}

private extension CodeLoginController {
    
    func onLoginResult(_ result: Request.login.Result) {
        
        switch result {
            
        case .success(let data):
            let account = containerView.phoneNumber
            let router = LoginResultRouter(entry: .sms(accessToken: data.accessToken, account: account), data: data)
            router.routeCompletion = (parent as? LoginContainerController)?.loginCompletion
            router.routeOnLoginSuccess()
            
        case .accountNotExist:
            print("账号不存在")
            
        case .accountBeFrozen:
            present(FrozenAlertController(), animated: true)
            
        case .needSmsCaptcha(let msg):
            print("需要验证码 - \(msg ?? "可选值")")
            
        case .bizError(let error):
            ZJHUD.noticeOnlyText(error.msg)
            
        }
        
    }
    
}

extension CodeLoginController: GetCaptchaRequester {
    
    func performGetCaptchaRequest(onSuccess: @escaping (String?) -> Void) {
        
        onGetCaptchaSuccess = onSuccess
        
        let account = containerView.phoneNumber
        viewModel.getCaptchaOnLogin.execute((account: account, imageCaptcha: nil))
        
    }

}
