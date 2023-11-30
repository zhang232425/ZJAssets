//
//  HistoryDetailHeaderWithdrawView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit

class HistoryDetailHeaderWithdrawView: BaseView {
    
    convenience init(infos: [HistoryDetailHeaderModel.Info]) {
        self.init()
        
        createUI(infos: infos)
        
    }
    
    func createUI(infos: [HistoryDetailHeaderModel.Info]) {
        
        let stackView = UIStackView(arrangedSubviews:
                                        infos.enumerated().map{
                                            HistoryDetailHeaderWithdrawItemView(info: $0.element, isLast: $0.offset == infos.count - 1) })
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

fileprivate class HistoryDetailHeaderWithdrawItemView: BaseView {
    
    convenience init(info: HistoryDetailHeaderModel.Info, isLast: Bool) {
        self.init()
        
        createUI(info: info, isLast: isLast)
        
    }
    
    func createUI(info: HistoryDetailHeaderModel.Info, isLast: Bool) {
        
        let bgView = UIView(backgroundColor: .init(hexString: "F8F8F8"))
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        bgView.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let leftwidth = (UIScreen.screenWidth - (24 * 2) - 8) * 0.6
        
        let titleLabel = UILabel().then {
            $0.textColor = .init(hexString: "666666")
            $0.font = UIFont.regular14
        }
        titleLabel.add(to: bgView).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(12)
            $0.width.equalTo(leftwidth)
        }
        
        let amountLabel = UILabel().then {
            $0.textColor = .init(hexString: "333333")
            $0.font = UIFont.medium14
            $0.textAlignment = .right
        }
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.5
        amountLabel.add(to: bgView).snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.right.equalToSuperview().inset(12)
            $0.top.bottom.equalTo(titleLabel)
        }
        
        let orderIDLabel = UILabel().then {
            $0.textColor = .init(hexString: "999999")
            $0.font = UIFont.regular12
        }
        orderIDLabel.add(to: bgView).snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        titleLabel.text = info.title
        amountLabel.text = info.amount
        orderIDLabel.text = info.content
        
    }
    
}
