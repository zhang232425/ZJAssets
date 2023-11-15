//
//  AssetsSecureProtocol.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import RxSwift

protocol AssetsSecureProtocol {
    
    var isSecureText: Observable<Bool> { get }
    
    var secureText: String { get }
    
}

extension AssetsSecureProtocol {
    
    var secureText: String { "******" }
    
}
