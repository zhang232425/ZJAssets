//
//  GestureLockView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/11.
//

import UIKit

public protocol GestureLockViewDelegate: class {
    
    /// 开始触摸
    func gestureLockViewTouchBeigin()
    
    /// 触摸中
    func gestureLockViewDidSelect(gestureLockView: GestureLockView, gesture: String, completion: ((Bool) -> Void)?)
    
}

public class GestureLockView: UIView {
    
    // 代理
    public weak var delegate: GestureLockViewDelegate?
    
    /// 半径
    let radius: CGFloat = 20
    
    /// 连线颜色
    let lineColor = UIColor(hexString: "#2A4CB9")
    
    /// 连线错误颜色
    let lineErrorColor = UIColor(hexString: "#FD6161")
    
    /// 线宽
    let lineWidth: CGFloat = 2
    
    /// 选中圆的集合
    var circleSet: [GestureCircleView] = []
    
    /// 当前点位置
    var currentPoint = CGPoint.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lockViewPrepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemViewWH = radius * 2
        let margin = (frame.width - 3 * itemViewWH) / 3.0
        
        subviews.enumerated().forEach { (index, element) in
            let row = CGFloat(index / 3)
            let col = CGFloat(index % 3)
            let x = margin * row + row * itemViewWH + margin / 2
            let y = margin * col + col * itemViewWH + margin / 2
            
            /// tag就是密码数字
            element.tag = index + 1
            element.frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
        }
        
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /// 没有选中任何按钮，直接return
        guard circleSet.count > 0, let circle = circleSet.first else { return }
        
        let color = circle.state == .error ? lineErrorColor : lineColor
        
        connectCircles(rect: rect, lineColor: color)
        
    }
    
}

private extension GestureLockView {
    
    func lockViewPrepare() {
        
        backgroundColor = UIColor.white
        
        for _ in 0 ..< 9 {
            addSubview(GestureCircleView())
        }
        
    }

    func connectCircles(rect: CGRect, lineColor: UIColor) {
        
        /// 获取上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        /// 添加路径
        ctx.addRect(rect)
        
        /// 裁剪
        subviews.forEach {
            ctx.addEllipse(in: $0.frame)
        }
        
        /// 裁剪上下文
        ctx.clip()
        
        /// 起点按钮连线
        circleSet.enumerated().forEach { index, element in
            index == 0 ? ctx.move(to: element.center) : ctx.addLine(to: element.center)
        }
        
        /// 连接最后一个按钮到手指当前的触摸点
        if currentPoint != .zero {
            ctx.addLine(to: currentPoint)
        }
        
        /// 线条转角样式
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineJoin(CGLineJoin.round)
        
        /// 设置绘图属性
        ctx.setLineWidth(lineWidth)
        
        /// 线条颜色
        lineColor.set()
        
        /// 渲染路径
        ctx.strokePath()
        
        
    }
    
}

// MARK: - 对外接口
public extension GestureLockView {
    
    func resetGesture() {
        
        circleSet.forEach {
            $0.state = .normal
        }
        
        circleSet.removeAll()
        
        setNeedsDisplay()
        
    }
    
}


// MARK: - 触摸事件
extension GestureLockView {
    
    /// 开始触摸
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        resetGesture()
        
        guard let touch = touches.first else { return }
        
        currentPoint = touch.location(in: self)
        
        selectCircleAtPoint(currentPoint)
        
        setNeedsDisplay()
        
        delegate?.gestureLockViewTouchBeigin()
        
    }
    
    /// 触摸移动中
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        currentPoint = touch.location(in: self)
        
        selectCircleAtPoint(currentPoint)
        
        setNeedsDisplay()
        
    }
    
    /// 触摸结束
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        currentPoint = .zero
        
        let gesture = getGestureResultFromCircleSet(circleSet: circleSet)
        
        guard gesture.count > 0 else { return }
        
        setNeedsDisplay()

        delegate?.gestureLockViewDidSelect(gestureLockView: self, gesture: gesture, completion: { [weak self] result in
            
            guard let weakSelf = self else { return }
            
            weakSelf.circleSet.forEach {
                $0.state = result ? .selected : .error
            }
            
            weakSelf.setNeedsDisplay()
            
            if !result {
                
                DispatchQueue.main.async {
                    weakSelf.resetGesture()
                }
                
            }
            
        })
        
    }

}

private extension GestureLockView {
    
    /// 选中当前触摸点所在的圆
    func selectCircleAtPoint(_ point: CGPoint) {
        
        subviews.forEach { circle in
            if let circle = circle as? GestureCircleView, circle.frame.contains(point), !(circleSet.contains(circle)) {
                circle.state = .selected
                circleSet.append(circle)
                
                // move过程中的连线（包含跳跃连线的处理）
                calAngleAndconnectTheJumpedCircle()
            }
        }
        
    }
    
    /// 跳跃连线的处理
    func calAngleAndconnectTheJumpedCircle() {
        
        guard circleSet.count > 1, let lastOne = circleSet.last else { return }
        
        let lastTwo = circleSet[circleSet.count - 2]
        
        /// 处理跳跃连线
        let center = getCenterPoint(lhs: lastOne.center, rhs: lastTwo.center)
        
        guard let centerCircle = circleViewOfSubviewWithContainPoint(center) else { return }
        
        centerCircle.state = .selected
        
        /// 把跳过的圆加到数组中，位置是倒数第二个
        if !(circleSet.contains(centerCircle)) {
            circleSet.insert(centerCircle, at: circleSet.count - 1)
        }
        
    }

    /// 获取两个点的中点
    func getCenterPoint(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        
        return CGPoint(x: (lhs.x + rhs.x) / 2.0, y: (lhs.y + rhs.y) / 2.0)
        
    }

    /// 判断点是否被圆包含，如果包含就返回当前圆，如果不包含就返回nil
    func circleViewOfSubviewWithContainPoint(_ point: CGPoint) -> GestureCircleView? {
        
        var centerCircle: GestureCircleView?
        
        subviews.filter { $0.frame.contains(point) }.forEach {
            centerCircle = $0 as? GestureCircleView
        }
        
        return centerCircle
        
    }
    
    func getGestureResultFromCircleSet(circleSet: [GestureCircleView]) -> String {
        
        var gesture = ""
        
        circleSet.forEach {
            gesture += "\($0.tag)"
        }
        
        return gesture
        
    }

    
}
