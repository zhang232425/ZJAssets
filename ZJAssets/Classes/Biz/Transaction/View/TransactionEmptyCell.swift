//
//  TransactionEmptyCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit
import ZJExtension

class TransactionEmptyCell: BaseTableViewCell {

    private(set) lazy var iconImageView = UIImageView(image: .named("transaction_empty"))
    
    private(set) lazy var descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.noData.localized
    }

    override func setupViews() {
        
        selectionStyle = .none
        
        let containerView = UIView()
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.left.greaterThanOrEqualToSuperview().inset(40)
            $0.right.lessThanOrEqualToSuperview().inset(40)
        }
        
        iconImageView.add(to: containerView).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        descLabel.add(to: containerView).snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        
    }

}
