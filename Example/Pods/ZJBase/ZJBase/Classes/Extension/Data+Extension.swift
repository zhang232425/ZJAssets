//
//  Data+Extension.swift
//  ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import Foundation

extension Data {
    
    /// 不存在
    func string(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
    
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        try JSONSerialization.jsonObject(with: self, options: options)
    }
    
}


