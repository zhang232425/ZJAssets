//
//  ZJLoginRoutableTarget.swift
//  Pods-ZJRoutableTargets_Example
//
//  Created by Jercan on 2022/9/16.
//

import ZJRouter

public struct ZJLoginRoutePath {}

public extension ZJLoginRoutePath {
    static let login    = ZJRoutePath(value: "as://login.login")
    static let register = ZJRoutePath(value: "as://login.register")
}

public enum ZJLoginRoutableTarget: ZJRoutableTarget {
    
    case login
    case register(success: () -> ())
    
}

extension ZJLoginRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .login:
            return ZJLoginRoutePath.login
        case .register:
            return ZJLoginRoutePath.register
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .login:
            return nil
        case .register(let success):
            return ["success": success]
        }
    }
    
}
