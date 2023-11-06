//
//  UIAlertController+Extension.swift
//  ZJExtension
//
//  Created by Jercan on 2023/10/19.
//

import UIKit

public extension UIAlertController {
    
    @discardableResult
    func addAction(title: String,
                   style: UIAlertAction.Style = .default,
                   isEnabled: Bool = true,
                   handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
        
    }
    
}
