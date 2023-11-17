//
//  AssetsInsureView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/16.
//

import UIKit

class AssetsInsureView: BaseView {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .bold20
        $0.textColor = .init(hexString: "#2B3033")
        $0.text = Locale.insureTitle.localized
    }
    
    private lazy var leftView = AssetsInsureContentView().then {
        $0.titleLabel.text = Locale.insureNumber.localized
        $0.descLabel.text = Locale.familyMember.localized
    }
    
    private lazy var rightView = AssetsInsureContentView().then {
        $0.titleLabel.text = Locale.policyNumber.localized
        $0.descLabel.text = Locale.familyPolicy.localized
    }
    
    private lazy var containerView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
        $0.layer.borderWidth = 1
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick)))
    }
    
    var clickHandler: (() -> ())?
    
    var info: InsureInfo? {
        didSet {
            if let info = info, info.insureCount.intValue > 0 {
                createNormalView()
                leftView.numLabel.text = info.personCount.stringValue
                rightView.numLabel.text = info.insureCount.stringValue
            } else {
                createEmptyView()
            }
        }
    }

    override func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        containerView.add(to: self).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }

}

private extension AssetsInsureView {
    
    @objc
    func handleClick() {
        clickHandler?()
    }
    
    func createNormalView() {
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        leftView.add(to: containerView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(12)
        }
        
        let line = UIView()
        
        line.add(to: containerView).then {
            $0.backgroundColor = .init(hexString: "#F0F0F0")
        }.snp.makeConstraints {
            $0.left.equalTo(leftView.snp.right).offset(12)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
        }
        
        rightView.add(to: containerView).snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(12)
            $0.top.bottom.right.equalToSuperview().inset(12)
        }
        
    }
    
    func createEmptyView() {
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        let iconImageView = UIImageView(image: .named("insure_empty"))
        
        iconImageView.add(to: containerView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(128)
            $0.height.equalTo(85)
        }
        
        let label = UILabel()
        
        label.add(to: containerView).then {
            $0.font = .medium14
            $0.textColor = .init(hexString: "#FF7300")
            $0.numberOfLines = 0
            $0.text = Locale.insureTip.localized
        }.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(12)
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().inset(12)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        
    }
    
}

private class AssetsInsureContentView: BaseView {
    
    private(set) lazy var numLabel = UILabel().then {
        $0.font = .bold14
        $0.textColor = .init(hexString: "#FF7300")
    }
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#666666")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    private(set) lazy var descLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    override func setupViews() {
        
        numLabel.add(to: self).snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.left.equalTo(numLabel.snp.right).offset(4)
            $0.centerY.equalTo(numLabel)
            $0.right.lessThanOrEqualToSuperview()
        }
        
        descLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

