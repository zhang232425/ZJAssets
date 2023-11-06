//
//  GestureIndicator.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/11.
//

import UIKit

class GestureIndicator: UIView {

    var gesture: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let itemViewWH: CGFloat = 8
        let margin: CGFloat = (frame.width - 3 * itemViewWH) / 3.0
        
        for i in 0 ..< 9 {
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let x = margin * row + row * itemViewWH + margin / 2.0
            let y = margin * col + col * itemViewWH + margin / 2.0
            
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            var color = UIColor(hexString: "#EFEFF4")
            
            if gesture.count > 0, gesture.contains("\(i + 1)") {
                color = UIColor(hexString: "#2A4CB9")
            }
            
            ctx.setFillColor(color.cgColor)
            ctx.fillEllipse(in: frame)
            
        }
        
    }
    
}
