//
//  DepositIncomeHeaderCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit
import ZJExtension

class DepositIncomeHeaderCell: DepositBaseCell {

    private lazy var totalLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.totalEarning.localized
    }
    
    private lazy var amountLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = .medium14
        $0.textColor = .init(hexString: "#333333")
    }
    
    var item: DepositAssets? {
        didSet {
            amountLabel.text = item?.totalIncome.assetsValue
        }
    }
    
    override func setupViews() {
        
        let containerView = UIView()
        
        containerView.add(to: contentView).then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.shadowColor = UIColor(hexString: "#000000", alpha: 0.06).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = .init(width: 0, height: 1)
            $0.layer.shadowRadius = 8
        }.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
            
        totalLabel.add(to: containerView).snp.makeConstraints {
            $0.top.right.left.equalToSuperview().inset(12)
        }
        
        amountLabel.add(to: containerView).snp.makeConstraints {
            $0.left.right.equalTo(totalLabel)
            $0.top.equalTo(totalLabel.snp.bottom).offset(2)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        
    }

}
