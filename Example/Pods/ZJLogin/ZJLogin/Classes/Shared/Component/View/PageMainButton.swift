//
//  PageMainButton.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import UIKit

class PageMainButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.standard.orange
        setTitleColor(UIColor.standard.white, for: .normal)
        setTitleColor(UIColor.standard.white.withAlpha(0.5), for: .highlighted)
        titleLabel?.font = UIFont.bold16
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
        layer.masksToBounds = true
    }
    
}
