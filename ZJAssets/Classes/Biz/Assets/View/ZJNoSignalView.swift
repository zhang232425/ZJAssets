//
//  ZJNoSignalView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/16.
//

import UIKit

class ZJNoSignalView: BaseView {
    
    private lazy var imageView = UIImageView(image: .named("no_signal"))
    
    private lazy var label = UILabel().then {
        $0.textColor = .init(hexString: "a8aab4")
        $0.font = .regular14
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = Locale.no_signal.localized
    }
    
    private lazy var button = UIButton(type: .system).then {
        $0.setTitleColor(.init(hexString: "ffa138"), for: .normal)
        $0.titleLabel?.font = .medium14
        $0.setTitle(Locale.refresh.localized, for: .normal)
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(hexString: "ffa138").cgColor
        $0.contentEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        $0.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }

    var refreshAction: (()-> ())?
    
    override func setupViews() {
                
        imageView.add(to: self).snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.7)
            $0.width.height.equalTo(255.auto)
        }
        
        label.add(to: self).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
                
        button.add(to: self).snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.left.greaterThanOrEqualToSuperview().inset(20)
            $0.right.lessThanOrEqualToSuperview().inset(20)
        }
        
    }
    
    @objc private func buttonClick() {
        refreshAction?()
    }

}

