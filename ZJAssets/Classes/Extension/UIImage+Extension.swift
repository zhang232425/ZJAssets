//
//  UIImage+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/9.
//

import ZJExtension

extension UIImage {
    
    static func named(_ name: String) -> UIImage? {
        UIImage(name: name, bundle: .framework_ZJAssets)
    }
    
}
