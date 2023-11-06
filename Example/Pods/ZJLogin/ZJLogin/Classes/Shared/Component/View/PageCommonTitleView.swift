//
//  PageCommonTitleView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import UIKit

class PageCommonTitleView: BaseView {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .bold24
        $0.textColor = UIColor(hexString: "#333333")
        $0.numberOfLines = 0
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.font = .regular16
        $0.textColor = UIColor(hexString: "#666666")
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    init(title: String, subTitle: NSAttributedString) {
        super.init(frame: .zero)
        setupViews()
        titleLabel.text = title
        subtitleLabel.attributedText = subTitle
    }
    
    init(title: String, plainSubTitle: String) {
        super.init(frame: .zero)
        setupViews()
        titleLabel.text = title
        subtitleLabel.text = plainSubTitle
    }
    
    required public init?(coder: NSCoder) { fatalError() }
    
    
}

private extension PageCommonTitleView {
    
    func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        subtitleLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
}

extension PageCommonTitleView {
    
    func setSubTitle(_ subTitle: NSAttributedString) {
        subtitleLabel.attributedText = subTitle
    }
    
}
