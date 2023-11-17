//
//  AssetsProgressView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/16.
//

import UIKit

class AssetsProgressView: BaseView {

    private lazy var titleLabel = UILabel().then {
        $0.textColor = .init(hexString: "#333333")
        $0.font = .bold20
    }
    
    private lazy var imageView = UIImageView(image: .named("skeleton"))
    
    var title: String? { didSet { titleLabel.text = title } }

    override func setupViews() {
        
        imageView.add(to: self).snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(safeAreaLayoutGuide).offset(12)
                $0.left.right.equalTo(safeAreaLayoutGuide).inset(16)
            } else {
                $0.top.equalToSuperview().offset(32)
                $0.left.right.equalToSuperview().inset(16)
            }
            $0.height.equalTo(imageView.snp.width).multipliedBy(2.03)
        }
        
        titleLabel.add(to: self).snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            } else {
                $0.top.equalToSuperview().offset(35)
            }
            $0.centerX.equalToSuperview()
        }
        
    }

}
