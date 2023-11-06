//
//  ZJUserProfileAPI.swift
//  Pods-ZJLoginManager_Example
//
//  Created by Jercan on 2023/9/11.
//

import Moya
import ZJRequest
import ZJCommonDefines

enum ZJUserProfileAPI {
    case fetch
}

extension ZJUserProfileAPI: ZJRequestTargetType {
    
    var baseURL: URL { return URL(string: ZJUrl.server)! }
    
    var path: String {
        switch self {
        case .fetch:
            return "/api/app/user/getUserDetail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? { nil }
    
    var sampleData: Data { ".".data(using: .utf8)! }
    
    
}
