//
//  FrozenAlertController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/7.
//

import UIKit
import ZJHUD
import ZJModalTransition
import ZJActiveLabel

class FrozenAlertController: UIViewController {
    
    private lazy var transition = ZJModalTransition(animator: ZJAlertTransitionAnimator(frame: UIScreen.main.bounds,
                                                                                        backgroundColor: .init(white: 0, alpha: 0.5)))
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = UIColor.standard.white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.bold20
        $0.textColor = UIColor.standard.black33
        $0.numberOfLines = 0
        $0.text = Locale.frozenTitle.localized
    }
    
    private lazy var label_1 = UILabel().then {
        $0.font = UIFont.regular16
        $0.textColor = UIColor.standard.gray66
        $0.numberOfLines = 0
        $0.text = Locale.accountFrozenNotice.localized
    }
    
    private lazy var label_2 = ActiveLabel().then {
        $0.font = UIFont.regular16
        $0.textColor = UIColor.standard.gray66
        $0.numberOfLines = 0
        let phone = "1500226"
        let string = Locale.accountFrozenPhonePrefix.localized + " " + phone
        let type = ActiveType.custom(pattern: string)
        $0.enabledTypes = [type]
        $0.text = string
        $0.customSelectedColor[type] = UIColor(hexString: "a8aab4")
        $0.customColor[type] = UIColor.standard.gray66
        $0.customUnderLineStyle[type] = .styleSingle
        $0.handleCustomTap(for: type) { _ in
            UIPasteboard.general.string = phone
            ZJHUD.noticeOnlyText(Locale.phoneCopied.localized)
        }
        
    }
    
    private lazy var button = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.standard.orange
        $0.setTitleColor(UIColor.standard.white, for: .normal)
        $0.setTitleColor(UIColor.standard.white.withAlpha(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont.bold16
        $0.setTitle(Locale.iKnow.localized, for: .normal)
        $0.layer.cornerRadius = 20.auto
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transition.prepare(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

private extension FrozenAlertController {
    
    func setupViews() {
        
        containerView.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.center.equalToSuperview()
        }
        
        titleLabel.add(to: containerView).snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(20.auto)
        }
        
        label_1.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.auto)
            $0.left.right.equalTo(titleLabel)
        }
        
        label_2.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(label_1.snp.bottom).offset(8.auto)
            $0.left.right.equalTo(label_1)
        }
        
        button.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(label_2.snp.bottom).offset(16.auto)
            $0.left.right.equalTo(label_2)
            $0.height.equalTo(40.auto)
            $0.bottom.equalToSuperview().inset(20.auto)
        }
        
    }
    
    @objc func confirmClick() {
        dismiss(animated: true)
    }
    
}
