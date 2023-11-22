//
//  DepositItemCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import RxSwift

fileprivate class OverdueSignView: BaseView {
    
    var btnBlock: (() -> ())?
    
    lazy var signLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "#FF7D0F")
        $0.font = .regular12
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    private lazy var signImgView = UIImageView().then {
        $0.image = .named("overdue_sign_icon")
    }
    
    private lazy var btn = UIButton(type: .custom).then {
        $0.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    override func setupViews() {
        
        signImgView.add(to: self).snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.size.equalTo(14.auto)
        }
        
        signLabel.add(to: self).snp.makeConstraints {
            $0.right.equalTo(signImgView.snp.left).offset(-3.auto)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        btn.add(to: self).snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
    }
    
    @objc func btnClick() {
        btnBlock?()
    }
    
}

class DepositItemCell: DepositBaseCell {
    
    var overdueBlock: ((String?, String?) -> ())?
    
    private var bag = DisposeBag()
    
    fileprivate lazy var orderNumLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "#999999")
        $0.font = .regular12
    }
    
    fileprivate lazy var nameLabel = UILabel().then {
        $0.font = .medium16
        $0.textColor = .init(hexString: "#333333")
        $0.numberOfLines = 2
    }
    
    fileprivate lazy var statusLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#FF7D0F")
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    private lazy var overdueStatusView = OverdueSignView().then {
        $0.isHidden = false
        $0.btnBlock = { [weak self] in
            self?.overdueBlock?(self?.item?.order.statusDesc, self?.item?.order.overdueExplain)
        }
    }
    
    fileprivate lazy var totalLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.totalAmountCell.localized
    }
    
    fileprivate lazy var dateTextLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.dueDate.localized
    }
    
    fileprivate lazy var amountLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#666666")
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    
    fileprivate lazy var dateLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#666666")
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
        
    fileprivate lazy var containerView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
    }
    
    private lazy var redPointView = UIView().then {
        $0.backgroundColor = .init(hexString: "FF3737")
        $0.layer.cornerRadius = 3
    }
    
    var item: DepositListItem? {
        didSet {
            bag = DisposeBag()
            guard let item = item else { return }
            redPointView.isHidden = item.order.isRead
            item.isSecureText.subscribeNext(weak: self, DepositItemCell.updateText).disposed(by: bag)
            if item.order.status == .overdue {
                overdueStatusView.isHidden = false
                overdueStatusView.signLabel.text = item.order.statusDesc
                statusLabel.isHidden = true
            } else {
                overdueStatusView.isHidden = true
                overdueStatusView.signLabel.text = nil
                statusLabel.isHidden = false
            }
        }
    }
    
    func updateText(_ isSecure: Bool) {
        if isSecure {
            amountLabel.text = item?.secureText
        } else {
            amountLabel.text = item?.order.remainAmount.amountValue
        }
        
        orderNumLabel.text = Locale.transaction.localized + "\(item?.order.orderId ?? "")"
        nameLabel.text = item?.order.name
        dateLabel.text = item?.order.endTime
        statusLabel.text = item?.order.statusDesc
        
    }

    override func setupViews() {
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.auto)
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview().inset(6.auto)
        }
        
        orderNumLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.auto)
            $0.left.right.equalToSuperview().inset(12.auto)
        }
        
        nameLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(orderNumLabel.snp.bottom).offset(2.auto)
            $0.left.equalToSuperview().inset(12.auto)
        }
        
        redPointView.add(to: containerView).snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right)
            $0.top.equalTo(nameLabel)
            $0.width.height.equalTo(6.auto)
        }
        
        statusLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(10.auto)
            $0.right.equalToSuperview().inset(12.auto)
            $0.centerY.equalTo(nameLabel)
        }
        
        overdueStatusView.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(10.auto)
            $0.right.equalToSuperview().inset(12.auto)
            $0.centerY.equalTo(nameLabel)
        }
            
        totalLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17.auto)
            $0.left.equalTo(nameLabel)
        }
        
        amountLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(totalLabel.snp.right).offset(10.auto)
            $0.right.equalTo(statusLabel)
            $0.centerY.equalTo(totalLabel)
        }
                
        dateTextLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(12.auto)
            $0.left.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(16.auto)
        }
        
        dateLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(dateTextLabel.snp.right).offset(10.auto)
            $0.right.equalTo(statusLabel)
            $0.centerY.equalTo(dateTextLabel)
        }
        
    }
    
}

class DepositItemRenewCell: DepositItemCell {
    
