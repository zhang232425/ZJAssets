//
//  OrderDetailItem.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import Foundation

struct OrderDetailTransactionInfo {
    let transactionNo: String?
    let transactionRecords: String
}

struct OrderDetailRemainPlanInfo {
    let backAmount: String?
    let principal: String?
    let income: String?
    let endTime: String?
    let overdueDesc: String?
}

struct OrderDetailPrincipalInfo {
    let principal: String?
    let totalIncome: String?
    let totalBackAmount: String?
    let taxesFreeAmount: String?
}

struct OrderDetailRateInfo {
    let rate: String?
}

struct OrderDetailBackPlansInfo {
    let backAmount: String?
    let principal: String?
    let income: String?
    let endTime: String?
    let taxAmount: String?
    let overdueDesc: String?
}

struct OrderDetailHeadInfo {
    let transactionNo: String?
    let label: String?
    let labelImage: UIImage?
    let title: String?
    let money: String?
    let usableAmount: String?
    let transactionRecords: String
    let totalBackLabel: String?
    let afterTaxLabel: String?
    let totalBackTip: String?
    let showTaxesFree: Bool
    let list: [[OrderDetailMoneyInfo]]
}

struct OrderDetailMoneyInfo {
    let title: String?
    let content: String?
    let isHideLine: Bool
}

class OrderDetailAutoInfo {
    let title: String
    let content: String
    let statusDesc: String?
    let isSelect: Bool
    
    init(title: String, content: String, statusDesc: String?, isSelect: Bool) {
        self.title = title
        self.content = content
        self.statusDesc = statusDesc
        self.isSelect = isSelect
    }
}

struct OrderDetailCouponInfo {
    let title: String?
    let name: String?
    let earnings: NSAttributedString?
    var isShowEarnings: Bool { earnings != nil }
}

struct OrderDetailWithdrawalPlanInfo {
    let title: String?
    let content: String?
    let currentPeriod: String
    let periods: String
    let arrowImage = UIImage(named: "arrow_right_gray")
    var periodAttr: NSAttributedString {
        periods.dd.setHighlight(keywords: [currentPeriod],
                                font: UIFont.regular12,
                                color: .init(hexString: "999999"),
                                highColor: .init(hexString: "FF7D0F"))
    }
}


struct OrderDetailQuestionInfo {
    let title: String?
    let content: String?
    let questionImage = UIImage(named: "question")
    let isHideLine: Bool
}

struct OrderDetailItemInfo {
    let title: String?
    let content: String?
    let isHideLine: Bool
}

struct OrderDetailTwoRowInfo {
    let title: String?
    let subTitle: String?
    let content: String?
    let isHideLine: Bool
}

struct OrderDetailItemSelectInfo {
    let title: String?
    let content: String?
    let arrowImage = UIImage(named: "arrow_right_gray")
    let isHideLine: Bool
    var url: String? = nil
}

struct OrderDetailAgreementInfo {
    let agreement: String
    let agreementContent: String
    let url: String
}

struct OrderDetailFootInfo {
    var content: String
    var addRate: String? = nil
    let addRateImage = UIImage.named("add_rate_white")
    let addRateColor = UIColor(hexString: "FF7D0F")
    
}
