//
//  ZJRoutableTarget.swift
//  FBSnapshotTestCase
//
//  Created by Jercan on 2022/9/16.
//

import UIKit

public struct ZJRoutePath {
    
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
}

public protocol ZJRoutableTarget {
    
    var path: ZJRoutePath { get }
    
    var parameters: [String: Any]? { get }
    
}

public extension ZJRoutableTarget {
    
    var viewController: UIViewController? {
        ZJRouter.route(target: self)
    }
    
    static func register(path: ZJRoutePath, handler: @escaping (ZJRouteContext) -> UIViewController?) {
        ZJRouter.register(path: path, handler: handler)
    }
    
}

