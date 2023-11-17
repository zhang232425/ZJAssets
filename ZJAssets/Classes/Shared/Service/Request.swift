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
