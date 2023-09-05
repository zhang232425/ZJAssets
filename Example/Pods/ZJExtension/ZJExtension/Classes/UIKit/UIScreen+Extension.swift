//
//  UIScreen+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/28.
//

import Foundation

public extension UIScreen {
    
    /// 屏幕宽度
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 屏幕高度
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// 导航栏高度
    static var navBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.height
    }
    
    /// Tabbar高度
    static var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.height
    }
    
    /// 顶部安全距离高度
    static var safeAreaTop: CGFloat {
        guard #available(iOS 11.0, *), let height = UIApplication.shared.keyWindow?.safeAreaInsets.top else {
            return 0
        }
        return height
    }
    
    /// 底部栏高度
    static var safeAreaBottom: CGFloat {
        guard #available(iOS 11.0, *), let height = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
            return 0
        }
        return height
    }
    
}
