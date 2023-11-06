//
//  Bundle+Extension.swift
//  Pods-ZJLogin_Example
//
//  Created by Jercan on 2023/9/12.
//

import Foundation

extension Bundle {
    
    static var framework_ZJLogin: Bundle {
        let frameworkName = "ZJLogin"
        let resourcePath: NSString = .init(string: Bundle(for: ZJLoginClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJLoginClass {}
    
}


