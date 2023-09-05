//
//  Bundle+Extension.swift
//  Pods-ZJHUD_Example
//
//  Created by Jercan on 2022/10/20.
//

import Foundation

extension Bundle {
    
    static var framework_ZJHUD: Bundle {
        let frameworkName = "ZJHUD"
        let resourcePath: NSString = .init(string: Bundle(for: ZJHUDClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJHUDClass {}
    
}

