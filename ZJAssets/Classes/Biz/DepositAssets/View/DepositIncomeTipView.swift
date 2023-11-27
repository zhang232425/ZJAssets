//
//  DepositIncomeTipView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit

class DepositIncomeTipView: BaseView {
    
    private lazy var label = UILabel().then {
        $0.textColor = UIColor(hexString: "#999999")
        $0.font = .regular12
        $0.text = Locale.incomeBottomTip.localized
    }

    override func setupViews() {
        
        label.add(to: self).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20.auto)
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
        }
        
    }

}
