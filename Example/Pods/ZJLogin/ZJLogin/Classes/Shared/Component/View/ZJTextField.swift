//
//  ZJTextField.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/14.
//

import UIKit

class ZJTextField: UITextField {
    
    private lazy var clearBtn = UIButton(type: .custom).then {
        $0.setImage(UIImage.dd.named("text_clear_btn"), for: .normal)
        $0.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ZJTextField {
    
    func setupViews() {
        
        let view = UIView(frame: .init(x: 0, y: 0, width: 36.auto, height: 36.auto))
        clearBtn.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(view.bounds.size)
        }
        rightView = view
        rightViewMode = .whileEditing
        
        tintColor = UIColor.orange

    }
    
    @objc func clearClick() {
        text = nil
    }
    
}
