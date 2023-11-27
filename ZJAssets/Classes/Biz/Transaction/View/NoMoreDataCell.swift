//
//  NoMoreDataCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import UIKit

class NoMoreDataCell: BaseTableViewCell {
    
    private lazy var label = UILabel().then {
        $0.textColor = .init(hexString: "#999999")
        $0.font = .regular12
        $0.text = Locale.noMore.localized
    }

    override func setupViews() {
        
        selectionStyle = .none
        
        label.add(to: contentView).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20.auto)
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
        }
        
    }

}
