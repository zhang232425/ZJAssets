//
//  RoundCornerButton.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit

class RoundCornerButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
}
