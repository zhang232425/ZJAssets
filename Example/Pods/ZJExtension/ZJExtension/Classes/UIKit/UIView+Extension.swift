//
//  UIView+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

public protocol AddTo {
    func add(to superView: UIView) -> Self
}

public extension AddTo where Self: UIView {
    func add(to superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
}

extension UIView: AddTo {}
