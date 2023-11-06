//
//  OJKLogoView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import Foundation

class OJKLogoView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage.dd.named("icon_login_ojk")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension OJKLogoView {
    
    func setupViews() {

        imageView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.auto)
            $0.left.right.equalToSuperview().inset(5.auto)
            $0.size.equalTo(CGSize(width: 72.auto, height: 38.4.auto))
            $0.bottom.equalToSuperview().inset(5.auto)
        }
        
    }
    
}
