//
//  AssetsHeaderView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/10.
//

import UIKit
import RxSwift
import RxSwiftExt

class AssetsHeaderView: BaseView {
    
    // MARK: - Property
    private var bag = DisposeBag()
    
    var secureClickAction: (() -> ())?
    
    var unpayClickAction: (() -> ())?
    
    var info: AssetsHeaderInfo? {
        didSet {
            bag = DisposeBag()
            info?.isSecureText.subscribeNext(weak: self, AssetsHeaderView.updateText).disposed(by: bag)
            totalLabel.text = Locale.totalAsset.localized
            earningLabel.text = Locale.totalIncome.localized
            switch info?.vipLevel {
            case .sixth:
                containerView.image = .named("vip_6_card")
                containerView.backgroundColor = nil
                let titleColor = UIColor(hexString: "#EFE4C6")
                let textColor = UIColor(hexString: "#FFF4D5")
                totalLabel.textColor = titleColor
                earningLabel.textColor = titleColor
                amountLabel.textColor = textColor
                earningAmountLabel.textColor = textColor
            default:
                containerView.image = nil
                containerView.backgroundColor = .white
                containerView.layer.shadowColor = UIColor(hexString: "#000000", alpha: 0.06).cgColor
                containerView.layer.shadowOpacity = 1
                containerView.layer.shadowOffset = .init(width: 0, height: 1)
                containerView.layer.shadowRadius = 8
                let titleColor = UIColor(hexString: "#999999")
                let textColor = UIColor(hexString: "#333333")
                totalLabel.textColor = titleColor
                earningLabel.textColor = titleColor
                amountLabel.textColor = textColor
                earningAmountLabel.textColor = textColor
            }
            
            if let count = info?.unpayCount, count > 0 {
                unpayView.isHidden = false
                unpayView.label.text = info?.unpayDesc
            } else {
                unpayView.isHidden = true
            }
            
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
            
        }
    }
    
    // MARK: - Lazy Load
    private lazy var totalLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = UIColor(hexString: "#999999")
    }
    
    private lazy var earningLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = UIColor(hexString: "#999999")
    }
    
    private lazy var amountLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = .bold14
        $0.textColor = UIColor(hexString: "#333333")
    }
    
    private lazy var earningAmountLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = .medium14
        $0.textColor = UIColor(hexString: "#333333")
    }
    
    private lazy var eyeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_eye"), for: .normal)
        $0.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    private lazy var unpayView = AssetsUnpayView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unpayClick)))
    }
    
    private lazy var containerView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var unpayContainerView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
    }

    override func setupViews() {
        
        backgroundColor = .clear
    
        containerView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview()
        }
        
        totalLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.auto)
            $0.left.equalToSuperview().inset(12.auto)
        }
        
        eyeButton.add(to: containerView).snp.makeConstraints {
            $0.centerY.equalTo(totalLabel)
            $0.left.equalTo(totalLabel.snp.right).offset(4.auto)
            $0.width.height.equalTo(12.auto)
        }
        
        amountLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(2.auto)
            $0.left.right.equalToSuperview().inset(12.auto)
        }
        
        earningLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(16.auto)
            $0.left.equalToSuperview().inset(12.auto)
            $0.right.equalTo(containerView.snp.centerX).offset(-6.auto)
        }
    
        earningAmountLabel.add(to: containerView).snp.makeConstraints {
            $0.left.right.equalTo(earningLabel)
            $0.top.equalTo(earningLabel.snp.bottom).offset(4.auto)
            $0.bottom.equalToSuperview().inset(16.auto)
        }
    
        unpayView.add(to: unpayContainerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.auto)
            $0.left.bottom.right.equalToSuperview()
        }
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if unpayView.isHidden {
            
            unpayContainerView.removeFromSuperview()
            
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.left.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview()
            }
            
        } else {
            
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.left.right.equalToSuperview().inset(16)
            }
            
            unpayContainerView.add(to: self).then {
                sendSubview(toBack: $0)
            }.snp.makeConstraints {
                $0.top.equalTo(containerView.snp.bottom).offset(-10)
                $0.left.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview()
            }
            
        }
        
    }

}

private extension AssetsHeaderView {
    
    @objc func buttonClick() {
        secureClickAction?()
    }
    
    @objc func unpayClick() {
        unpayClickAction?()
    }
    
    func updateText(_ isSecure: Bool) {
        if isSecure {
            amountLabel.text = info?.secureText
            earningAmountLabel.text = info?.secureText
            switch info?.vipLevel {
            case .sixth:
                eyeButton.setImage(.named("icon_eye_close_vip6"), for: .normal)
            default:
                eyeButton.setImage(.named("icon_eye_close"), for: .normal)
            }
        } else {
            amountLabel.text = info?.totalAmount.amountValue
            earningAmountLabel.text = info?.totalEarning.assetsValue
            switch info?.vipLevel {
            case .sixth:
                eyeButton.setImage(.named("icon_eye_vip6"), for: .normal)
            default:
                eyeButton.setImage(.named("icon_eye"), for: .normal)
            }
        }
    }
    
}
