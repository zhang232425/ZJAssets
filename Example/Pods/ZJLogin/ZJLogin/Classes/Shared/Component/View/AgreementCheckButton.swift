//
//  AgreementCheckButton.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import UIKit

class AgreementCheckButton: UIButton {
    
    var onChangeState: ((Bool) -> Void)?
    
    private(set) var isChecked = false {
        didSet {
            switch isChecked {
            case true: setImage(UIImage.dd.named("gou_select"), for: .normal)
            case false: setImage(UIImage.dd.named("gou_normal"), for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        initialize()
    }
    
    private func initialize() {
        isChecked = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggle() {
        isChecked.toggle()
        onChangeState?(isChecked)
    }
    
}

