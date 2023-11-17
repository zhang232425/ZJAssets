//
//  API.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/8.
//

import Moya
import ZJRequest
import ZJCommonDefines

enum API {
    /// 我的资产
    case assetsBaseInfo
    /// 资产详情
    case assetsExtraInfo
    /// 我的资产 - 月收益走势
    case chartInfo
    /// 续投金额校验
    case investCheck
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
        }
    }
    
    var headers: [String : String]? { nil }
    
    var sampleData: Data { ".".data(using: .utf8)! }
    
    
}
