//
//  ZJLoginModule.swift
//  ZJLogin-ZJLogin
//
//  Created by Jercan on 2023/9/12.
//

import ZJRouter
import ZJRoutableTargets

public struct ZJLoginModule: ZJModule {
    
    static var loginResultRouter: LoginResultRouter?
    
    public init() {}
    
    public func initialize() {
        
        ZJLoginRoutableTarget.register(path: ZJLoginRoutePath.login) { _ in
            return LoginContainerController()
        }
        
        ZJRouter.register(path: ZJLoginRoutePath.register) { _ in
            return RegisterViewController()
        }
        
    }
        
    
}
