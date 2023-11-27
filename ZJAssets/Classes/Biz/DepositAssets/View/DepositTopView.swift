//
//  DepositTopView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit

class DepositTopView: UIView {
    
    override class var layerClass: AnyClass { CAGradientLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 0, y: 1)
        gradientLayer.colors = [UIColor(hexString: "#FFF4EA"),
                                UIColor(hexString: "#FFF4EA", alpha: 0)].map { $0.cgColor }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
