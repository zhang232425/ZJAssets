//
//  ZJRequestPlugin.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import Moya

struct ZJRequestPlugin: PluginType {
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        if case let .failure(error) = result {
            
            switch error {
            case .underlying(let error, let response):
                
                let nsError = (error as NSError)
                
                var userInfo = nsError.userInfo
                
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    userInfo[NSLocalizedDescriptionKey] = "The Internet connection appears to be offline."
                    return .failure(.underlying(NSError(domain: nsError.domain, code: nsError.code, userInfo: userInfo), response))
                    
                case NSURLErrorCancelled:
                    userInfo[NSLocalizedDescriptionKey] = "cancelled"
                    return .failure(.underlying(NSError(domain: nsError.domain, code: nsError.code, userInfo: userInfo), response))
                    
                default: break
                }
                
            default: break
            }
            
        }
        
        return result
        
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
        if case let .success(response) = result {
            
            switch response.statusCode {
            case 401:
                NotificationCenter.default.post(name: ZJRequest.statusCodeUnauthorizedNotification, object: nil)
            case 503:
                NotificationCenter.default.post(name: ZJRequest.statusCodeUnavailableNotification, object: nil)
            default:
                break
            }
            
        }
        
    }
    
}

public extension ZJRequest {
    
    static let statusCodeUnauthorizedNotification = Notification.Name(rawValue: "notification.name.as.request.unauthorized")
    
    static let statusCodeUnavailableNotification = Notification.Name(rawValue: "notification.name.as.request.unavailable")
    
}

