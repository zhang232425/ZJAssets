//
//  ZJMainRoutableTarget.swift
//  ZJRoutableTargets
//
//  Created by Jercan on 2023/9/5.
//

import ZJRouter

public struct ZJMainRoutePath {}

public extension ZJMainRoutePath {
    
    static let entry = ZJRoutePath(value: "as://main.entry")
    static let identity = ZJRoutePath(value: "as://mian.identity")
    static let tab = ZJRoutePath(value: "as//main.tab")
    static let tabIndex = ZJRoutePath(value: "as//main.tabIndex")
    
}

public enum ZJMainRoutableTarget {
    
    case entry
    case identity
    case tab
    case tabIndex(index: Int)
    
}

extension ZJMainRoutableTarget: ZJRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .entry:
            return ZJMainRoutePath.entry
        case .identity:
            return ZJMainRoutePath.identity
        case .tab:
            return ZJMainRoutePath.tab
        case .tabIndex:
            return ZJMainRoutePath.tabIndex
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .entry:
            return nil
        case .identity:
            return nil
        case .tab:
            return nil
        case .tabIndex(let index):
            return ["index": index]
        }
    }
    
    
}
