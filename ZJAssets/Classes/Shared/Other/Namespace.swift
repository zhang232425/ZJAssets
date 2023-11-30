//
//  Namespace.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

protocol NamespaceWrappable {
    
    associatedtype WrapperType
    
    var dd: WrapperType { get }
    
    static var dd: WrapperType.Type { get }
    
}

extension NamespaceWrappable {
    
    var dd: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var dd: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
    
}

struct NamespaceWrapper<T> {
    
    let warppedValue: T
    
    init(value: T) {
        self.warppedValue = value
    }
}
