//
//  CountDownView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import ZJCommonView

class CountDownView: RoundCornerView {
    
    private lazy var clockImageView = UIImageView(image: .named("icon_clock"))
    
    private(set) lazy var label = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#FF7D0F")
    }
    
    init() {
        super.init(radius: 10)
        corners = .allCorners
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
        backgroundColor = .init(hexString: "#FFF4EA")
        
        clockImageView.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(10)
        }
        
        label.add(to: self).snp.makeConstraints {
            $0.left.equalTo(clockImageView.snp.right).offset(3)
            $0.top.bottom.equalToSuperview().inset(3)
            $0.right.equalToSuperview().inset(8)
        }
        
    }
    
}
