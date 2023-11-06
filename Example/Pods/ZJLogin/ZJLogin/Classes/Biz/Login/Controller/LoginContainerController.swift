//
//  LoginViewController.swift
//  Pods-ZJLogin_Example
//
//  Created by Jercan on 2023/9/12.
//

import UIKit

enum LoginMode {
    case code
    case password
    static let `default`: LoginMode = .password
}

protocol LoginControllerTransitioner {
    func transition(to new: LoginMode)
}

class LoginContainerController: BaseViewController {
    
    var loginCompletion: (() -> Void)?
    var loginClose: (() -> Void)?
    
    private(set) var mode = LoginMode.default {
        didSet { transition(to: mode, from: oldValue)  }
    }
    
    private lazy var viewModel = LoginViewModel()
    
    private lazy var codeVC = CodeLoginController(viewModel: viewModel)
    
    private lazy var pwdVC = PasswordLoginController(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

}

private extension LoginContainerController {
    
    func setupViews() {
        
        _transition(to: LoginMode.default, from: .default)
        
        if navigationController?.viewControllers.first == self {
            navigationItem.leftBarButtonItem = .custom(image: UIImage.dd.named("nav_close"), action: { [weak self] in
                self?.loginClose?()
                self?.navigationController?.dismiss(animated: true)
            })
        }
        
    }
    
    func bindViewModel() {
        
        
    }
    
    func transition(to new: LoginMode, from old: LoginMode) {
        
        guard new != old else { return }
        _transition(to: new, from: old)
        
    }

    func _transition(to new: LoginMode, from old: LoginMode) {
        
        childViewControllers.first?.willMove(toParentViewController: nil)
        childViewControllers.first?.view.removeFromSuperview()
        childViewControllers.first?.removeFromParentViewController()
        
        var lastInputPhone = ""
        switch old {
        case .code:
            lastInputPhone = codeVC.inputPhone
        case .password:
            lastInputPhone = pwdVC.inputPhone
        }
        
        let vc: UIViewController
        switch new {
        case .code:
            codeVC.inputPhone = lastInputPhone
            vc = codeVC
        case .password:
            pwdVC.inputPhone = lastInputPhone
            vc = pwdVC
        }
    
        addChildViewController(vc)
        vc.view.with{ $0.frame = view.bounds }.add(to: view)
        vc.didMove(toParentViewController: self)
        
        navigationItem.rightBarButtonItem = vc.navigationItem.rightBarButtonItem
        
    }
    
}

extension LoginContainerController: LoginControllerTransitioner {
    
    func transition(to new: LoginMode) {
        mode = new
    }
    
}


