//
//  UIBarButtonItem+Extension.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import Foundation

extension UIBarButtonItem {
    
    static func custom(title: String, action: @escaping () -> ()) -> UIBarButtonItem {
        let font = UIFont.regular14
        let color = UIColor.standard.orange
        let attr: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(_onClick))
        item.setTitleTextAttributes(attr, for: .normal)
        item.setTitleTextAttributes(attr, for: .highlighted)
        item.customAction = .init(action)
        return item
    }
    
    static func custom(image: UIImage?, action: @escaping ()-> () = {}) -> UIBarButtonItem {
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(_onClick))
        item.tintColor = UIColor.standard.black33
        item.customAction = .init(action)
        return item
    }
    
}

private extension UIBarButtonItem {
        
    @objc static func _onClick(_ bbi: UIBarButtonItem) {
        if let obj = bbi.customAction {
            obj.action()
        }
    }
    
    var customAction: BlockWrapper? {
        get { objc_getAssociatedObject(self, &_context) as? BlockWrapper }
        set { objc_setAssociatedObject(self, &_context, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    class BlockWrapper {
        
        let action: () -> ()
        
        init(_ action: @escaping () -> ()) {
            self.action = action
        }
        
    }
    
}

fileprivate var _context: UInt8 = 0

