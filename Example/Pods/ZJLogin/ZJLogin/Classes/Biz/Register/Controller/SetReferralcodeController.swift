//
//  SetReferralcodeController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import ZJLoginManager
import ZJCommonDefines

class SetReferralcodeController: BaseViewController {
    
    private let viewModel = RegisterViewModel()
    
    private lazy var textField = ZJTextField().then {
        $0.font = UIFont.regular15
        $0.textColor = UIColor.standard.black33
        let hint = Locale.enterReferralCode.localized
        $0.attributedPlaceholder = .init(string: hint,
                                         attributes: [.foregroundColor: UIColor.standard.textHint])
    }
    
    private lazy var button = PageMainButton(title: Locale.submit.localized)
    
    private lazy var titleView = PageCommonTitleView(title: Locale.referralCode.localized, plainSubTitle: Locale.referralCodeDescription.localized)
    
    private lazy var line = UIView().then {
        $0.backgroundColor = UIColor.standard.grayE9
    }
    
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
}

// MARK: - Custom method
private extension SetReferralcodeController {
    
    func setupViews() {
        
        navigationItem.leftBarButtonItem = .custom(image: nil)
        isPopGestureEnabled = false
        navigationItem.rightBarButtonItem = .custom(title: Locale.skip.localized, action: { [weak self] in
            self?.onSkip()
        })
        
        titleView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        textField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(32.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(50.auto)
        }
        
        line.add(to: view).snp.makeConstraints {
            $0.bottom.left.right.equalTo(textField)
            $0.height.equalTo(1)
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(40.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
        }
    
        
    }
    
    func bindViewModel() {
        
        viewModel.setReferralCode.errors
            .subscribeNext(weak: self, type(of: self).onError(_:))
            .disposed(by: disposeBag)
        
        viewModel.setReferralCode.executing
            .subscribeNext(weak: self, type(of: self).onProgress(_:))
            .disposed(by: disposeBag)
        
        viewModel.setReferralCode.elements
            .subscribeNext(weak: self, type(of: self).onSuccess)
            .disposed(by: disposeBag)
        
        button.rx.tap.map { [weak self] in
            self?.textField.text ?? ""
        }.bind(to: viewModel.setReferralCode.inputs).disposed(by: disposeBag)
        
    }

    func onSkip() {
        
        let comlectionBlock = getComlectionBlock()
        navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: ZJNotification.didLoginCompletion, object: nil)
            comlectionBlock?()
        })
    
    }
    
    func getComlectionBlock() -> (() -> Void)? {
//        if let vcs = UIApplication.shared.topViewController?.navigationController?.viewControllers {
//            for vc in vcs {
//                if let theVC = vc as? LoginContainerController {
//                    return theVC.loginCompletion
//                }
//            }
//        }
        return nil
    }
    
    
}

// MARK: - Request result
private extension SetReferralcodeController {
    
    func onSuccess(_: Void) {
        
        if let profile = ZJLoginManager.shared.profile {
            profile.isInvested = true
            ZJLoginManager.shared.profile = profile
        }
        
        let comlectionBlock = getComlectionBlock()
        navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: ZJNotification.didLoginCompletion, object: nil)
            comlectionBlock?()
        })
        
    }
    
}
