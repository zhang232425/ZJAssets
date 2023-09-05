//
//  ZJPersonalRoutableTarget.swift
//  Pods-ZJRoutableTargets_Example
//
//  Created by Jercan on 2022/9/16.
//

import ZJRouter

public struct ZJPersonalRoutePath {}
    
public extension ZJPersonalRoutePath {
    static let personal = ZJRoutePath(value: "as://personal.personal")
}

public enum ZJPersonalRoutableTarget: ZJRoutableTarget {
    case personal
}

extension ZJPersonalRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .personal:
            return ZJPersonalRoutePath.personal
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .personal:
            return nil
        }
    }
    
}
