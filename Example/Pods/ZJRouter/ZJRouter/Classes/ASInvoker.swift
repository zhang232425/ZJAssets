//
//  ASInvoker.swift
//  FBSnapshotTestCase
//
//  Created by Jercan on 2022/9/16.
//

import UIKit

public struct ASInvoker {
    
    private let handler: (ZJRouteContext) -> UIViewController?
    
    init(handler: @escaping (ZJRouteContext) -> UIViewController?) {
        self.handler = handler
    }
    
    func invoke(with context: ZJRouteContext) -> UIViewController? {
        return handler(context)
    }
    
}

