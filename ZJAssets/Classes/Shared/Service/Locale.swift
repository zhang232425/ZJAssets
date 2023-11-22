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

    case transaction
    
    case days
    case day
    case months
    case month
    
    //Empty
    case no_product
    case no_signal
    case no_expiredOrder
    case no_records
    case no_records_for_period
    case no_regular_order
    case no_regular_order_button
    case refresh
    
    case total_return
    case yesterday_return
    case expired_orders
    case amount_to_be_paid
    case insurance_premium
    
    case reLend
    case confirm
    case cancel
    case auto_relend
    
    case auto_withdrawin
    case continue_lending
    case manual_withdrawal
    case withdrawing
    case virtual_account
    case to_pay
    case expired
    case virtual_account_expired
    
    case close_autoLend_tips
    
    //MARK: - Order Expired
    case order_expired_tip
    
    //MARK: - Asset detail
    case current_lending
    case current_lending_new
    case usable_amount

    case deposit
    case funding_amount
    
    case auto_continue_remind
    case please_select_product
    case select_product_first

    case withdrawal_plan
    case withdraw_period_head
    case withdraw_period_foot
    case withdraw_period_comma
    case withdraw_period_total
    case withdrawn
    case pending_withdrawal
    case invest_time
    case tax
    case totalTax
    case tax_subtitle1
    case tax_subtitle2
    case tax_subtitle3
    case tax_content
    case days_of_interest_calculation
    case tenor
    case maturity_date_alert
    case after_maturity
    case after_maturity_question
    case coupon
    case earnings_from_coupon
    case order_id
    case withdraw_type
    case best_call_time
    case total_expected_return
    case estimated_return_rate
    case got_it
    
    case credittobank
    case name
    case bank
    case bankno
    case borrower_details
    case contract
    
    case agreementLabel_text
    case agreementLabel_text1
    
    case continue_funding_now
    
    case tips
    case i_know
    
    case withdraw_tips_do
    case withdraw_tips_giveup
    
    case withdraw_success
    
    case continue_lend
    case apply_for_withdrawal
    
    //MARK: - sign
    case sign_now
    case sign_alert
    
    //MARK: - continue investment
    case continue_withdraw
    case continue_withdrawing
    
    //MARK: - auto product list
    case best_selling_product
    case pick_it
    
    case select_products
    case select_products_add_interst1
    case select_products_add_interst2
    case select_products_add_interst3

    case daily_earnings
    case select
    case selected

    case select_products_bottom
    
    //MARK: - auto product selected Alert
    case choose_product_confirm_1
    case choose_product_confirm_2
    case choose_product_confirm_3

    //MARK: - 活期
    case flexible_balance
    case in_process_of_withdraw
    case total_earnings
    case yesterdays_earnings
    case fund_details
    case fund
    case withdraw
    case details

    //MARK: - withdraw 活期提现
    case amount_pending_withdrawal
    case withdrawal_amount
    case minimum_withdrawal_amount
    case maximum_withdrawal_amount
    case minimum_withdrawal_amount_remind
    case maximum_withdrawal_amount_remind
    case less_available_amount
    case expected_arrival_time
    case bank_card_to_receive
    case rules

    //MARK: - withdraw Result 活期提现结果
    case application_result
    case in_process_of_automatic_withdrawal
    case estimated_receive_account
    case completed
    
    //MARK: - history
    case transcation_records
    case `in`
    case out
    case select_time

    //Mark: - TimeSelector
    case select_month
    case set_time_Periods
    case more_than_one_year
    
    //MARK: - 投资成功
    case payment
    case continue_funding

    //MARK: - 提现成功
    case check_order
    
    case autoFundDay        = "auto_fund_day"
    case autoFundTip        = "auto_fund_tip"
    case autoWithdrawDay    = "auto_withdraw_day"
    case autoWithdrawTip    = "auto_withdraw_tip"
    
}

extension Locale: ZJLocalizable {
    
    var key: String { rawValue }
     
    var table: String { "Locale" }
    
    var bundle: Bundle { .framework_ZJAssets }
    
}
