//
//  DuplicatedAccountAlertController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/21.
//

import Then
import ZJHUD
import ZJModalTransition

class DuplicatedAccountAlertController: BaseViewController {

    private let account: String
    private let smsCode: String

    private lazy var transition = ZJModalTransition(animator: ZJAlertTransitionAnimator(frame: UIScreen.main.bounds,
                                                                                        backgroundColor: UIColor(white: 0, alpha: 0.6)))
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.auto
        $0.layer.masksToBounds = true
    }
    
    private lazy var label = UILabel().then {
        $0.font = UIFont.regular16
        $0.textColor = UIColor.standard.gray66
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = Locale.accountAlreadyExists.localized(arguments: account.phoneFormattedString)
    }
    
    private lazy var button = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.standard.orange
        $0.setTitleColor(UIColor.standard.white, for: .normal)
        $0.setTitleColor(UIColor.standard.white.withAlpha(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont.bold16
        $0.setTitle(Locale.loginNow.localized, for: .normal)
        $0.layer.cornerRadius = 22.5.auto
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
    }
    
    init(account: String, smsCode: String) {
        self.account = account
        self.smsCode = smsCode
        super.init(nibName: nil, bundle: nil)
        transition.prepare(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
    }
    

}

private extension DuplicatedAccountAlertController {
    
    func setupViews() {
        
        containerView.add(to: view).snp.makeConstraints {
            $0.width.equalTo(320.auto)
            $0.center.equalToSuperview()
        }
        
        label.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(25.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
        }
        
        button.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(45.auto)
            $0.bottom.equalToSuperview().inset(25.auto)
        }
        
        
    }
    
    @objc func onConfirm() {
        
        self.dismiss(animated: true)
        
    }
    
}

private extension String {
    
    var phoneFormattedString: String {
        if count <= 2 { return self }
        let tail = [Character](self)[2...]
        var newTail = [Character]()
        for (i, ch) in tail.enumerated() {
            if i % 4 == 0 {
                newTail.append(" ")
            }
            newTail.append(ch)
        }
        return prefix(2) + String(newTail)
    }
}
