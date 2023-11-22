//
//  DepositSeparatorCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import SnapKit

class DepositSeparatorCell: DepositHeaderCell {
    
    private var heightConstraint: Constraint?
    
    var height: CGFloat = 0 {
        didSet {
            heightConstraint?.update(inset: height * 0.5)
        }
    }

    override func setupViews() {
        
        UIView().add(to: contentView).snp.makeConstraints {
            $0.left.right.equalToSuperview()
            heightConstraint = $0.top.bottom.equalToSuperview().inset(8).priority(.high).constraint
        }
        
    }

}
