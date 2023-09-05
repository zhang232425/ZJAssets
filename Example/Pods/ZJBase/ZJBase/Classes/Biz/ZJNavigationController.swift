//
//  ZJNavigationController.swift
//  Pods-ZJBase_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit
import ZJExtension
import RTRootNavigationController

open class ZJNavigationController: RTRootNavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        navigationBar.shadowImage = UIImage(color: .init(hexString: "#EDEDED"), size: .init(width: 1, height: 0.5))
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.medium16]
        navigationBar.tintColor = .color(red: 62, green: 74, blue: 90)
        navigationBar.barTintColor = .white
        modalPresentationStyle = .fullScreen
        transferNavigationBarAttributes = true
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
