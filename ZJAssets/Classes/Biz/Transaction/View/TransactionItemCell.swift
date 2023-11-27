//
//  TransactionItemCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import UIKit
import RxSwift

class TransactionItemCell: BaseTableViewCell {
    
    private lazy var bag = DisposeBag()
    
    private lazy var typeBg = UIView().then {
        $0.layer.cornerRadius = 2
    }
    
    private lazy var typeLabel = UILabel().then {
        $0.font = .regular12
    }
    
    private lazy var statusLabel = UILabel().then {
        $0.font = .regular12
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#333333")
        $0.numberOfLines = 0
    }
    
    private lazy var amountLabel = UILabel().then {
        $0.font = .medium14
        $0.textColor = .init(hexString: "#333333")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
    }
    
    private lazy var countDownView = CountDownView()
    
    var viewModel: TransactionListCellVM? {
        
        didSet {
            
            bag = DisposeBag()
            
            typeBg.backgroundColor = viewModel?.item.type.backgroundColor
            typeLabel.textColor = viewModel?.item.type.textColor
            typeLabel.text = viewModel?.item.typeDesc
            
            statusLabel.text = viewModel?.item.statusDesc
            statusLabel.textColor = viewModel?.item.status.textColor
            
            nameLabel.text = viewModel?.item.productName
            
            amountLabel.text = viewModel?.item.amount
            
            dateLabel.text = viewModel?.item.createTime
            
            if let show = viewModel?.needCountDown, show {
                
                countDownView.label.text = viewModel?.remainTimeFormat
                
                viewModel?.countDown.observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] in
                        self?.countDownView.label.text = self?.viewModel?.remainTimeFormat
                    }).disposed(by: bag)
                
                countDownView.isHidden = false
                
            } else {
                countDownView.isHidden = true
            }
            
        }
        
    }

    override func setupViews() {
        
        selectionStyle = .none
        
        typeBg.add(to: contentView).snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        typeLabel.add(to: typeBg).snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(1)
            $0.left.right.equalToSuperview().inset(6)
        }
        
        statusLabel.add(to: contentView).snp.makeConstraints {
            $0.right.top.equalToSuperview().inset(16)
        }
        
        nameLabel.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(typeBg.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(16)
        }
        
        amountLabel.add(to: contentView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(16)
            $0.top.equalTo(nameLabel)
            $0.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.6)
        }
        
        dateLabel.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.bottom.equalToSuperview().inset(16)
        }
        
        countDownView.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.right.equalToSuperview().inset(16)
        }
        
        UIView().add(to: contentView).then {
            $0.backgroundColor = .init(hexString: "#E6E6E6")
        }.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    
    }

}
