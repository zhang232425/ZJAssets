//
//  ZJRouter.swift
//  FBSnapshotTestCase
//
//  Created by Jercan on 2022/9/16.
//

import UIKit

public final class ZJRouter {
    
    private static var routesTable = [String: ASInvoker]()
    
    static func register(url: String, invoker: ASInvoker) {
        routesTable[url] = invoker
    }
    
    static func route(url: String) -> ASInvoker? {
        routesTable[url]
    }
    
}

public extension ZJRouter {
    
    static func register(path: ZJRoutePath, handler: @escaping (ZJRouteContext) -> UIViewController?) {
        register(url: path.value, invoker: ASInvoker(handler: handler))
    }
    
    static func route(target: ZJRoutableTarget) -> UIViewController? {
        let path = target.path.value
        let parmaters = target.parameters
        return route(url: path)?.invoke(with: ZJRouteContext(url: path, parameters: parmaters ?? [:]))
    }
    
}

