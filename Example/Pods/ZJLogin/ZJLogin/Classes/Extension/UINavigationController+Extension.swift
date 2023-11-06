//
//  UINavigationController+Extension.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/17.
//

import Foundation

extension UINavigationController: NamespaceWrappable {}

extension NamespaceWrapper where T: UINavigationController {
    
    /// 返回前X页
    func popToViewControllerAtLastIndex(lastIndex: Int) {
        
        guard lastIndex < warppedValue.viewControllers.count else { return }
        
        let index = warppedValue.viewControllers.count - lastIndex - 1
        
        let vc = warppedValue.viewControllers[index]
        
        warppedValue.popToViewController(vc, animated: true)
        
    }
    
    /// 移除前X页
    func removeViewControllerToLastIndex(lastIndex: Int) {
        
        guard lastIndex < warppedValue.viewControllers.count - 1 else { return }
        
        var vcs = warppedValue.viewControllers
        
        (0 ... lastIndex - 1).forEach { _ in
            vcs.remove(at: vcs.count - 2)
        }
        
        warppedValue.viewControllers = vcs
        
    }
    
}
