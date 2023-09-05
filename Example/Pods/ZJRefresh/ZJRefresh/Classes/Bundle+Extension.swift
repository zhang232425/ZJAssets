//
//  Bundle+Extension.swift
//  ESPullToRefresh
//
//  Created by Jercan on 2023/9/4.
//

import Foundation

extension Bundle {
    
    static var framework_ZJRefresh: Bundle {
        let frameworkName = "ZJRefresh"
        let resourcePath: NSString = .init(string: Bundle(for: ZJRefreshClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
}

private class ZJRefreshClass {}



