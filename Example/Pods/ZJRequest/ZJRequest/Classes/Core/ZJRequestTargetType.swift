//
//  ZJRequestTargetType.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import Moya

#if canImport(RxSwift)

import RxSwift

public protocol ZJRequestTargetType: TargetType, ReactiveCompatible {
    
    var plugins: [PluginType] { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var callbackQueue: DispatchQueue? { get }
    
    var stubBehavior: StubBehavior { get }
    
}

#else

public protocol ZJRequestTargetType: TargetType {
    
    var plugins: [PluginType] { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var callbackQueue: DispatchQueue? { get }
    
    var stubBehavior: StubBehavior { get }
    
}

#endif

public extension ZJRequestTargetType {
    
    var plugins: [PluginType] { [] }
    
    var timeoutInterval: TimeInterval { 60 }
    
    var callbackQueue: DispatchQueue? { nil }
    
    var stubBehavior: StubBehavior { .never }
    
}

