//
//  Request.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import ZJRequest
import ZJValidator
import RxSwift
import Moya
import SwiftyJSON

struct Request {
    
    /// 我的资产
    static func fetchAssetsBaseInfo() -> Observable<AssetsBaseInfo?> {
        API.assetsBaseInfo.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<AssetsBaseInfo>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 资产详情
    static func fetchAssetsExtraInfo() -> Observable<AssetsExtraInfo?> {
        API.assetsExtraInfo.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<AssetsExtraInfo>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 月收益走势
    static func fetchChartInfo() -> Observable<[ChartInfo]?> {
        API.chartInfo.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<ChartResult>.self)
            .asObservable()
            .map { $0.data?.items }
    }
    
    /// 续投金额校验
    static func investCheck() -> Observable<NSNumber?> {
        API.investCheck.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<NSNumber>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 我的资产 - p2p 定期账户资金
    static func fetchDepositAssets() -> Observable<DepositAssets?> {
        API.depositAssets.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<DepositAssets>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 我的资产 - p2p 定期订单列表
    static func fetchDepositOrderList(page: Int?) -> Observable<(DepositOrderPage?, NSNumber?)> {
        API.depositOrderList(page: page).rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<DepositOrderPage>.self)
            .asObservable()
            .map { ($0.data, $0.sysTime) }
    }
    
    /// p2p 定期收益明细
    static func fetchIncomeList(page: Int?) -> Observable<DepositIncomePage?> {
        API.incomeList(page: page).rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<DepositIncomePage>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 交易流水 - 列表
    static func fetchInProgressList(param: TransactionParam) -> Observable<TransactionListPage?> {
        API.progressTrade(param).rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<TransactionListPage>.self)
            .asObservable()
            .map { $0.data }
    }
    
    static func fetchHistoryList(param: TransactionParam) -> Observable<TransactionListPage?> {
        API.historyTrade(param).rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<TransactionListPage>.self)
            .asObservable()
            .map { $0.data }
    }
    
    /// 旧版交易记录入口
    static func showOldOrderEntrance() -> Observable<Bool> {
        API.oldOrderEntrance.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<TransactionOldEntrance>.self)
            .asObservable()
            .map { $0.data?.exist ?? false }
    }
    
    /// 交易流水 - 筛选条件
    static func fetchFilterCategory() -> Observable<FilterCategory?> {
        API.filterCategory.rx.request()
            .ensureResponseStatus()
            .mapObject(ZJRequestResult<FilterCategory>.self)
            .asObservable()
            .map { $0.data }
    }    
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func ensureResponseStatus() -> Single<JSON> {
        
        return mapSwiftyJSON().flatMap { (json) -> Single<JSON> in
            
            let result = ZJResponseCodeValidator.validate(success: json["success"].boolValue, code: json["errCode"].string, msg: json["errMsg"].string)
            
            guard result.success else {
                
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = result.message
                
                userInfo["errorCode"] = result.code
                
                throw NSError(domain: "RequestFailureDomain", code: -1, userInfo: userInfo)
                
            }
            
            return .just(json)
            
        }
        
    }
    
}
