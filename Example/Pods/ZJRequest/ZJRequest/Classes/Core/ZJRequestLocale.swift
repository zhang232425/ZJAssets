//
//  ZJRequestLocale.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import ZJLocalizable

enum ZJRequestLocale: String {
    case codeError4xx = "code_error_4xx"
    case codeError5xx = "code_error_5xx"
    case networkError = "network_error"
    case requestTimeout = "request_timeout"
    case illegalOperation = "illegal_operation"
}

extension ZJRequestLocale: ZJLocalizable {
    
    var key: String { rawValue }
    
    var table: String { "Locale" }
    
    var bundle: Bundle { .framework_ZJRequest }
    
}

extension Bundle {
    
    static var framework_ZJRequest: Bundle {
        let frameworkName = "ASRequest"
        let resourcePath: NSString = .init(string: Bundle(for: ZJRequestClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJRequestClass {}
    
}
