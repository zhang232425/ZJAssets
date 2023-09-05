//
//  ZJAssetsModule.swift
//  ZJAssets
//
//  Created by Jercan on 2023/9/5.
//

import ZJRouter
import ZJRoutableTargets

public struct ZJAssetsModule: ZJModule {
    
    public init() {}
    
    public func initialize() {
                
        ZJRouter.register(path: ZJAssetsRoutePath.assets) { _ in
            return ZJAssetsViewController()
        }
        
        ZJAssetsRoutableTarget.register(path: ZJAssetsRoutePath.orderDetail) {
            
            let orderId = $0.parameters["orderId"] as! String
            let orderType = $0.parameters["orderType"] as! Int
            let productId = $0.parameters["productId"] as! String

            return ZJOrderDetailViewController()
        }
        
    }
    
}





