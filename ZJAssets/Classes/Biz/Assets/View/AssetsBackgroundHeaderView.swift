//
//  AssetsBackgroundHeaderView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/10.
//

import UIKit

class AssetsBackgroundHeaderView: UIView {
    
    private lazy var imageView = UIImageView()
    
    private var currentView: UIView?
    
    private lazy var gradientView = GradientView().then {
        $0.colors = [UIColor(hexString: "#88BBB9"), UIColor(hexString: "#FFFFFF")]
    }
    
    var colors: [UIColor]? = nil {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            imageView.frame = bounds
            gradientView.frame = bounds
            currentView = gradientView
            gradientView.add(to: self)
            gradientView.colors = colors
        }
    }
    
    var image: UIImage? {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            imageView.frame = bounds
            currentView = imageView
            imageView.add(to: self)
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currentView?.frame = bounds
    }
    
    func adjustPositionBy(offsetY: CGFloat) {
        
        if offsetY >= 0 {
            currentView?.frame = bounds
        } else {
            currentView?.frame = .init(x: 0, y: offsetY, width: bounds.width, height: bounds.height)
        }
        
    }
    
}

private class GradientView: UIView {
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    var colors: [UIColor]? = nil {
        didSet {
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = colors?.map { $0.cgColor }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
    }
    
}
