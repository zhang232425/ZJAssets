//
//  Data+Extension.swift
//  ZJExtension
//
//  Created by Jercan on 2023/11/24.
//

import Foundation

public extension Data {
    
    func string(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
    
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        try JSONSerialization.jsonObject(with: self, options: options)
    }
    
}
