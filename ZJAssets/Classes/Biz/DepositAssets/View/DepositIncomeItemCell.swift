//
//  DepositIncomeItemCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit
import ZJExtension

class DepositIncomeItemCell: DepositBaseCell {

    fileprivate lazy var titleLabel = UILabel().then {
        $0.font = .regular12
        $0.numberOfLines = 0
        $0.textColor = .init(hexString: "#333333")
    }
    
    fileprivate lazy var amountLabel = UILabel().then {
        $0.font = .medium12
        $0.textColor = .init(hexString: "#1CB395")
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    var item: DepositIncome? {
        didSet { updateText() }
    }
    
    func updateText() {
        titleLabel.text = item?.name
        amountLabel.text = item?.amount.amountValue
        amountLabel.textColor = item?.amount.earningColor
    }

    override func setupViews() {
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.auto)
            $0.left.bottom.equalToSuperview().inset(16.auto)
        }
        
        amountLabel.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.auto)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10.auto)
        }
        
        UIView().add(to: contentView).then {
            $0.backgroundColor = .init(hexString: "#E6E6E6")
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.auto)
        }
        
    }

}

class DepositIncomeItemStatusCell: DepositIncomeItemCell {
    
    private lazy var statusLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    override func updateText() {
        super.updateText()
        statusLabel.text = item?.statusDesc
    }

    override func setupViews() {
        
        super.setupViews()
        
        let statusBg = UIView()
        
        statusBg.add(to: contentView).then {
            $0.backgroundColor = .init(hexString: "#F3F3F3")
            $0.layer.cornerRadius = 2.auto
        }.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(4.auto)
        }
        
        statusLabel.add(to: statusBg).snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(6.auto)
        }
        
        amountLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.auto)
            $0.left.greaterThanOrEqualTo(statusBg.snp.right).offset(10.auto)
        }
        
    }

}
