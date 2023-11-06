//
//  ZJFundRoutableTarget.swift
//  ZJRoutableTargets
//
//  Created by Jercan on 2023/9/9.
//

import ZJRouter

public struct ZJFundRoutePath {}

public extension ZJFundRoutePath {
    
    static let fund = ZJRoutePath(value: "as://fund.fund")
    
}

public enum ZJFundRoutableTarget {
    
    case fund
    
}

extension ZJFundRoutableTarget: ZJRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .fund:
            return ZJFundRoutePath.fund
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .fund:
            return nil
        }
    }
    
    
    
}
