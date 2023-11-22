//
//  DepositPayItemCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import RxSwift

class DepositPayItemCell: DepositBaseCell {
    
    private var bag = DisposeBag()
    
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
    
    fileprivate lazy var paymentLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.paymentAmount.localized
    }
    
    fileprivate lazy var amountLabel = UILabel().then {
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
            redPointView.isHidden = item?.order.isRead ?? true
            item?.isSecureText.subscribeNext(weak: self, DepositPayItemCell.updateText).disposed(by: bag)
        }
    }
    
    func updateText(_ isSecure: Bool) {
        
        if isSecure {
            amountLabel.text = item?.secureText
        } else {
            amountLabel.text = item?.order.totalAmount.amountValue
        }
        
        nameLabel.text = item?.order.name
        statusLabel.text = item?.order.statusDesc
        
    }
    
    override func setupViews() {
                        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.auto)
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview().inset(6.auto)
        }
        
        nameLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.auto)
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
        
        paymentLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17.auto)
            $0.left.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(16.auto)
        }
        
        amountLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(paymentLabel.snp.right).offset(10.auto)
            $0.right.equalTo(statusLabel)
            $0.centerY.equalTo(paymentLabel)
        }
        
    }

}

class DepositUnpaidCell: DepositPayItemCell {
    
    fileprivate lazy var timeLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.remainingTime.localized
    }
    
    private lazy var countDownView = CountDownView()
    
    private var timeBag = DisposeBag()
    
    private func createTimer(sysTimeDiff: NSNumber?, expiredTime: NSNumber?) {
        
        timeBag = DisposeBag()
        guard let diffTime = sysTimeDiff, let eTime = expiredTime else {
            return
        }
        
        let currentTime = Int64(Date().timeIntervalSince1970) - diffTime.int64Value
        let exTime = eTime.int64Value / 1000
        var time = exTime - currentTime
        
        if time <= 0 {
            time = 0
            countDownView.label.text = time.getCountDownTime
            return
        }
        
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (num) in

                time -= 1
                self?.countDownView.label.text = time.getCountDownTime
                if time <= 0 {
                    self?.timeBag = DisposeBag()
                }

              }).disposed(by: timeBag)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        paymentLabel.snp.remakeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
            $0.left.equalTo(nameLabel)
        }
        
        timeLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(16)
            $0.left.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        countDownView.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(timeLabel.snp.right).offset(10)
            $0.right.equalTo(statusLabel)
            $0.centerY.equalTo(timeLabel)
        }
        
    }
    
    override func updateText(_ isSecure: Bool) {
        super.updateText(isSecure)
        
        createTimer(sysTimeDiff: item?.sysTimeDiff, expiredTime: item?.order.expiredTime)

    }
    
    deinit {
        timeBag = DisposeBag()
    }
    
    
}

class DepositPendingSignatureCell: DepositPayItemCell {
    
    fileprivate lazy var timeLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.remainingTime.localized
    }
    
    private lazy var countDownView = CountDownView()
    
    private lazy var line = UIView().then {
        $0.backgroundColor = .init(hexString: "#E6E6E6")
    }
    
    fileprivate lazy var tipLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.completeSignTip.localized
    }
    
    private var timeBag = DisposeBag()
    
    private func createTimer(sysTimeDiff: NSNumber?, scheduledTime: NSNumber?) {
        
        timeBag = DisposeBag()
        guard let diffTime = sysTimeDiff, let sTime = scheduledTime else {
            return
        }
        
        let currentTime = Int64(Date().timeIntervalSince1970) - diffTime.int64Value
        let scTime = sTime.int64Value / 1000
        var time = scTime - currentTime
        
        if time <= 0 {
            time = 0
            countDownView.label.text = time.getCountDownTime
            return
        }
        
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (num) in

                time -= 1
                self?.countDownView.label.text = time.getCountDownTime
                if time <= 0 {
                    self?.timeBag = DisposeBag()
                }

              }).disposed(by: timeBag)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        paymentLabel.snp.remakeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
            $0.left.equalTo(nameLabel)
        }
        
        timeLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(16)
            $0.left.equalTo(nameLabel)
        }
        
        countDownView.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(timeLabel.snp.right).offset(10)
            $0.right.equalTo(statusLabel)
            $0.centerY.equalTo(timeLabel)
        }
        
        line.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        tipLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(14)
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(statusLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    override func updateText(_ isSecure: Bool) {
        super.updateText(isSecure)
        
        createTimer(sysTimeDiff: item?.sysTimeDiff, scheduledTime: item?.order.scheduledTime)

    }
    
    deinit {
        timeBag = DisposeBag()
    }
    
    
}

class DepositPendingVACell: DepositPayItemCell {
    
    var needRefresh: (() -> Void)?
    
    private lazy var line = UIView().then {
        $0.backgroundColor = .init(hexString: "#E6E6E6")
    }
    
    fileprivate lazy var tipLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
        $0.text = Locale.paymentTip.localized
    }
    
    fileprivate lazy var timeLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#999999")
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private var timeBag = DisposeBag()
    
    private func addView() {
        
        line.removeFromSuperview()
        tipLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        
        paymentLabel.snp.remakeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
            $0.left.equalTo(nameLabel)
        }
        
        line.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        tipLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(14)
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(statusLabel)
        }
        
        timeLabel.add(to: containerView).snp.makeConstraints {
            $0.top.equalTo(tipLabel.snp.bottom).offset(14)
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(statusLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    override func updateText(_ isSecure: Bool) {
        super.updateText(isSecure)
        
        addView()
        createTimer(sysTimeDiff: item?.sysTimeDiff, scheduledTime: item?.order.scheduledTime)

    }
    
    private func createTimer(sysTimeDiff: NSNumber?, scheduledTime: NSNumber?) {
        
        timeBag = DisposeBag()
        guard let diffTime = sysTimeDiff, let eTime = scheduledTime else {
            return
        }
        
        let currentTime = Int64(Date().timeIntervalSince1970) - diffTime.int64Value
        let exTime = eTime.int64Value / 1000
        var time = exTime - currentTime
        if time <= 0 {
            removeTimeLabel()
            return
        }
        timeLabel.text = Locale.estimatedWaitTime.localized(arguments: "00:00")
        
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (num) in

                time -= 1
                self?.timeLabel.text = Locale.estimatedWaitTime.localized(arguments: time.getMinutesAndSecondsTime)
                if time <= 0 {
                    self?.timeBag = DisposeBag()
                    self?.needRefresh?()
                }

              }).disposed(by: timeBag)
        
    }
    
    private func removeTimeLabel() {
        timeLabel.removeFromSuperview()
        tipLabel.snp.remakeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(14)
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(statusLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
}

