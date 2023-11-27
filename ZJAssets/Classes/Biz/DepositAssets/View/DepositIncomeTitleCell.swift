//
//  DepositIncomeTitleCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit
import ZJExtension

class DepositIncomeTitleCell: DepositBaseCell {

    private lazy var leftLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.productName.localized
    }
    
    private lazy var rightLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.totalEarning.localized
    }
    
    override func setupViews() {
        
        let containerView = UIView()
        
        containerView.add(to: contentView).then {
            $0.backgroundColor = .init(hexString: "#F3F3F3")
            $0.layer.cornerRadius = 4.auto
        }.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.auto)
        }
        
        leftLabel.add(to: containerView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(8.auto)
            $0.top.bottom.equalToSuperview().inset(6.auto)
            $0.right.lessThanOrEqualTo(containerView.snp.centerX).inset(8.auto)
        }
        
        rightLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(containerView.snp.centerX).inset(8.auto)
            $0.right.equalToSuperview().inset(8.auto)
            $0.top.bottom.equalToSuperview().inset(6.auto)
        }
        
    }

}
