//
//  PasswordLoginController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import ZJHUD
import RxSwift
import RxSwiftExt
import ZJCommonDefines

class PasswordLoginController: BaseViewController {
    
    private lazy var containerView = PasswordLoginContainerView()
    
    private lazy var ojkLogoView = OJKLogoView()
        
    var inputPhone: String {
        get {
            containerView.inputPhone
        }
        set {
            containerView.inputPhone = newValue
        }
    }
    
    private let viewModel: LoginViewModel

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

private extension PasswordLoginController {
    
    func setupViews() {
        
        containerView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSafeArea(of: view)
        }
        
        ojkLogoView.add(to: view).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSafeArea(of: view).inset(25.auto)
        }
        
        navigationItem.rightBarButtonItem = .custom(title: Locale.register.localized, action: { [weak self] in
            self?.route.enter(.register)
        })
    
    }
    
    func bindViewModel() {
        
        containerView.codeLoginTap.subscribe(onNext: { [weak self] in
            (self?.parent as? LoginContainerController)?.transition(to: .code)
        }).disposed(by: disposeBag)
        
        containerView.forgotPwdTap.subscribe(onNext: { [weak self] in
            self?.route.enter(.forgotPassword)
        }).disposed(by: disposeBag)
        
        containerView.confirmTap.map { [weak self] in
            (self?.containerView.phoneNumber ?? "", self?.containerView.password ?? "", nil)
        }.bind(to: viewModel.loginByPassword.inputs)
            .disposed(by: disposeBag)
        
        viewModel.loginByPassword.errors
            .subscribeNext(weak: self, type(of: self).onError)
            .disposed(by: disposeBag)
        
        viewModel.loginByPassword.executing
            .subscribeNext(weak: self, type(of: self).onProgress)
            .disposed(by: disposeBag)
    
        viewModel.loginByPassword.elements
            .subscribeNext(weak: self, type(of: self).onLoginResult)
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - Request result
private extension PasswordLoginController {
    
    func onLoginResult(_ result: Request.login.Result) {
        
        switch result {
            
        case .success(let data):
            
            let account = containerView.phoneNumber
            let pwd = containerView.password
            let router = LoginResultRouter(entry: .pwd(pwd: pwd, account: account), data: data)
            router.routeCompletion = (parent as? LoginContainerController)?.loginCompletion
            router.routeOnLoginSuccess()
    
        case .needSmsCaptcha(let msg):
            
            print("msg === \(msg)")
            
        case .accountNotExist:
            break
            
        case .accountBeFrozen:
            present(FrozenAlertController(), animated: true)
            
        case .bizError(let err):
            if err.code == "PROFILE.0015" {
               
            } else if err.code == "PROFILE.0016" {
                
            } else {
               
            }
            ZJHUD.noticeOnlyText(err.msg)
            
        }
        
    }
    
}

/**
 let account = containerView.phoneNumber
 let pwd = containerView.password
 let router = LoginResultRouter(entry: .pwd(pwd: pwd, account: account), data: data)
 router.routeCompletion = (parent as? LoginContainerController)?.loginCompletion
 router.routeOnLoginSuccess()
 
 */

