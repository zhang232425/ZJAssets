//
//  UIImage+Extension.swift
//  ZJLogin-ZJLogin
//
//  Created by Jercan on 2023/9/12.
//

import ZJExtension

extension UIImage: NamespaceWrappable {}

extension NamespaceWrapper where T: UIImage {
    
    static func named(_ name: String) -> UIImage? {
        return UIImage(name: name, bundle: .framework_ZJLogin)
    }

}
