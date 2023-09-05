//
//  ZJAssetsRoutableTarget.swift
//  ZJRoutableTargets
//
//  Created by Jercan on 2023/9/5.
//

import ZJRouter

public struct ZJAssetsRoutePath {}

public extension ZJAssetsRoutePath {
    
    static let assets = ZJRoutePath(value: "as://assets.main")
    static let orderDetail = ZJRoutePath(value: "as://assets.orderDetail")
    
}

public enum ZJAssetsRoutableTarget {
    case assets
    case orderDetail(productId: String, orderId: String, orderType: Int)
}

extension ZJAssetsRoutableTarget: ZJRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .assets:
            return ZJAssetsRoutePath.assets
        case .orderDetail:
            return ZJAssetsRoutePath.orderDetail
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .assets:
            return nil
        case .orderDetail(let productId, let orderId, let orderType):
            var params = [String: Any]()
            params["productId"] = productId
            params["orderId"] = orderId
            params["orderType"] = orderType
            return params
        }
    }
    
}
