//
//  AssetsBubbleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/15.
//

import UIKit

class AssetsBubbleView: BaseView {

    private lazy var contentView = AssetsBubbleContentView().then {
        $0.label.text = Locale.tradeIconTip.localized
        $0.closeHandler = { [weak self] in self?.removeFromSuperview() }
    }
    
    override func setupViews() {
    
        backgroundColor = .clear
        
        let arrowImage: UIImage?
        
        if let img = UIImage.named("icon_bubble_arrow"), let cgImg = img.cgImage {
            arrowImage = .init(cgImage: cgImg, scale: img.scale, orientation: .down)
        } else {
            arrowImage = nil
        }
        
        let arrowView = UIImageView(image: arrowImage)
        
        arrowView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().inset(10.auto)
            $0.width.equalTo(20.auto)
            $0.height.equalTo(7.auto)
        }
        
        contentView.add(to: self).snp.makeConstraints {
            $0.top.equalTo(arrowView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
    }
    
    func refreshText() {
        
        contentView.label.text = Locale.tradeIconTip.localized
        
    }

}

class AssetsBubbleContentView: BaseView {

    private(set) lazy var label = UILabel().then {
        $0.font = .medium12
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private lazy var closebutton = UIButton(type: .custom).then {
        $0.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
    }
    
    var closeHandler: (() -> ())?
    
    override func setupViews() {
        
        backgroundColor = UIColor(hexString: "#FAAD14")
        
        layer.cornerRadius = 8
        
        label.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(16.auto)
            $0.top.equalToSuperview().inset(12.auto)
            $0.bottom.equalToSuperview().inset(10.auto)
            $0.width.lessThanOrEqualTo(150.auto)
        }
        
        let iconImageView = UIImageView(image: .named("icon_close_white"))
        
        iconImageView.add(to: self).snp.makeConstraints {
            $0.width.height.equalTo(10.auto)
            $0.top.equalTo(label.snp.top).offset(-5.auto)
            $0.right.equalToSuperview().inset(14.auto)
            $0.left.equalTo(label.snp.right).offset(4.auto)
        }
        
        closebutton.add(to: self).snp.makeConstraints {
            $0.width.height.equalTo(20.auto)
            $0.center.equalTo(iconImageView)
        }
        
    }
    
}

private extension AssetsBubbleContentView {
    
    @objc func closeClick() {
        closeHandler?()
    }
    
}
