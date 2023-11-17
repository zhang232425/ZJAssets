//
//  AssetsBalanceView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/16.
//

import UIKit
import RxSwift
import ZJCommonView

class AssetsBalanceView: BaseView {
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    private var bag = DisposeBag()
    
    private lazy var bgImageView = UIImageView(image: .named("balance_bg"))
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = UIColor(hexString: "#999999")
        $0.text = Locale.balance.localized
    }
    
    private lazy var amountLabel = UILabel().then {
        $0.font = .medium15
        $0.textColor = .init(hexString: "#2B3033")
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var button = UIButton(type: .system).then {
        $0.layer.borderWidth = 1
        let color = UIColor(hexString: "#FF7300")
        $0.layer.borderColor = color.cgColor
        $0.setTitleColor(color, for: .normal)
        $0.contentEdgeInsets = .init(top: 7, left: 12, bottom: 7, right: 12)
        $0.titleLabel?.font = .medium12
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        $0.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        $0.setTitle(Locale.continueFund.localized, for: .normal)
    }

    private lazy var rateBgView = RoundCornerView(radius: 7).then {
        $0.corners = [.topLeft, .topRight, .bottomRight]
        $0.backgroundColor = .init(hexString: "#FF7300")
    }
    
    private lazy var rateLabel = UILabel().then {
        $0.font = .medium11
        $0.textColor = .white
    }
    
    var clickAction: (() -> ())?
    
    var info: AssetsBalanceInfo? {
        
        didSet {
            
            bag = DisposeBag()
            
            info?.isSecureText.subscribeNext(weak: self, AssetsBalanceView.updateText).disposed(by: bag)
            
//            if let balance = info?.balance, balance > 0 {
//                button.isHidden = false
//            } else {
                button.isHidden = true
//            }
            
            rateBgView.isHidden = true
            if let rate = info?.rate, rate.intValue > 0 {
//                rateBgView.isHidden = false
                rateLabel.text = info?.rateDesc
            } else {
//                rateBgView.isHidden = true
            }
            
        }
        
    }

    override func setupViews() {
        
        setupLayer()
        
        self.backgroundColor = .red
        
        layer.cornerRadius = 4
        layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
        layer.borderWidth = 1
        
        bgImageView.add(to: self).snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.left.greaterThanOrEqualToSuperview()
            $0.right.equalToSuperview().inset(50)
        }
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(12)
        }
        
        amountLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        button.add(to: self).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(9)
            $0.left.greaterThanOrEqualTo(amountLabel.snp.right).offset(9)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(11)
            $0.width.greaterThanOrEqualTo(90)
        }
        
        rateBgView.add(to: self).snp.makeConstraints {
            $0.right.equalTo(button)
            $0.centerY.equalTo(button.snp.top).offset(-3)
        }
        
        rateLabel.add(to: rateBgView).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.left.right.equalToSuperview().inset(5)
        }
        
    }

}

private extension AssetsBalanceView {
    
    func updateText(_ isSecure: Bool) {
        
        if isSecure {
            amountLabel.text = info?.secureText
        } else {
            amountLabel.text = info?.balanceDesc
        }
        
    }
    
    @objc
    func buttonClick() {
        clickAction?()
    }
    
    func setupLayer() {
        
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 0)
        gradientLayer.colors = ["#FFFFFF", "#FFFBF7"].map { UIColor(hexString: $0).cgColor }
        
    }
    
}
