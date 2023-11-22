//
//  DepositFuncCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit

class DepositFuncCell: DepositBaseCell {
    
    var signHandler: (() -> ())?
    
    var transactionHandler: (() -> ())?
    
    var incomeHandler: (() -> ())?
    
    var signCount: Int = 0 {
        didSet {
            if signCount > 0 {
                signView.isHidden = false
                if signCount > 1 {
                    signView.setContent(content: Locale.appointOrdersTip.localized(arguments: "\(signCount)"), key: "\(signCount)")
                } else {
                    signView.setContent(content: Locale.appointOrderTip.localized(arguments: "\(signCount)"), key: "\(signCount)")
                }
                
            } else {
                signView.isHidden = true
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    fileprivate lazy var leftIconView = FuncIconView().then {
        $0.imageView.image = .named("icon_deposit_earning")
        $0.label.text = Locale.earningDetail.localized
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(incomeClick)))
    }
    
    fileprivate lazy var rightIconView = FuncIconView().then {
        $0.imageView.image = .named("icon_deposit_record")
        $0.label.text = Locale.transactionHistory.localized
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transactionClick)))
    }
    
    fileprivate lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.layer.shadowColor = UIColor(hexString: "#000000", alpha: 0.06).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = .init(width: 0, height: 1)
        $0.layer.shadowRadius = 8
    }
    
    fileprivate lazy var signContainerView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
    }
    
    fileprivate lazy var signView = DepositSignView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signClick)))
    }
    
    fileprivate lazy var verticalLine = UIView().then {
        $0.backgroundColor = .init(hexString: "#E6E6E6")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if signView.isHidden {
            
            signContainerView.removeFromSuperview()
            
            containerView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16.auto)
                $0.top.bottom.equalToSuperview().inset(10.auto)
            }
            
        } else {
            
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(10.auto)
                $0.left.right.equalToSuperview().inset(16.auto)
            }
            
            signContainerView.add(to: containerView).snp.makeConstraints {
                $0.top.equalTo(containerView.snp.bottom).offset(-10.auto)
                $0.left.right.equalToSuperview().inset(16.auto)
                $0.bottom.equalToSuperview().inset(10.auto).priority(.high)
            }
            
        }
        
    }

    override func setupViews() {
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        verticalLine.add(to: containerView).snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(17).priority(.high)
        }
        
        leftIconView.add(to: containerView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(5)
            $0.right.equalTo(verticalLine.snp.left).offset(-5)
        }
        
        rightIconView.add(to: containerView).snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview().inset(5)
            $0.left.equalTo(verticalLine.snp.right).offset(5)
        }
        
        signView.add(to: signContainerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.bottom.right.equalToSuperview()
        }
        
    }

}

private extension DepositFuncCell {
    
    @objc func incomeClick() {
        incomeHandler?()
    }
    
    @objc func transactionClick() {
        transactionHandler?()
    }
    
    @objc func signClick() {
        signHandler?()
    }
    
}

class DepositFuncAppointCell: DepositFuncCell {
    
    private lazy var appointView = FuncIconView().then {
        $0.imageView.image = .named("icon_deposit_appointment")
        $0.label.text = Locale.bookingHistory.localized
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(appointClick)))
    }
    
    var appointHandler: (() -> ())?
    
    override func setupViews() {
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.top.bottom.equalToSuperview().inset(10.auto)
        }
        
        let topView = UIView()
        
        topView.add(to: containerView).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        verticalLine.add(to: topView).snp.makeConstraints {
            $0.width.equalTo(1.auto)
            $0.height.equalTo(24.auto)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(17.auto)
        }
        
        leftIconView.add(to: topView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(5.auto)
            $0.right.equalTo(verticalLine.snp.left).offset(-5.auto)
        }
        
        rightIconView.add(to: topView).snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview().inset(5.auto)
            $0.left.equalTo(verticalLine.snp.right).offset(5.auto)
        }
        
        let line = UIView()
        
        line.add(to: containerView).then {
            $0.backgroundColor = .init(hexString: "#F0F0F0")
        }.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1.auto)
        }
        
        appointView.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(5.auto)
            $0.left.right.bottom.equalToSuperview().inset(5.auto)
            $0.height.equalTo(leftIconView)
        }
        
        signView.add(to: signContainerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.auto)
            $0.left.bottom.right.equalToSuperview()
        }
        
    }
    
    @objc private func appointClick() {
        appointHandler?()
    }
    
}

private class FuncIconView: BaseView {
    
    private(set) lazy var imageView = UIImageView()
    
    private(set) lazy var label = UILabel().then {
        $0.textColor = .init(hexString: "#666666")
        $0.font = .regular12
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override func setupViews() {
        
        imageView.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(7.auto)
            $0.width.height.equalTo(28.auto)
            $0.centerY.equalToSuperview()
        }
        
        label.add(to: self).snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(4.auto)
            $0.right.lessThanOrEqualToSuperview().inset(4.auto)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}