    private lazy var renewDescLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#666666")
    }
    
    private lazy var rateLabel = DepositRateView()
    
    private lazy var renewButton = RoundCornerButton(type: .system).then {
        $0.titleLabel?.font = .bold14
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .init(hexString: "#FF7D0F")
        $0.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
    }
    
    private lazy var line = UIView().then {
        $0.backgroundColor = .init(hexString: "#E6E6E6")
    }
    
    private var bottomViewHiddle: Bool = false
    
    var turnOnHandler: ((DepositListItem) -> ())?
    
    var renewHandler: ((DepositListItem) -> ())?
    
    @objc private func handleButtonClick() {
        
        if let item = item {
            
            if item.order.autoBtn {
                
                if item.order.autoContinue {
                                    
                    if item.isExpired || item.isFailed {
                        renewHandler?(item)
                    }
                    
                } else {
                    turnOnHandler?(item)
                }
                
            } else {
                renewHandler?(item)
            }
            
        }
        
    }
    
    override func updateText(_ isSecure: Bool) {
        super.updateText(isSecure)
        
        rateLabel.text = item?.order.renewRate.rateValue
        
        if let item = item {
            
            renewButton.isHidden = true
            bottomViewHiddle = false
            
            // 自动续投按钮显示是否开启
            if item.order.autoBtn {
                
                // 是否开启自动续投（0-未开启，1-已开启 ）
                if item.order.autoContinue {
                    
                    if item.isExpired || item.isFailed {

                        // 应产品需求，隐藏去掉 go 且下部分视图隐藏掉
                        bottomViewHiddle = true
                        
                    } else if item.isWaitRenew {
                        renewDescLabel.text = item.matureDaysTip
                    }
                    
                } else {
                    //开启续投按钮
                    renewDescLabel.text = Locale.autoFund.localized
                    renewButton.setTitle(Locale.turnOn.localized, for: .normal)
                    renewButton.isHidden = false
                }
                
            } else {
                
                bottomViewHiddle = true
                
            }
            
            updateViewLayout()
            
        }
        
    }
    
    private func updateViewLayout() {
        
        line.removeFromSuperview()
        renewDescLabel.removeFromSuperview()
        rateLabel.removeFromSuperview()
        renewButton.removeFromSuperview()
        
        if bottomViewHiddle {
            
            dateTextLabel.add(to: containerView).snp.makeConstraints {
                $0.top.equalTo(totalLabel.snp.bottom).offset(12)
                $0.left.equalTo(nameLabel)
                $0.bottom.equalToSuperview().inset(16)
            }
            return
        }
        
        dateTextLabel.snp.remakeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(12)
            $0.left.equalTo(nameLabel)
        }
        
        line.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(dateTextLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        renewDescLabel.add(to: containerView).snp.makeConstraints {
            $0.left.equalTo(line)
            $0.top.equalTo(line.snp.bottom).offset(18)
            $0.bottom.equalToSuperview().inset(18).priority(.high)
        }
        
        rateLabel.add(to: containerView).snp.makeConstraints {
            $0.centerY.equalTo(renewDescLabel)
            $0.left.equalTo(renewDescLabel.snp.right).offset(4)
        }
        
        if !renewButton.isHidden {
            
            renewButton.add(to: containerView).snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(83)
                $0.height.equalTo(28)
                $0.left.greaterThanOrEqualTo(rateLabel.snp.right).offset(10)
                $0.right.equalTo(line)
                $0.centerY.equalTo(renewDescLabel)
            }
            
        }
        
    }
    
}

class DepositItemRenewingCell: DepositItemCell {
    
    private lazy var renewDescLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#666666")
        $0.text = Locale.autoFund.localized
    }
    
    private lazy var rateLabel = DepositRateView()
    
    private lazy var renewStatusLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#666666")
        $0.text = Locale.on.localized
    }
    
    private lazy var line = UIView().then {
        $0.backgroundColor = .init(hexString: "#E6E6E6")
    }
    
    override func updateText(_ isSecure: Bool) {
        super.updateText(isSecure)
        
        addView()
        rateLabel.text = item?.order.renewRate.rateValue
        
    }
    
    private func addView() {
        
        line.removeFromSuperview()
        renewDescLabel.removeFromSuperview()
        rateLabel.removeFromSuperview()
        renewStatusLabel.removeFromSuperview()
        
        rateLabel = DepositRateView()
        
        dateTextLabel.snp.remakeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(12)
            $0.left.equalTo(nameLabel)
        }
        
        line.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(dateTextLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        renewDescLabel.add(to: containerView).snp.makeConstraints {
            $0.left.equalTo(line)
            $0.top.equalTo(line.snp.bottom).offset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        rateLabel.add(to: containerView).snp.makeConstraints {
            $0.centerY.equalTo(renewDescLabel)
            $0.left.equalTo(renewDescLabel.snp.right).offset(4)
        }
        
        renewStatusLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(rateLabel.snp.right).offset(10)
            $0.right.equalTo(line)
            $0.centerY.equalTo(renewDescLabel)
        }
        
    }
    
}
