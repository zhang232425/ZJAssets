//
//  BaseView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/8.
//

import UIKit
import ZJExtension

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
    
}

