//
//  Bundle+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/9.
//

import Foundation

extension Bundle {
    
    static var framework_ZJAssets: Bundle {
        let frameworkName = "ZJAssets"
        let resourcePath: NSString = .init(string: Bundle(for: ZJAssetsClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJAssetsClass {}
    
}

