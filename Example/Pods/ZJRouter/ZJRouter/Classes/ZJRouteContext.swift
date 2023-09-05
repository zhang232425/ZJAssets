//
//  ZJRouteContext.swift
//  FBSnapshotTestCase
//
//  Created by Jercan on 2022/9/16.
//

import Foundation

public struct ZJRouteContext {
    
    public let url: String
    
    public let parameters: [String: Any]
    
    public init(url: String, parameters: [String: Any] = [:]) {
        self.url = url
        self.parameters = parameters
    }
    
}

extension ZJRouteContext: CustomStringConvertible {
    public var description: String {
        return "url = \(url)\nparameters = \(parameters.description)"
    }
}

extension ZJRouteContext: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "url = \(url)\nparametes = \(parameters.debugDescription)"
    }
}

