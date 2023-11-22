//
//  DepositRateView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit

class DepositRateView: BaseView {

    private lazy var label = UILabel().then {
        $0.font = .medium11
        $0.textColor = .init(hexString: "#FF7D0F")
    }
    
    var text: String? { didSet { label.text = text } }
    
    override func setupViews() {
        
        label.add(to: self).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(1)
            $0.left.right.equalToSuperview().inset(4)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addRoundCornersBy(rect: bounds)
    }

    private func addRoundCornersBy(rect: CGRect) {
        
        let corners: UIRectCorner = [.topLeft, .topRight, .bottomRight]
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: 7, height: 7))
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = bounds
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor(hexString: "#FF7D0F").cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
        
        layer.addSublayer(borderLayer)
        
    }

}
