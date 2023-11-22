//
//  DepositEmptyCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit

class DepositEmptyCell: DepositBaseCell {
    
    var clickHandler: (() -> ())?
    
    private lazy var emptyImageView = UIImageView(image: .named("deposit_empty"))
    
    private lazy var label = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.noData.localized
    }
    
    private lazy var button = RoundCornerButton(type: .system).then {
        $0.titleLabel?.font = .bold16
        $0.setTitleColor(.init(hexString: "#FF7D0F"), for: .normal)
        $0.layer.borderColor = UIColor(hexString: "#FF7D0F").cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.contentEdgeInsets = .init(top: 8, left: 24, bottom: 8, right: 24)
        $0.setTitle(Locale.goToProduct.localized, for: .normal)
        $0.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }

    override func setupViews() {
        
        let containerView = UIView()
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.left.top.greaterThanOrEqualToSuperview()
            $0.right.bottom.lessThanOrEqualToSuperview()
            $0.center.equalToSuperview()
        }
        
        emptyImageView.add(to: containerView).snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }
        
        label.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16.auto)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }
        
        button.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(16.auto)
            $0.centerX.bottom.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }
        
    }
    
}

private extension DepositEmptyCell {
    
    @objc func buttonClick() {
        clickHandler?()
    }
    
}
