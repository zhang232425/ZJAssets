//
//  UIImage+Extension.swift
//  Pods-ZJHUD_Example
//
//  Created by Jercan on 2022/10/20.
//

import Foundation
import ZJExtension

extension UIImage {
    
    private class Class {}
    
    static func named(_ name: String) -> UIImage? {
        UIImage(name: name, bundle: .framework_ZJHUD)
    }
    
}



