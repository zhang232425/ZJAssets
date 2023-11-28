//
//  TransactionFilterItemCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit

class TransactionFilterItemCell: UICollectionViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .regular14
        $0.textColor = .init(hexString: "#333333")
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
    }
    
    var item: TransactionFilterVM.SectionItem? {
        
        didSet {
            
            titleLabel.text = item?.name
            
            if let enabled = item?.enabled, enabled {
                
                if let selected = item?.selected, selected {
                    titleLabel.textColor = .init(hexString: "#FF7D0F")
                    titleLabel.font = .medium14
                    containerView.layer.borderColor = UIColor(hexString: "#FF7D0F").cgColor
                } else {
                    titleLabel.textColor = .init(hexString: "#333333")
                    titleLabel.font = .regular14
                    containerView.layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
                }
                
            } else {
                titleLabel.textColor = .init(hexString: "#D3D3D3")
                titleLabel.font = .regular14
                containerView.layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TransactionFilterItemCell {
    
    func initialize() {
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().inset(5.auto)
            $0.right.lessThanOrEqualToSuperview().inset(5.auto)
            $0.center.equalToSuperview()
        }
        
    }
    
}

