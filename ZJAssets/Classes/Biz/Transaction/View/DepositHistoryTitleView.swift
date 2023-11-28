//
//  DepositHistoryTitleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit

class DepositHistoryTitleView: BaseView {
    
    private lazy var periodView = TransactionTitleSelectView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(periodClick)))
    }
    
    private lazy var typeView = TransactionTitleSelectView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeClick)))
    }
    
    var periodClickHandler: (() -> ())?
    
    var typeClickHandler: (() -> ())?
    
    var periodTitle: String? {
        didSet {
            periodView.titleLabel.text = periodTitle
        }
    }
    
    var typeTitle: String? {
        didSet {
            typeView.titleLabel.text = typeTitle
        }
    }

    override func setupViews() {
        
        backgroundColor = .init(hexString: "#F3F3F3")
                
        periodView.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(16.auto)
            $0.centerY.equalToSuperview()
        }
        
        typeView.add(to: self).snp.makeConstraints {
            $0.left.equalTo(periodView.snp.right).offset(8.auto)
            $0.centerY.equalTo(periodView)
        }
        
        UIView().add(to: self).then {
            $0.backgroundColor = .init(hexString: "#EAEAEB")
        }.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1.auto)
        }
        
    }

}

private extension DepositHistoryTitleView {
    
    @objc func periodClick() {
        periodClickHandler?()
    }
    
    @objc func typeClick() {
        typeClickHandler?()
    }
    
}
