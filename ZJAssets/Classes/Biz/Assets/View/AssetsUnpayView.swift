//
//  AssetsUnpayView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import UIKit

class AssetsUnpayView: BaseView {

    private lazy var iconImageView = UIImageView(image: .named("icon_unpay"))
    
    private lazy var arrowImageView = UIImageView(image: .named("icon_arrow_pay"))
    
    private(set) lazy var label = UILabel().then {
        $0.font = .regular12
        $0.textColor = UIColor(hexString: "#333333")
        $0.numberOfLines = 2
    }

    override func setupViews() {
        
        backgroundColor = UIColor(hexString: "#F9F9F9")
        
        iconImageView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.auto)
            
        }
        
        label.add(to: self).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12.auto)
            $0.left.equalTo(iconImageView.snp.right).offset(8.auto)
        }
        
        arrowImageView.add(to: self).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(label.snp.right).offset(8.auto)
            $0.right.equalToSuperview().inset(12.auto)
            $0.width.height.equalTo(16.auto)
        }
        
    }
    

}
