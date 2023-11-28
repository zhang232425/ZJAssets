//
//  TransactionTypeCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit

class TransactionTypeCell: BaseTableViewCell {

    private lazy var titleLabel = UILabel().then {
        $0.font = .regular16
        $0.textColor = .init(hexString: "#333333")
        
    }
    
    private lazy var checkImageView = UIImageView(image: .named("ico_check"))
    
    var item: TransactionTypeVM.SectionItem? {
        didSet {
            titleLabel.text = item?.name
            if let selected = item?.selected, selected {
                checkImageView.isHidden = false
            } else {
                checkImageView.isHidden = true
            }
        }
    }
    
    override func setupViews() {
        
        selectionStyle = .none
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(16.auto)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.add(to: contentView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8.auto)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16.auto)
            $0.width.height.equalTo(24.auto)
        }
        
        UIView().add(to: contentView).then {
            $0.backgroundColor = .init(hexString: "#E6E6E6")
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }

}
