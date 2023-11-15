//
//  AssetsHoldInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import RxSwift

struct AssetsHoldInfo: AssetsSecureProtocol {
    
    let assets: [AssetsInfo]
    
    let isSecureText: Observable<Bool>
    
}

extension AssetsHoldInfo {
    
    var rowCount: Int {
        
        var count = assets.count / 2
        
        if assets.count % 2 > 0 {
            count = count + 1
        }
        
        return count
        
    }
    
}
