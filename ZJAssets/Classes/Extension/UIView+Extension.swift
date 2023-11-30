//
//  UIView+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation

extension UIView {
    
    convenience init(backgroundColor: UIColor? = .white, cornerRadius: CGFloat? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
}
