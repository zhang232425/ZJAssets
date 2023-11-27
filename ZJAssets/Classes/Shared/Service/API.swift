//
//  API.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/8.
//

import Moya
import ZJRequest
import ZJCommonDefines
import ZJExtension

enum API {
    /// 我的资产
    case assetsBaseInfo
    /// 资产详情
    case assetsExtraInfo
    /// 我的资产 - 月收益走势
    case chartInfo
    /// 续投金额校验
    case investCheck
    /// 我的资产 - p2p 定期账户资金
    case depositAssets
    /// 我的资产 - p2p 定期订单列表
    case depositOrderList(page: Int?)
    /// p2p 定期收益明细
    case incomeList(page: Int?)
    /// 交易流水 - 筛选条件
    case filterCategory
    /// 交易流水 - 列表
    case progressTrade(TransactionParam)
    case historyTrade(TransactionParam)
    /// 旧版交易记录入口
    case oldOrderEntrance
}

extension API: ZJRequestTargetType {
    
    var baseURL: URL { URL(string: ZJUrl.server + "/api/app")! }
    
    var path: String {
        switch self {
        case .assetsBaseInfo:
            return "/assets/index"
        case .assetsExtraInfo:
            return "/biz/order/all/order/assets/detail/new"
        case .chartInfo:
            return "/biz/order/all/order/monthlyIncommeTrend"
        case .investCheck:
            return "/order/continue/verify"
        case .depositAssets:
            return "/biz/order/p2p/fiexed/overview"
        case .depositOrderList:
            return "/biz/order/p2p/fiexed/list/v2"
        case .incomeList:
            return "/biz/order/p2p/fiexed/incomeDetail"
        case .filterCategory:
            return "/biz/asset/trade/list/condition"
        case .progressTrade, .historyTrade:
            return "/biz/asset/trade/query/list"
        case .oldOrderEntrance:
            return "/biz/asset/trade/existHistoryRecord"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .assetsBaseInfo:
            return .get
        case .assetsExtraInfo:
            return .get
        case .chartInfo:
            return .get
        case .investCheck:
            return .post
        case .depositAssets:
            return .get
        case .depositOrderList:
            return .get
        case .incomeList:
            return .get
        case .filterCategory:
            return .get
        case .progressTrade:
            return .get
        case .historyTrade:
            return .get
        case .oldOrderEntrance:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .assetsBaseInfo:
            return .requestPlain
        case .assetsExtraInfo:
            return .requestPlain
        case .chartInfo:
            return .requestPlain
        case .investCheck:
            return .requestPlain
        case .depositAssets:
            return .requestPlain
        case .depositOrderList(let page):
            var params = [String: Any]()
            params["page"] = page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .incomeList(let page):
            var params = [String: Any]()
            params["page"] = page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .filterCategory:
            return .requestPlain
        case .progressTrade(let param):
            let json = (try? param.toJSONString()?.data(using: .utf8)?.jsonObject() as? [String: Any]) ?? [String: Any]()
            guard var dict = json else {
                var dict = [String: Any]()
                dict["statusGroup"] = 1
                return .requestParameters(parameters: dict, encoding: URLEncoding.default)
            }
            dict["statusGroup"] = 1
            return .requestParameters(parameters: dict, encoding: URLEncoding.default)
        case .historyTrade(let param):
            let json = (try? param.toJSONString()?.data(using: .utf8)?.jsonObject() as? [String: Any]) ?? [String: Any]()
            guard var dict = json else {
                var dict = [String: Any]()
                dict["statusGroup"] = 2
                return .requestParameters(parameters: dict, encoding: URLEncoding.default)
            }
            dict["statusGroup"] = 2
            return .requestParameters(parameters: dict, encoding: URLEncoding.default)
        case .oldOrderEntrance:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? { nil }
    
    var sampleData: Data { ".".data(using: .utf8)! }
    
}
