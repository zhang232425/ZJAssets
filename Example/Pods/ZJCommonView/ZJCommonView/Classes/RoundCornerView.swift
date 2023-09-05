//
//  File.swift
//  ZJCommonView
//
//  Created by Jercan on 2023/8/23.
//

import UIKit

public class RoundCornerView: UIView {
    
    private var borderLayer: CAShapeLayer?
    
    public struct BorderInfo {
        let width: CGFloat
        let color: UIColor
    }
    
    let radius: CGFloat
    
    public var border: BorderInfo? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var corners: UIRectCorner = .allCorners {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init(radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addRoundCornersBy(corners: corners, radius: radius)
        
        addBorder(border)
        
    }
    
    private func addRoundCornersBy(corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
        
    }
    
    private func addBorder(_ border: BorderInfo?) {
        
        borderLayer?.removeFromSuperlayer()
        
        guard let border = border else { return }
        
        let maskPathLine = UIBezierPath.init(roundedRect: bounds, cornerRadius: radius)
        borderLayer = CAShapeLayer.init()
        borderLayer?.frame = bounds
        borderLayer?.path = maskPathLine.cgPath
        borderLayer?.strokeColor = border.color.cgColor
        borderLayer?.lineWidth = border.width
        borderLayer?.fillColor = nil
        layer.addSublayer(borderLayer!)
       
   }
    
}
