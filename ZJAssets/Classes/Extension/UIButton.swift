//
//  UIButton.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation

extension UIButton {
    
    convenience init(backgroundColor: UIColor? = .white,
                     title: String? = nil,
                     textColor: UIColor? = .white,
                     font: UIFont? = UIFont.regular14,
                     cornerRadius: CGFloat = 0) {
        self.init(type: .custom)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        if let font = font {
            self.titleLabel?.font = font
        }
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
}
