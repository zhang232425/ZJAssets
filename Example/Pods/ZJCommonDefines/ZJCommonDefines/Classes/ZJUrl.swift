//
//  ZJUrl.swift
//  Pods-ZJCommonDefines_Example
//
//  Created by Jercan on 2023/9/4.
//

import Foundation

public struct ZJUrl {}

public extension ZJUrl {
    
    static var server: String {
        #if DEBUG
        return Environment.current.server
        #else
        return "https://app.asetku.co.id"
        #endif
    }
    
    static var webServer: String {
        #if DEBUG
        return "\(Environment.current.loan)/management"
        #else
        return "https://asetloan.asetku.co.id"
        #endif
    }
    
    static var loan: String {
        #if DEBUG
        return Environment.current.loan
        #else
        return "https://asetloan.asetku.co.id"
        #endif
    }
    
    static var batch: String {
        #if DEBUG
        return Environment.current.betch
        #else
        return "https://asetloan.asetku.com"
        #endif
    }
    
    static var privacyPolicy: String {
        return "\(webServer)/privacyPolicy.html"
    }
    
    static var terms: String {
        return "\(webServer)/terms.html"
    }
    
    static var disclaimer: String {
        return "\(webServer)/disclaimer.html"
    }
    
    static var investment: String {
        return "\(webServer)/Investment.html"
    }
    
    /// 个人投资借款协议
    static var lendAndBorrowContract: String {
        return "\(webServer)/tncLendingAndborrowing.html"
    }
    
    /// 机构投资借款协议
    static var lendAndBorrowOrganizationContract: String {
        return "\(webServer)/v2/TncAsetkuCor"
    }
    
    //保险信息
    static var creditInsuranceInformation: String {
        return "\(webServer)/v2/IkhtisarAsuransi"
    }
    
    //大额贷协议
    static var creditAgreementInstallmentLoan: String {
        return "\(webServer)/creditAgreementInstallmentLoan.html"
    }
    
    //小额贷协议
    static var creditAgreementCashLoan: String {
        return "\(webServer)/creditAgreementCashLoan.html"
    }
    
    //消费分期协议
    static var creditInstallmentAgreement: String {
        return "\(webServer)/agreementInstallmentLoan.html"
    }
    
    //订单协议模板
    static var loanChannelSample: String {
        return "\(webServer)/loanChannel.html"
    }
    
    //订单协议(+ OrderId)
    static func loanChannelBy(orderId: String) -> String {
        return "\(webServer)/loanChannel.html?orderId=\(orderId)"
    }
    
    /// 投资人签名协议
    static func signUrlBy(orderId: String, token: String, languageId: String) -> String {
        return "\(loan)/signature/UpdateForm?orderId=\(orderId)&isNative=true&signToken=\(token)&languageId=\(languageId)"
    }
    
    /// 机构投资签名
    static func organUrlBy(orderId: String, token: String, languageId: String, type: String) -> String {
        return "\(loan)/signature/UpdateForm?orderId=\(orderId)&isNative=true&signToken=\(token)&languageId=\(languageId)&type=\(type)"
    }
    
    ///投资人签借款人协议
    /**
     测试：https://test-asetloan.asetku.com/management/v2/BatchSign?fundOrderId=xxxxx
     生产：https://asetloan.asetku.com/management/v2/BatchSign?fundOrderId=xxxx
     */
    static func batchSign(fundOrderId: String) -> String {
        return "\(batch)/management/v2/BatchSign?fundOrderId=\(fundOrderId)"
    }
    
    ///  实名认证vida协议
    /**
     测试：https://test-asetloan.asetku.com/management/v2/VidaContract
     uat：https://uat-asetloan.asetku.com/management/v2/VidaContract
     生产：https://asetloan.asetku.com/management/v2/VidaContract
     */
    static func kycVideUrl() -> String {
        return "\(batch)/management/v2/VidaContract"
    }
    
    //赠险页面
    static var giftInsurancePage: String {
        return "\(webServer)/v2/Insurance/InActivityReceived"
    }
    
    //赠险协议
    static var giftInsurance: String {
        return "\(webServer)/v2/Insurance/FreeInsuranceAgreement"
    }
    
    //商业险协议
    static var commercialInsurance: String {
        return "\(webServer)/v2/Insurance/CommercialInsuranceAgreement"
    }
    
    //新冠险协议1
    static var covid2019_1: String {
        return "\(webServer)/v2/Insurance/NewCrownAgreement"
    }
    
    //新冠险协议2
    static var covid2019_2: String {
        return "\(webServer)/v2/Insurance/NewCrownhealthStatement"
    }
    
    static var insuranceService: String {
        return "\(webServer)/v2/Insurance/service"
    }
    
    static var finance: String {
        return "\(webServer)/finance/Finance/list?startAnimation=1"
    }
    
    //黄金购买协议
    static var goldAgreement: String {
        return "\(webServer)/v2/goldtrading/agreement"
    }
    
    static var AFPI: String {
        return "\(webServer)/showAFPI.html"
    }
    
    //p2p税号协议页面
    static var taxIdAgreement: String {
        return "\(webServer)/v2/npwp/agreement"
    }
    
    //p2p税号信息提交页
    static var taxIdSubmitInfo: String {
        return "\(webServer)/v2/npwp/information"
    }
    
    static var contactUs: String {
        return "\(webServer)/contactUs.html"
    }
    
    static var appStore: String {
        return "https://itunes.apple.com/cn/app/id1300452602"
    }
    
    //授权登录协议
    static var authProtocol: String {
        return "\(webServer)/v2/AuthLogin/AuthorizeAgreement?fromPage=appAuthLogin"
    }
    
    // 唤起OneAset原生App Url
    static var oneAset: String {
        #if DEBUG
        return "oneaset-test"
        #else
        return "oneaset"
        #endif
    }
    
}

public extension ZJUrl {
    
    /// 未绑定RM页面，统一跳转聊天入口
    static func chat() -> String {
        return ZJUrl.webServer + "/v2/CSContact"
    }

    /// 已绑定RM页面，点击跳转与RM的聊天窗口
    static func rmChat() -> String {
        return ZJUrl.webServer + "/v2/Chatroom"
    }
    
    /// 未绑定绑定RM，会话页面
    static func conversation(longConversationId: String, targetUid: String) -> String {
        return ZJUrl.webServer + "/v2/Chatroom?longConversationId=\(longConversationId)&targetUid=\(targetUid)"
    }
    
    /// 绑定RM，会话页面
    static func rmConversation(longConversationId: String, targetUid: String) -> String {
        return ZJUrl.webServer + "/v2/Chatroom?longConversationId=\(longConversationId)&targetUid=\(targetUid)&rm=1"
    }
    
}

public extension ZJUrl {
    
    static var borrowUrl: String {
        #if DEBUG
        return Environment.current.borrowUrl
        #else
        return "https://cash.asetku.co.id/h5-loan/thirdparty"
        #endif
    }
    
}
