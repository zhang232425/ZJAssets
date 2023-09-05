//
//  ZJRequestResult.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import HandyJSON

public struct ZJRequestResult<T>: HandyJSON {
    
    public var data: T?
    
    public var errCode: String?
    
    public var errMsg = ""
    
    public var success = false
    
    public var sysTime: NSNumber?
    
    public init() {}
    
}

