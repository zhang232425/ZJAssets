//
//  TestHeaderInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/21.
//

import Foundation
import RxSwift

struct TestHeaderInfo: TestSecureProtocol {
    
    var name: String
    
    var age: Int
    
    var address: String
    
    let isSecureText: Observable<Bool>
    
}

struct TestItemInfo: TestSecureProtocol {
    
    var model: TestModel
    
    let isSecureText: Observable<Bool>
    
}
