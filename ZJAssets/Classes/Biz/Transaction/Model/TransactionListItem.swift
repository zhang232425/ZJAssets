//
//  TransactionListItem.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import HandyJSON

struct TransactionListItem {
    
    enum Status: Int, HandyJSONEnum {
        //处理中
        case process    = 2000
        //交易成功
        case success    = 3000
        //交易失败|过期
        case closed     = 4000
        //交易取消
        case canceled   = 5000
    }
    
    enum BizType: Int, HandyJSONEnum {
        //支付类型
        case pay         = 1
        //提现类型
        case withdraw    = 2
        //赎回类型
        case redeem      = 3
        //退款类型
        case refund      = 4
        //终止类型
        case termination = 7
        
    }
    
    enum NavigationType: Int, HandyJSONEnum {
        //根据 refId 跳转至 p2p订单详情
        case depositDetail      = 1001
        //根据 refId 跳转至 p2p活期订单详情
        case flexDetail         = 1003
        //p2p 机构订单详情
        case corporateP2pOrderDetail = 1004
        //p2p 机构订单VA
        case corporateP2pVaPayment = 1005
        //根据 refId 跳转至 保险订单详情
        case insureDetail       = 2001
        //根据 refId 跳转至 提现详情
        case withdrawDetail     = 3001
        //根据 transactionId 跳转至 p2p订单待支付详情
        case payDetail          = 1002
        //根据 refId 跳转至 保险待支付详情
        case insurePayDetail    = 2002
        //跳转至失效列表
        case expiredList        = 4001
    }

    var tradeId = ""
    
    var productName = ""
    
    var amount = ""
    
    var status = Status.process
    
    var statusDesc = ""
    
    var type = BizType.pay
    
    var typeDesc = ""
    
    var showCountDown = false
    
    var countDownPeriod = TimeInterval(0)
    
    var createTime = ""
    
    var createMonth = ""
    
    var jumpType: NavigationType?
    
    var refId = ""
    
    var productId = ""
    
}

extension TransactionListItem: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< tradeId          <-- "transactionId"
                
        mapper <<< productName      <-- "subject"
        
        mapper <<< amount           <-- ("tradeAmount", TransformOf<String, NSNumber>(fromJSON: { $0?.amountValue },
                                                                                      toJSON: { _ in nil }))
        
        mapper <<< statusDesc       <-- "statusMsg"
        
        mapper <<< type             <-- "businessType"
        
        mapper <<< typeDesc         <-- "typeMsg"
        
        mapper <<< createTime       <-- ("initTime", TransformOf<String, NSNumber>(fromJSON: { $0?.seconds.dateString() },
                                                                                   toJSON: { _ in nil }))
        
        mapper <<< createMonth      <-- ("initTime", TransformOf<String, NSNumber>(fromJSON: { $0?.seconds.dateString(format: "MM/yyyy") },
                                                                                   toJSON: { _ in nil }))
        
        mapper <<< showCountDown    <-- "isShowExpired"
        
        mapper <<< countDownPeriod  <-- ("countDown", TransformOf<TimeInterval, NSNumber>(fromJSON: { $0?.seconds },
                                                                                          toJSON: { _ in nil }))
        
        mapper <<< refId            <-- TransformOf<String, Int64>(fromJSON: { "\($0 ?? 0)" },
                                                                   toJSON: { _ in nil })
    }
    
}

struct TransactionListPage: HandyJSON {
    
    var list: [TransactionListItem]?
    
    var nextPage: Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< list <-- "content"
    }
    
}

extension TransactionListItem.Status {
    
    var textColor: UIColor {
        switch self {
        case .process:
            return .init(hexString: "#FF7D0F")
        case .success, .closed, .canceled:
            return .init(hexString: "#999999")
        }
    }
    
}

extension TransactionListItem.BizType {
    
    var textColor: UIColor {
        switch self {
        case .pay:
            return .init(hexString: "#FF7D0F")
        case .withdraw, .redeem, .refund, .termination:
            return .init(hexString: "#3667EF")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .pay:
            return .init(hexString: "#FFF4EA")
        case .withdraw, .redeem, .refund, .termination:
            return .init(hexString: "#F1F5FF")
        }
    }
    
}
