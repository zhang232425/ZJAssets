//
//  OldEntranceView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit

class OldEntranceView: BaseView {

    private lazy var label = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.oldHistory.localized
    }
    
    private lazy var arrowImageView = UIImageView(image: .named("icon_arrow_history"))

    override func setupViews() {
                        
        label.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16.auto)
        }
                
        arrowImageView.add(to: self).snp.makeConstraints {
            $0.left.equalTo(label.snp.right).offset(4.auto)
            $0.centerY.right.equalToSuperview()
            $0.width.height.equalTo(16.auto)
        }
        
    }

}
