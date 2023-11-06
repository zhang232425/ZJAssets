//
//  ZJViewController.swift
//  Pods-ZJBase_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit
import ZJExtension

open class ZJViewController: UIViewController {
    
    override open var preferredStatusBarStyle: UIStatusBarStyle { .default }
    
    public var isPopGestureEnabled = true {
        didSet { rt_disableInteractivePop = !isPopGestureEnabled }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .fullScreen
    }
    
    public static func defaultBackImage() -> UIImage? {
        UIImage(name: "back", bundle: .framework_ZJBase)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        rt_disableInteractivePop = false
    }
    
    public func changeNavigationBarBackgroundWith(color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: color), for: .default)
    }
    
    deinit { debugPrint("\(String(describing: self))deinit") }
    
}

extension ZJViewController {
    
    open override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        UIBarButtonItem(image: UIImage(name: "back", bundle: .framework_ZJBase),
                        style: .plain,
                        target: target,
                        action: action)
    }
    
}

