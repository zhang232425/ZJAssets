//
//  Locale.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import ZJLocalizable

enum Locale: String {
    
    case assets             = "assets"
    case totalAsset         = "total_asset"
    case yestdayIncome      = "yestday_income"
    case totalIncome        = "total_income"
    case unpayOrderTip      = "unpaid_order_tip"
    case unpayOrdersTip     = "unpaid_orders_tip"
    case balance            = "balance"
    case continueFund       = "continue_fund"
    case p2p                = "p2p_regular"
    case chartTitle         = "chart_title"
    case totalAmount        = "total_amount"
    case totalAmountCell    = "total_amount_cell"
    case totalEarning       = "total_earning"
    case paymentAmount      = "payment_amount"
    case paymentTip         = "payment_tip"
    case completeSignTip    = "complete_sign_tip"
    case estimatedWaitTime  = "estimated_wait_time"
    case remainingTime      = "remaining_time"
    case earningDetail      = "earning_detail"
    case transactionHistory = "transaction_history"
    case dueDate            = "due_date"
    case autoFund           = "auto_fund"
    case turnOn             = "turn_on"
    case fundDayTip         = "fund_day_tip"
    case on                 = "on"
    case noData             = "no_data"
    case goToProduct        = "go_product"
    case signOrderTip       = "sign_order_tip"
    case signOrdersTip      = "sign_orders_tip"
    case appointOrderTip    = "appoint_order_tip"
    case appointOrdersTip   = "appoint_orders_tip"
    case go                 = "go"
    case signTitle          = "sign_title"
    case insureTitle        = "insure_title"
    case insureTip          = "insure_tip"
    case insureNumber       = "insure_number"
    case familyMember       = "family_member"
    case policyNumber       = "policy_number"
    case familyPolicy       = "family_policy"
    case filter             = "filter"
    case all                = "all"
    case productType        = "product_type"
    case tradeType          = "trade_type"
    case processing         = "processing"
    case history            = "history"
    case lastMonth          = "last_month"
    case last3Month         = "last_3_month"
    case lastYear           = "last_year"
    case oldHistory         = "old_history"
    case transactionRecord  = "transaction_record"
    case transactionTime    = "transaction_time"
    case custom             = "custom"
    case productName        = "product_name"
    case noMore             = "no_more"
    case incomeBottomTip    = "income_bottom_tip"
    case tradeIconTip       = "trade_icon_tip"
    case tradeOldTip        = "trade_old_tip"
    case bookingHistory     = "booking_history"
    case insured            = "insured"
    case insuredDes         = "insured_des"
    case ok                 = "ok"
    
    case maturityAmount     = "maturity_amount"
    case afterTax           = "after_tax"
    case principal          = "principal"
    case expectedEarnings   = "expected_earnings"
    case maturityDate       = "maturity_date"
    case maturityDateOne  = "maturity_date_one"
    case actualEarnings     = "actual_earnings"
    case fundingPrincipal   = "funding_principal"
    case earlyRepayment     = "early_repayment"
    case more               = "more"
    case repaid             = "repaid"
    case interestRate
    case earnings
    case totalEarnings
    
    case maturity_amount_hint_title
    case maturity_amount_hint_subtitle
    case maturity_amount_hint_one
    case maturity_amount_hint_two
    case maturity_amount_hint_three
    
    case expected_earnings_hint_title
    case expected_earnings_hint_subtitle
    case expected_earnings_hint_desc
    
    case maturity_amount_repaid_hint_title
    case maturity_amount_repaid_hint_subtitle
    case maturity_amount_repaid_hint_one
    case maturity_amount_repaid_hint_two
    case maturity_amount_repaid_hint_three
    
    case earnings_hint_title
    case earnings_hint_subtitle
    case earnings_hint_desc
    
    case total_actual_earnings_hint_title
    case total_actual_earnings_hint_subtitle
    
    case remainPlanTitle
    
    // 预期订单2.0优化
    case overdue
    case total_maturity_amount
    case total_tax
    
    //Empty
    case no_product
    case no_signal
    case no_expiredOrder
    case no_records
    case no_records_for_period
    case no_regular_order
    case no_regular_order_button
    case refresh
    
}

extension Locale: ZJLocalizable {
    
    var key: String { rawValue }
     
    var table: String { "Locale" }
    
    var bundle: Bundle { .framework_ZJAssets }
    
}
