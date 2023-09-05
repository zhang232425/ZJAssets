//
//  Moya+ZJRequset.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import Moya
import HandyJSON
import SwiftyJSON

public extension ZJRequestTargetType {
    
    typealias Progress = (ProgressResponse) -> ()
    
    typealias Failure = (Error) -> ()
    
    @discardableResult
    func request(success: ((Response) -> ())? = nil,
                 progress: Progress? = nil,
                 failure: Failure? = nil) -> Cancellable {
        
        let provider: MoyaProvider<MultiTarget> = ZJRequest.generateProvider(behavior: stubBehavior,
                                                                             plugins: plugins,
                                                                             timeoutInterval: timeoutInterval,
                                                                             callbackQueue: callbackQueue)
        
        return provider.request(MultiTarget(self), progress: progress) {
            
            switch $0 {
            case let .success(response):
                
                do {
                    success?(try response._filterHTTPStatusCodes())
                } catch {
                    failure?(error)
                }
                
            case let .failure(error):
                failure?(error)
            }
            
        }
        
    }
    
    @discardableResult
    func requestJSON(success: ((JSON) -> ())? = nil,
                     progress: Progress? = nil,
                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapSwiftyJSON())
            } catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObject<T: HandyJSON>(path: String? = nil,
                                     success: ((T) -> ())? = nil,
                                     progress: Progress? = nil,
                                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObject(T.self, path: path))
            } catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObjectArray<T: HandyJSON>(path: String? = nil,
                                          success: (([T]) -> ())? = nil,
                                          progress: Progress? = nil,
                                          failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObjectArray(T.self, path: path))
            } catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
}

extension Moya.Response {
    
    func _mapSwiftyJSON() throws -> JSON {
        try JSON(data: data)
    }
    
    func _mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> T {
        guard let jsonString = String(data: data, encoding: .utf8),
            let object = JSONDeserializer<T>
                .deserializeFrom(json: jsonString, designatedPath: path) else {
                    throw MoyaError.stringMapping(self)
        }
        return object
    }
    
    func _mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> [T] {
        guard let jsonString = String(data: data, encoding: .utf8),
            let objectArray = JSONDeserializer<T>
                .deserializeModelArrayFrom(json: jsonString, designatedPath: path) as? [T] else {
                    throw MoyaError.stringMapping(self)
        }
        return objectArray
    }
    
    func _filterHTTPStatusCodes() throws -> Response {
        try _filter(successCodes: 200...299)
    }
    
}

private extension Response {
    
    func _filter(successCodes: ClosedRange<Int>) throws -> Response {
        
        guard successCodes.contains(statusCode) else {
            
            switch statusCode {
            case 401:
                throw CodeError.code401
            case 503:
                throw CodeError.code503
            case 400...499:
                throw CodeError.code4xx(statusCode)
            case 500...599:
                throw CodeError.code5xx(statusCode)
            default:
                throw MoyaError.statusCode(self)
            }
            
        }
        
        return self
        
    }
    
}

private enum CodeError: LocalizedError {
    
    case code401
    case code503
    case code4xx(Int)
    case code5xx(Int)
    
    var errorDescription: String? {
        switch self {
        case .code4xx(let code):
            return "\(ZJRequestLocale.codeError4xx.localized)(\(code))"
        case .code5xx(let code):
            return "\(ZJRequestLocale.codeError5xx.localized)(\(code))"
        default:
            return ""
        }
    }
    
}
