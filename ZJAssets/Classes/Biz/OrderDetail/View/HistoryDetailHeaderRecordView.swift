//
//  HistoryDetailHeaderRecordView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit

class HistoryDetailHeaderRecordView: BaseView {
    
    convenience init(infos: [HistoryDetailHeaderModel.Info]) {
        self.init()
        
        createUI(infos: infos)
        
    }
    
    func createUI(infos: [HistoryDetailHeaderModel.Info]) {
        
        let bgView = UIView(backgroundColor: .init(hexString: "F8F8F8"))
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        bgView.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews:
                                        infos.enumerated().map{
                                            HistoryDetailHeaderRecordItemView(info: $0.element, isLast: $0.offset == infos.count - 1) })
        stackView.axis = .vertical
        stackView.add(to: bgView).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

fileprivate class HistoryDetailHeaderRecordItemView: BaseView {
    
    convenience init(info: HistoryDetailHeaderModel.Info, isLast: Bool) {
        self.init()
        
        createUI(info: info, isLast: isLast)
        
    }
    
    func createUI(info: HistoryDetailHeaderModel.Info, isLast: Bool) {
        
        let leftwidth = (UIScreen.screenWidth - (24 * 2) - 8) * 0.6
        
        let titleLabel = UILabel().then {
            $0.textColor = .init(hexString: "666666")
            $0.font = UIFont.regular14
        }
        titleLabel.add(to: self).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(leftwidth)
            $0.height.greaterThanOrEqualTo(26)
        }
        
        let amountLabel = UILabel().then {
            $0.textColor = UIColor(hexString: "333333")
            $0.font = UIFont.medium14
            $0.textAlignment = .right
        }
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.5
        amountLabel.add(to: self).snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(titleLabel)
        }
        
        if !isLast {
            let sepectorView = UIView(backgroundColor: .init(hexString: "EFEFF4"))
            sepectorView.add(to: self).snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        titleLabel.text = info.title
        amountLabel.text = info.amount
        
    }
    
}
