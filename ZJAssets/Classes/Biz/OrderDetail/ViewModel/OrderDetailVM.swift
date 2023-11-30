//
//  OrderDetailVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation
import Action
import RxSwift
import RxCocoa

/**
 请求地址：https://test-app.asetku.com/api/app/order/continue/toggle/btn
 请求类型：POST
 请求参数：["orderId": "25185455"]
 请求成功：
 {
     errCode = "ORDER.0250";
     errMsg = "The order is matured, you can't operate the button now.";
     success = 0;
     sysTime = 1701327020060;
 }
 
 {
     data =     {
         content = (
                         {
                 businessType = 2;
                 initTime = 1685275201756;
                 isShowExpired = 0;
                 jumpType = 3001;
                 productCode = "";
                 refId = 7021926;
                 status = 3000;
                 statusMsg = Successful;
                 subject = "Total Balance Withdraw";
                 tradeAmount = 1040200;
                 transactionId = 20056889;
                 typeMsg = Withdraw;
             },
                         {
                 businessType = 1;
                 initTime = 1681723144473;
                 isShowExpired = 0;
                 jumpType = 1001;
                 productCode = 9954847;
                 productId = 9954847;
                 refId = 25185392;
                 status = 3000;
                 statusMsg = Successful;
                 subject = "Pendanaan Super 30 Hari-\U63d0\U524d\U56de\U6b3e";
                 tradeAmount = 515000;
                 transactionId = 20056383;
                 typeMsg = Purchase;
             }
         );
         nextPage = 2;
     };
     success = 1;
     sysTime = 1701327017969;
 }

 
 {
     data =     {
         exist = 0;
     };
     success = 1;
     sysTime = 1701327017893;
 }

 */

final class OrderDetailVM {
    
    enum SectionItem {
        case noSignal
        case sepector
        case transaction(OrderDetailTransactionInfo)
        case remainPlan(OrderDetailRemainPlanInfo, Bool, Bool)
        case principal(OrderDetailPrincipalInfo, Bool)
        case rate(OrderDetailItemInfo)
        case backPlans(OrderDetailBackPlansInfo, Bool, Bool, Bool)
        case head(OrderDetailHeadInfo)
        case tax(OrderDetailItemInfo, Bool)
        case insureAmount(OrderDetailTwoRowInfo)
//        case autoLend(OrderDetailFixedAutoInfo)
        case coupon(OrderDetailCouponInfo)
        case createTime(OrderDetailItemInfo)
        case tenor(OrderDetailItemInfo)
        case endTime(OrderDetailItemInfo)
        case endTimeQuestion(OrderDetailQuestionInfo)
        case withdraw(OrderDetailQuestionInfo)
        case bank(OrderDetailItemSelectInfo)
        case borrower(OrderDetailItemSelectInfo)
        case contract(OrderDetailItemSelectInfo)
        case agreement(OrderDetailAgreementInfo)
    }
    
    private(set) lazy var fetchAction: CocoaAction = .init { [weak self] in
        self?.fetchData() ?? .just(())
    }
    
    private(set) lazy var transcationRecordAction: Action<(String), TranscationRecordAlertResult?> = .init {
        Request.orderHistory(orderId: $0)
    }
    
    private var transcationRecord: TranscationRecordAlertResult?
    
    var title: String { model.name }
    
    private(set) var datas = BehaviorRelay(value: [SectionItem]())
    
    private(set) var productId: String? = nil
    
    private(set) var orderId: String
    
    private(set) var model = OrderModel()
    
    init(productId: String?, orderId: String) {
        self.productId = productId
        self.orderId = orderId
    }
    
}

private extension OrderDetailVM {
    
    /**
    func fetchDatas() -> Observable<Void> {
        Observable.zip(Request.getOrderDetail(orderId: orderId),
                       Request.toggleAutoLend(orderId: orderId))
        .map { self.buildSections(detail: $0, toggle: $1) }
    }
    
    func buildSections(detail: OrderModel?, toggle: Bool?) {
        
        guard let model = detail else {
            datas.accept([.noSignal])
            return
        }
        
        var contents = [SectionItem]()
        
        /// 交易记录
        contents.append(.transaction(getTransactionInfo(model)))
        
        datas.accept(contents)
        
    }
     */
    
    func fetchData() -> Observable<Void> {
        Request.getOrderDetail(orderId: orderId).map { self.buildSections(response: $0) }
    }
    
    func buildSections(response: OrderModel?) {
        
        guard let model = response else {
            datas.accept([.noSignal])
            return
        }
        
        self.model = model
        
        var contents = [SectionItem]()
        
        /// 交易记录
        contents.append(.transaction(getTransactionInfo(model)))
        
        datas.accept(contents)
        
    }
    
}

extension OrderDetailVM {
    
    func getTranscationRecords() -> TranscationRecordAlertResult? {
        
        /// 首次获取，网络请求
        guard transcationRecord != nil else {
            transcationRecordAction.execute(orderId)
            return nil
        }
        
        return transcationRecord
        
    }
    
}
