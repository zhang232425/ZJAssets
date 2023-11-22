//
//  DepositSignView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import ZJActiveLabel

class DepositSignView: BaseView {

    private lazy var iconImageView = UIImageView(image: .named("icon_sign"))
    
    private lazy var arrowImageView = UIImageView(image: .named("icon_arrow_pay"))
    
    private(set) lazy var label = ActiveLabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#333333")
        $0.numberOfLines = 2
    }

    override func setupViews() {
        
        backgroundColor = .init(hexString: "#F9F9F9")
        
        iconImageView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(12)
            $0.width.height.equalTo(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        
        label.add(to: self).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.left.equalTo(iconImageView.snp.right).offset(8)
        }
        
        arrowImageView.add(to: self).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(label.snp.right).offset(8)
            $0.right.equalToSuperview().inset(12)
            $0.width.height.equalTo(16)
        }
        
    }
    
    func setContent(content: String, key: String) {
        
        let keyType: ActiveType = .custom(pattern: key)
        label.enabledTypes = [keyType]
        label.text = content
        label.customColor[keyType] = UIColor.init(hexString: "#FF7D0F")
        
    }


}
