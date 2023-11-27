//
//  TransactionTitleSelectView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit

class TransactionTitleSelectView: BaseView {
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#333333")
    }

    private lazy var arrowImageView = UIImageView(image: .named("icon_arrow_down"))

    override func setupViews() {
        
        layer.cornerRadius = 12.auto
        backgroundColor = .white
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(12.auto)
            $0.top.bottom.equalToSuperview().inset(4.auto)
        }
        
        arrowImageView.add(to: self).snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(4.auto)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12.auto)
            $0.width.equalTo(8.auto)
            $0.height.equalTo(4.auto)
        }
        
    }

}
