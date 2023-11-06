//
//  InitPasswordController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/22.
//

import UIKit
import ZJBase
import ZJCommonDefines

class InitPasswordController: BaseViewController {

    private let account: String
    private let accessToken: String
    
    private let viewModel = PasswordViewModel()
    
    // MARK: - Lazy Load
    private lazy var textField = PasswordField().then {
        $0.placeholder = Locale.passwordPlaceholder.localized
    }
    
    private lazy var button = PageMainButton(title: Locale.confirm.localized.capitalized).then {
        $0.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
    }
    
    init(account: String, accessToken: String) {
        self.account = account
        self.accessToken = accessToken
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

private extension InitPasswordController {
    
    func setupViews() {
        
        let image = ZJViewController.defaultBackImage()
        navigationItem.leftBarButtonItem = .custom(image: image, action: { [weak self] in
            self?.onBackClick()
        })
        
        let str1 = Locale.setLoginPassword.localized
        let str2 = Locale.usePasswordLoginLater.localized
        let titleView = PageCommonTitleView(title: str1, plainSubTitle: str2)
        
        titleView.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        textField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(50.auto)
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
        
    }
    
    func bindViewModel() {
        
        viewModel.initPasswordAction.errors
            .subscribeNext(weak: self, type(of: self).onError)
            .disposed(by: disposeBag)
        
        viewModel.initPasswordAction.executing
            .subscribeNext(weak: self, type(of: self).onProgress(_:))
            .disposed(by: disposeBag)
        
        viewModel.initPasswordAction.elements
            .subscribeNext(weak: self, type(of: self).onSetPasswordSuccess)
            .disposed(by: disposeBag)
        
    }
    
    func onSetPasswordSuccess(_: Void) {
        
        route.enter(.setReferralcode)
        
        
        let completion = {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ZJNotification.didLogin, object: nil)
            }
        }
        
        ZJLoginModule.notifyInitPasswordSuccess(account: account,
                                                accessToken: accessToken,
                                                completion: completion)
        
    }
    
    @objc func onConfirm() {
        
        let password = textField.text
        viewModel.initPasswordAction.execute((password: password, accessToken: accessToken))
        
    }
    
    @objc func onBackClick() {
        
        onProgress(true)
        
        ZJLoginModule.notifyInitPasswordSuccess(account: account, accessToken: accessToken) { [weak self] in
            
            NotificationCenter.default.post(name: ZJNotification.didLogin, object: nil)
            self?.onProgress(false)
            self?.navigationController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: ZJNotification.didLoginCompletion, object: nil)
            })
            
        }
        
    }
    
}
