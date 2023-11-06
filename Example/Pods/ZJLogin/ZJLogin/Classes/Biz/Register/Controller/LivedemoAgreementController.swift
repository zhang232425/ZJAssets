//
//  LivedemoAgreementController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/20.
//

import UIKit
import ZJCommonDefines
import RxSwift
import ZJHUD

class LivedemoAgreementController: BaseWebViewController {
    
    var account = ""
    var code = ""
    
    private let viewModel = RegisterViewModel()
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        let url = ZJUrl.server + "/v2/RegisterContract"
        self.init(url: URL(string: url)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerJS()
        bindViewModel()
    }
    
}

private extension LivedemoAgreementController {
    
    func registerJS() {
        
        let method = ZJLoginJSMethod.finishRegisterProtocol.rawValue
        
        registerScript(method) { [weak self] (webv, _) in
            guard let self = self, self.webView == webv else { return }
            let account = self.account
            let code = self.code
            self.viewModel.registerAction.execute((agreementChecked: true, account: account, captcha: code))
        }
        
    }
    
    func bindViewModel() {
        
        viewModel.registerAction.errors.subscribe(onNext: {
            ZJHUD.noticeOnlyText($0.localizedDescription)
        }).disposed(by: disposeBag)
        
        viewModel.registerAction.executing.subscribe(onNext: { [weak self] in
            if $0 {
                ZJHUD.showProgress(in: self?.view)
            } else {
                ZJHUD.hideProgress()
            }
        }).disposed(by: disposeBag)
        
        viewModel.registerAction.elements.subscribeNext(weak: self, type(of: self).onRegisterResult).disposed(by: disposeBag)
        
    }
    
    func onRegisterResult(_ result: Request.account.RegisterResult) {
        
        switch result {
        case .success(let token):
            route.enter(.initPassword(account: account, accessToken: token))
        case .accountExists:
            route.present(.duplicatedAccount(account: account, smsCode: code))
        case .bizError(let msg):
            ZJHUD.noticeOnlyText(msg)
        case .codeError(let msg):
            ZJHUD.noticeOnlyText(msg)
        }
        
    }
    
}


