//
//  Bundle+Extension.swift
//  ZJBase
//
//  Created by Jercan on 2022/10/18.
//

import Foundation

extension Bundle {
    
    static var framework_ZJBase: Bundle {
        let frameworkName = "ZJBase"
        let resourcePath: NSString = .init(string: Bundle(for: ZJBaseClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJBaseClass {}
    
}
