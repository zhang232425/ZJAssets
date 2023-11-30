//
//  OrderModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import Foundation
import HandyJSON

enum OrderType: Int, HandyJSONEnum {
    case fixed    = 1  // 定期 0、1、2都是定期
    case flexible = 3  // 活期
    case advance  = 20 // 消分
}

enum DetailType: Int, HandyJSONEnum {
    case fixed    = 2  // 定期 0、1、2都是定期
    case flexible = 3  // 活期
    case advance  = 20 // 消分
}

enum PeriodUnit: Int,HandyJSONEnum {
    case day = 1    //周期单位: 天
    case month = 2  //周期单位: 月
}

enum OrderStatus: Int, HandyJSONEnum {
    //保险待支付
    case insuranceUnPaid = 201
    //保险支付中
    case insurancePaying = 202
    //待支付
    case unPaid = 1
    //已支付
    case paid = 2
    //到期
    case expiration = 4
    //等待转账
    case waitingTransfer = 8
    //已转出
    case transferred = 16
    //提前提现
    case advanceWithdraw = 32
    //生成支付方信息错误
    case ceatePayFailed = 64
    //支付超时，已无效
    case expired = 128
    //转出失败
    case transferFailed = 256
    //已续投
    case continued = 512
    //计息中
    case inCalculatingInterest = 606
}

extension OrderStatus {
    
    var isUnPaid: Bool {
        self == .unPaid || self == .insuranceUnPaid || self == .insurancePaying
    }
}

struct OrderListResult: HandyJSON {

    var lastIncome = NSNumber(value: 0)
    
    var totalIncome = NSNumber(value: 0)
    
    var orders: [OrderModel] = []
    
    var total = NSNumber(value: 0)
    
    var nextPage: String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< orders        <-- "content"
    }
    
}

struct WithdrawalPlanModel: HandyJSON {
    
    var periods = ""
    
    /// 到期日
    var endTime: NSNumber?
    
    var amount = ""
    
    var refunded = false
    
    /// 回款计划ID
    var id = ""
    
    /// 返现金额税后
    var backAmount = NSNumber(value: 0)
    
    ///  回款计划本金
    var principal = NSNumber(value: 0)
    
    /// 收益
    var income = NSNumber(value: 0)
    
    /// 税费
    var taxAmount = NSNumber(value: 0)
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<  amount  <-- "formatAmount"
        mapper <<<  periods <-- "formatPeriods"
    }
    
}

struct RemainPlanModel: HandyJSON {
    // 剩余 返现金额税后
    var backAmount = NSNumber(value: 0)
    // 剩余  回款计划本金
    var principal = NSNumber(value: 0)
    // 剩余  收益
    var income = NSNumber(value: 0)
    // 剩余  到期日
    var endTime: NSNumber?
}

class OrderModel {
    
    //本金+新版体验金券的金额   (ps: 订单列表和活期订单详情接口：amount直接展示，无需添加totalIncome。 )
    var amount = NSNumber(value: 0)

    //投资本金（投资文本框输入的投资金额）
    var principal = NSNumber(value: 0)

    //投资金额 (计息金额 不包括新现金券的金额)
    var investmentAmount = NSNumber(value: 0)

    var id: String = ""

    var rate: Double = 0

    var productId: String = ""

    var status: OrderStatus = .unPaid
    
    var orderType: OrderType = .fixed
    
    var periodUnit: PeriodUnit = .day
    
    var period: Int = 0
    
    //是否展示税费信息 如到期回款解释入口，税后标签，税费字段
    var showTaxesFree: Bool = false
    
    //税后文案
    var afterTaxLabel: String = ""
    
    //税费文案
    var taxesFreeLabel: String = ""
    
    //税费金额
    var taxesFreeAmount = NSNumber(value: 0)
    
    //保费
    var insureAmount = NSNumber(value: 0)
    
    //保费标题
    var insureAmountLabel: String?
    
    //保费描述
    var insureAmountSub: String?
    
    //到期回款
    var totalBackLabel: String = ""
    
    //总回款金额
    var totalBackAmount = NSNumber(value: 0)
    
    //到期回款提示内容
    var totalBackTip: String = ""
    
    //续投加息
    var continueInterest: Double = 0
    
    //可使用余额
    var usableAmount: NSNumber?

    //当前利息
    var totalIncome = NSNumber(value: 0)
    
    //昨日收益
    var lastIncome = NSNumber(value: 0)
    
    //订单剩余金额
    var remainAmount = NSNumber(value: 0)

    //预期总利息
    var expectIncome = NSNumber(value: 0)

    var createTime = NSNumber(value: 0)
    //到期时间
    var endTime = ""
    //剩余天数
    var matureDays = "0"

    // 当前订单产品
    var name = ""
    
    //预期收益格式化 (产品详情使用)
    var expectIncomeFormat = ""
    
    // 优惠券描述
    var couponFormat: String?
    
    // 优惠券收益
    var couponIncome: NSNumber?
    
    //提现标签
    var withdrawLabel = ""
    
    //提现内容（？问号内容）
    var withdrawContent = ""
    
    //计息天数
    var daysOfIncomeFormat: String?
    
    //副标题(列表cell提示)
    var subtitle = ""

    //是否继续投资
    var isContinue = false
    
    //展示自动续投功能
    var isShowAutoLend = false
    
    //是否自动续投
    var isAutoLend = false
    
    //自动续投状态语 为空时，按钮可点击
    var autoLendStatus: String?
    
    var autoLendTitle = ""
    
    var autoLendContent = ""
    
    var autoLendQa = ""
    
    var autoLendQaContent = ""
    
    // 是否已阅读
    var isRead = true
    
    // 自动续投产品名
    var autoTmplName: String?
    
    // 自动续投模板ID
    var autoTmplId: String?
    
    // 已回款期数
    var backPeriod: Int = 0
    // 总回款期数
    var periodCount: Int = 0
    // 每月回款
    var dayOfMonth: String?
    // 回款计划
    var backPlans: [WithdrawalPlanModel]?
    
    /// 剩余回款数据
    var remainPlan: RemainPlanModel?
    
    // 签名合同
    var contractUrl: String?
    // 签名到期时间戳
    var signEndTime: Double = 0
    
    var fundTime = NSNumber(value: 0)
    
    var formatRate = ""
    
    // 逾期说明文案
    var overdueDesc = ""
    
    // 订单类型
    var type: DetailType = .fixed

    required init() {}
    
}

extension OrderModel: HandyJSON {
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<<  withdrawLabel       <-- "wdLabel"
        mapper <<<  withdrawContent     <-- "wdContent"
        
        mapper <<<  isShowAutoLend      <-- "autoBtn"
        mapper <<<  isAutoLend          <-- "autoContinue"
        mapper <<<  autoLendStatus      <-- "autoStatus"
        
        // 1 - 已读 2 - 未读
        mapper <<<  isRead              <-- TransformOf<Bool, Int>(fromJSON: { $0 == 1 }, toJSON: { _ in 1 })
        
        mapper <<<  autoLendTitle       <-- "autoLabel"
        mapper <<<  autoLendContent     <-- "autoContent"
        mapper <<<  autoLendQa          <-- "autoQaTitle"
        mapper <<<  autoLendQaContent   <-- "autoQaContent"
        
        mapper <<<  dayOfMonth          <-- "formatDayOfMoth"
        
        mapper <<<  endTime             <-- TransformOf<String, NSNumber>(fromJSON: { $0?.dmyDate() },
                                                                          toJSON: { _ in nil })
        
    }
    
}
