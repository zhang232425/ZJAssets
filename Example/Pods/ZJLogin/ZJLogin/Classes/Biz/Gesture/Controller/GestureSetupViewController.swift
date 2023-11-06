//
//  GestureSetupViewController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/11.
//

import UIKit
import ZJLoginManager
import ZJCommonDefines

public enum GestureType: Int {
    /// 启用，激活
    case enable  = 0
    /// 无效，禁用
    case disable = 1
    /// 重置
    case reset   = 2
}

class GestureSetupViewController: BaseViewController {
    
    // MARK: - Property
    var viewModel = GestureSetupViewModel()

    var loginCompletion: (() -> Void)?
    // 个人中心首次设置手势密码
    var onEnableSuccessFromPersonalModule: (() -> Void)?
    
    private lazy var gestureIndicator = GestureIndicator().then {
        $0.backgroundColor = .white
    }
    
    private lazy var descLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "#3E4A5A")
        $0.font = UIFont.regular14
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Lazy Load
    private lazy var skipButton = UIBarButtonItem().then {
        $0.style = .plain
        $0.tintColor = UIColor(hexString: "#3E4A5A")
        $0.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.regular12], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.regular12], for: .highlighted)
    }

    private lazy var remindLabel = GestureRemindLabel().then {
        $0.font = UIFont.regular12
        $0.textColor = UIColor(hexString: "#A8AAB4")
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var gestureLockView = GestureLockView().then {
        $0.backgroundColor = .white
        $0.delegate = self
    }
    
    // MARK: - Init Method
    init(type: GestureType, isFromLogin: Bool = false, isConfirmPage: Bool = false, loginPassword: String? = nil, oldGesture: String? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.isFromLogin = isFromLogin
        
        viewModel.isConfirmPage = isConfirmPage
        
        viewModel.loginPassword = loginPassword
        
        viewModel.type = type
        
        viewModel.oldGesture = oldGesture
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setText()
        bindViewModel()
    }
    
}

private extension GestureSetupViewController {
    
    func setupViews() {
        
        gestureIndicator.add(to: view).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(60.auto)
            $0.width.height.equalTo(45.auto)
        }
        
        descLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(gestureIndicator.snp.bottom).offset(40.auto)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        remindLabel.add(to: view).snp.makeConstraints {
            $0.centerX.left.right.equalTo(descLabel)
            $0.height.greaterThanOrEqualTo(20.auto).priority(.high)
            $0.top.equalTo(descLabel.snp.bottom).offset(25.auto)
        }
    
        gestureLockView.add(to: view).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(remindLabel.snp.bottom).offset(8.auto)
            $0.width.height.equalTo(view.frame.width - 40.auto)
        }
        
    }
    
    func setText() {
        
        navigationItem.title = viewModel.title
        
        descLabel.text = viewModel.desc
        
        remindLabel.text = viewModel.remind
        
        skipButton.title = viewModel.skip
        
        gestureIndicator.gesture = viewModel.indicatorGesture
        
    }
    
    func bindViewModel() {
        
        skipButton.rx.tap.asDriver().throttle(.seconds(1), latest: true).drive(onNext: { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: self?.loginCompletion)
        }).disposed(by: disposeBag)
        
    }
    
}

extension GestureSetupViewController: GestureLockViewDelegate {
    
    func gestureLockViewTouchBeigin() {
        debugPrint("控制器监听到开始绘制了")
    }
    
    func gestureLockViewDidSelect(gestureLockView: GestureLockView, gesture: String, completion: ((Bool) -> Void)?) {
        
        guard let _ = viewModel.newGesture else {
            
            // 首次输入，长度不够
            if gesture.count <= 3 {
                remindLabel.showWarnMsgAndShake(Locale.length_error_gesture.localized)
                completion?(false)
                return
            }
            
            // 输入超过三位即有效手势密码
            let resetVC = GestureSetupViewController(type: viewModel.type, isFromLogin: viewModel.isFromLogin, isConfirmPage: true, loginPassword: viewModel.loginPassword, oldGesture: viewModel.oldGesture)
            resetVC.onEnableSuccessFromPersonalModule = onEnableSuccessFromPersonalModule
            resetVC.loginCompletion = loginCompletion
            resetVC.viewModel.newGesture = gesture
            
            // 重置页面
            gestureLockView.resetGesture()
            remindLabel.text = nil
            completion?(true)
            navigationController?.pushViewController(resetVC, animated: true)
            return
            
        }
        
        // 二次确认失败
        guard viewModel.newGesture == gesture else {
            
            remindLabel.showWarnMsgAndShake(viewModel.tryAgain)
            
            completion?(false)
            
            return
            
        }
        
        // 二次确认成功
        switch viewModel.type {
            
        case .enable:
            
            guard let news = viewModel.newGesture, let password = viewModel.loginPassword else {
                
                remindLabel.showWarnMsgAndShake(viewModel.tryAgain)
                
                completion?(false)
                
                return
                
            }
            
            viewModel.setGesture(gesture: news, loginPassword: password) { [weak self] (success, errMsg) in
                
                guard success else {
                    
                    self?.remindLabel.text = nil
                    completion?(false)
                    guard let errMsg = errMsg else { return }
                    self?.remindLabel.showWarnMsgAndShake(errMsg)
                    return
                    
                }
                
                if let profile = ZJLoginManager.shared.profile {
                    
                    profile.isSetGesture = true
                    LastUserInfo.refreshIsSetGesture(true)
                    ZJLoginManager.shared.profile = profile
                    
                }
                
                guard let weakself = self, let nav = weakself.navigationController else {
                    
                    self?.remindLabel.text = nil
                    completion?(false)
                    return
                    
                }
                
                NotificationCenter.default.post(name: ZJNotification.changeGesture, object: nil)
        
                DispatchQueue.main.async {
                    
                    if weakself.viewModel.isFromLogin {
                        nav.dismiss(animated: true, completion: self?.loginCompletion)
                    } else {
                        if let action = weakself.onEnableSuccessFromPersonalModule {
                            action()
                        } else {
                            nav.dd.popToViewControllerAtLastIndex(lastIndex: 3)
                        }
                    }
                    
                }
                
            }
            
        case .disable:
            break
            
        case .reset:
            break
            
        }
        
    }
    
}
