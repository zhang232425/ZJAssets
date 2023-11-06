//
//  UIApplication+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/28.
//

import Foundation

public extension UIApplication {
    
    // MARK: - Method
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.open(url: url)
            }
        }
    }
    
    func switchRootViewController(to viewController: UIViewController?, animated: Bool) {
        
        guard let window = delegate?.window as? UIWindow else { return }
        
        guard animated else {
            window.rootViewController = viewController
            return
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        })
        
    }
    
    // MARK: - Property
    var navigationController: UINavigationController? {
        
        guard let rootViewController = appRootViewController else {
            return nil
        }
        
        var navigationController: UINavigationController?
        
        if let vc = rootViewController as? UINavigationController {
            navigationController = vc
        }
        
        if let tabBarController = rootViewController as? UITabBarController,
            let vc = tabBarController.selectedViewController as? UINavigationController {
            navigationController = vc
        }
        
        guard var topViewController: UIViewController = navigationController else {
            return nil
        }
        
        while topViewController.presentedViewController != nil {
            topViewController = topViewController.presentedViewController!
        }
        
        return topViewController as? UINavigationController
        
    }
    
    var topViewController: UIViewController? {
        
        if let rootViewController = appRootViewController {
            return topController(of: rootViewController)
        }
        
        return nil
        
    }
    
}

private extension UIApplication {
    
    var appRootViewController: UIViewController? {
        return (UIApplication.shared.delegate?.window as? UIWindow)?.rootViewController
    }
    
    func topController(of viewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = viewController.presentedViewController {
            return topController(of: presentedViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topController(of: selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topController(of: visibleViewController)
        }
        
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1,
            let vc = pageViewController.viewControllers?.first {
            return topController(of: vc)
        }
        
        if let subviews = viewController.view?.subviews {
            
            for subview in subviews {
                if let childViewController = subview.next as? UIViewController {
                    return topController(of: childViewController)
                }
            }
            
        }
        
        return viewController
        
    }
    
}



