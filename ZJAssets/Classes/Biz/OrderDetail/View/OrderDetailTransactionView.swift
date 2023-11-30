//
//  OrderDetailTransactionView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import UIKit

class OrderDetailTransactionView: BaseView {

    var recordsAction: (() -> ())?
    
    private lazy var transcationLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "#333333")
        $0.font = UIFont.regular12
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var recordsBtn = UIButton().then {
        $0.contentEdgeInsets = .init(top: 10, left: 0, bottom: 10, right: 0)
        $0.addTarget(self, action: #selector(recordsBtnClick), for: .touchUpInside)
    }

    convenience init(model: OrderDetailTransactionInfo, recordsAction: (() -> ())? = nil) {
        self.init()
        self.recordsAction = recordsAction
        setupViews(model)
    }

}

private extension OrderDetailTransactionView {
    
    func setupViews(_ model: OrderDetailTransactionInfo) {
        
        transcationLabel.text = model.transactionNo
        let width = (UIScreen.screenWidth - 12 * 2 - 8) * 0.5
        transcationLabel.add(to: self).snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(16)
            $0.width.equalTo(width)
        }
        
        let records = NSMutableAttributedString(string: model.transactionRecords,
                                                attributes: [.foregroundColor: UIColor(hexString: "3667EF"),
                                                             .underlineStyle: 1,
                                                             .font: UIFont.regular12])
        recordsBtn.setAttributedTitle(records, for: .normal)
        recordsBtn.add(to: self).snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(transcationLabel)
            $0.width.lessThanOrEqualTo(width)
        }
    
    }
    
    @objc func recordsBtnClick() {
        self.recordsAction?()
    }
    
}
