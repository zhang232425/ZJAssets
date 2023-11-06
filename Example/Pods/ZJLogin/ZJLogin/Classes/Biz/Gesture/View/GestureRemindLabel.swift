//
//  GestureRemindLabel.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/11.
//

import UIKit

class GestureRemindLabel: UILabel {

    /// 展示普通信息
    func showNormalMsg(_ msg: String) {
        textColor = UIColor(hexString: "#A8AAB4")
        text = msg
    }
    
    /// 展示警示信息
    func showWarnMsg(_ msg: String) {
        textColor = UIColor(hexString: "#FD6161")
        text = msg
    }
    
    /// 展示警示信息（shake）
    func showWarnMsgAndShake(_ msg: String) {
        showWarnMsg(msg)
        shake()
    }

}

private extension GestureRemindLabel {
    
    func shake() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        let s: CGFloat = 5
        
        animation.values = [-s, 0, s, 0, -s, 0, s, 0]
        
        /// 时长
        animation.duration = 0.3
        /// 重复
        animation.repeatCount = 2
        /// 移除
        animation.isRemovedOnCompletion = true
        
        layer.add(animation, forKey: "shake")
        
    }
    
}

