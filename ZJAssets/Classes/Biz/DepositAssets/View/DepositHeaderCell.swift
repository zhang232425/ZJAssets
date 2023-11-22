//
//  DepositHeaderCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import ZJBase
import RxSwift

class DepositHeaderCell: DepositBaseCell {

    private var bag = DisposeBag()
    
    var secureClickAction: (() -> ())?
    
    var info: DepositAssetsHeaderInfo? {
        didSet {
            bag = DisposeBag()
            info?.isSecureText.subscribeNext(weak: self, DepositHeaderCell.updateText).disposed(by: bag)
        }
    }
    
    private lazy var totalLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.totalAmount.localized
    }
    
    private lazy var earningLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.text = Locale.totalEarning.localized
    }

    private lazy var amountLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = .bold20
        $0.textColor = .init(hexString: "#333333")
    }
    
    private lazy var earningAmountLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = .medium14
        $0.textColor = .init(hexString: "#333333")
    }
    
    private lazy var eyeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_eye"), for: .normal)
        $0.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    override func setupViews() {
        
        totalLabel.add(to: contentView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.auto)
            $0.left.equalToSuperview().inset(16.auto)
        }
        
        eyeButton.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalTo(totalLabel)
            $0.left.equalTo(totalLabel.snp.right).offset(4.auto)
            $0.width.height.equalTo(12.auto)
        }
        
        amountLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(totalLabel)
            $0.top.equalTo(totalLabel.snp.bottom).offset(2.auto)
            $0.right.equalToSuperview().inset(16.auto)
        }
        
        earningLabel.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(16.auto)
            $0.left.equalToSuperview().inset(16.auto)
            $0.right.equalTo(contentView.snp.centerX).offset(-6.auto)
        }
            
        earningAmountLabel.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalTo(earningLabel)
            $0.top.equalTo(earningLabel.snp.bottom).offset(4.auto)
            $0.bottom.equalToSuperview().inset(10.auto)
        }
                
    }

}

private extension DepositHeaderCell {

    func updateText(_ isSecure: Bool) {
        
        if isSecure {
            amountLabel.text = info?.secureText
            earningAmountLabel.text = info?.secureText
            eyeButton.setImage(.named("icon_eye_close"), for: .normal)
        } else {
            amountLabel.text = info?.totalAmount.amountValue
            earningAmountLabel.text = info?.totalEarning.assetsValue
            eyeButton.setImage(.named("icon_eye"), for: .normal)
        }
        
    }
    
    @objc func buttonClick() {
        secureClickAction?()
    }
    
}
