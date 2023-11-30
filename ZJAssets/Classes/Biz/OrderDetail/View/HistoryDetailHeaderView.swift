//
//  HistoryDetailHeaderView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit
import ZJCommonView

class HistoryDetailHeaderView: UIView {
    
    convenience init(info: HistoryDetailHeaderModel) {
        self.init()
        setupViews(info: info)
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
                     
    func setupViews(info: HistoryDetailHeaderModel) {
        
        let bgView = RoundCornerView(radius: 8)
        bgView.add(to: self).snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12))
        }
        
        // 标题
        let titleLabel = UILabel().then {
            $0.textColor = .init(hexString: "333333")
            $0.font = UIFont.regular12
            $0.textAlignment = .center
        }
        titleLabel.add(to: bgView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        // 金额
        let amountLabel = UILabel().then {
            $0.textColor = .init(hexString: "333333")
            $0.font = UIFont.medium20
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
        amountLabel.add(to: bgView).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        // 时间
        let timeLabel = UILabel().then {
            $0.textColor = .init(hexString: "999999")
            $0.font = UIFont.regular12
            $0.textAlignment = .center
        }
        timeLabel.add(to: bgView).snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }

        // 详细记录
        let itemView: UIView = info.isWithdraw ? HistoryDetailHeaderWithdrawView(infos: info.infos) :  HistoryDetailHeaderRecordView(infos: info.infos)
        itemView.add(to: bgView).snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(18)
            $0.left.bottom.right.equalToSuperview().inset(12)
        }
        
        titleLabel.text = info.title
        amountLabel.text = info.amount
        timeLabel.text = info.time
        
    }
    
}
