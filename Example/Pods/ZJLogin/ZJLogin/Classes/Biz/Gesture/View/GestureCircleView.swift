//
//  GestureCircleView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/11.
//

import UIKit

class GestureCircleView: UIView {
    
    /// 状态枚举
    enum CircleState {
        case normal
        case selected
        case error
    }
    
    /// 状态
    var state: CircleState = .normal {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 外环颜色
    var outCircleColor: UIColor {
        switch state {
        case .normal:
            return UIColor.white
        case .selected:
            return UIColor(hexString: "#EFEFE4")
        case .error:
            return UIColor(hexString: "#FFF2F2")
        }
    }

    /// 实心圆颜色
    var inCircleColor: UIColor {
        switch state {
        case .normal:
            return UIColor(hexString: "#EFEFE4")
        case .selected:
            return UIColor(hexString: "#2A4CB9")
        case .error:
            return UIColor(hexString: "FFF2F2")
        }
    }
    
    /// 单个圆的圆心
    let circleCenter = CGPoint(x: 20, y: 20)

    /// 内部实心圆站空心圆的比例系数
    let radio: CGFloat = 0.5
    
    /// 空心圆圆环宽度
    let circleEdgeWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let circleRect = CGRect(x: circleEdgeWidth, y: circleEdgeWidth, width: rect.width - 2, height: rect.height - 2)
        
        /// 上下文旋转
        transFormCtx(ctx: ctx, rect: circleRect)
        /// 画圆环
        drawEmptyCircle(ctx: ctx, rect: circleRect, color: outCircleColor)
        /// 画实心圆
        drawSolidCircle(ctx: ctx, rect: circleRect, radio: radio, color: inCircleColor)
        
    }
    
}

private extension GestureCircleView {
    
    
    /// 画圆环
    /// - Parameters:
    ///   - ctx:   图形上下文
    ///   - rect:  绘画范围
    ///   - color: 绘制颜色
    func drawEmptyCircle(ctx: CGContext, rect: CGRect, color: UIColor) {
        
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
    }
    
    
    /// 画实心圆
    /// - Parameters:
    ///   - ctx:   图形上下文
    ///   - rect:  绘制返回
    ///   - radio: 占大圆比例
    ///   - color: 绘制颜色
    func drawSolidCircle(ctx: CGContext, rect: CGRect, radio: CGFloat, color: UIColor) {
        
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: CGRect(x: rect.width / 2 * (1 - radio) + circleEdgeWidth,
                                   y: rect.height / 2 * (1 - radio) + circleEdgeWidth,
                                   width: rect.width * radio - circleEdgeWidth * 2,
                                   height: rect.height * radio - circleEdgeWidth * 2))
    }
    
    /// 上下文旋转
    /// - Parameters:
    ///   - ctx:  图形上下文
    ///   - rect: 绘画范围
    func transFormCtx(ctx: CGContext, rect: CGRect) {
        
        let translateXY: CGFloat = rect.width * 0.5
        /// 平移
        ctx.translateBy(x: translateXY, y: translateXY)
        /// 平移回来
        ctx.translateBy(x: -translateXY, y: -translateXY)
        
    }

}

