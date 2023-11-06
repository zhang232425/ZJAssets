//
//  Namespace.swift
//  ZJLogin-ZJLogin
//
//  Created by Jercan on 2023/9/12.
//

import Foundation

protocol NamespaceWrappable {
    
    associatedtype WrapperType
    
    var dd: WrapperType { get }
    
    static var dd: WrapperType.Type { get }
    
}

extension NamespaceWrappable {
    
    var dd: NamespaceWrapper<Self> {
        return NamespaceWrapper(warppedValue: self)
    }
    
    static var dd: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
    
}

struct NamespaceWrapper<T> {
    
    let warppedValue: T
    
    init(warppedValue: T) {
        self.warppedValue = warppedValue
    }
    
}

struct UIStandard<Base> {
    
    let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
}

protocol UIStandardizable {
    
    associatedtype UIStandardBase
    
    static var standard: UIStandard<UIStandardBase>.Type { get set }
    
}

extension UIStandardizable {
    
    static var standard: UIStandard<Self>.Type {
        get { UIStandard<Self>.self }
        set { }
    }
    
}

