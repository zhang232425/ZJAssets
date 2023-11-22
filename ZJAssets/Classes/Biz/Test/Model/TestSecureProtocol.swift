//
//  TestSecureProtocol.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/21.
//

import Foundation
import RxSwift

protocol TestSecureProtocol {
    
    var isSecureText: Observable<Bool> { get }
    
    var secureText: String { get }
    
}

extension TestSecureProtocol {
    
    var secureText: String { "*********" }
    
}
