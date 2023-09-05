//
//  Moya+Rx.swift
//  Pods-ZJRequest_Example
//
//  Created by Jercan on 2022/10/17.
//

import Moya
import RxSwift
import HandyJSON
import SwiftyJSON

public extension Reactive where Base: ZJRequestTargetType {
    
    func request() -> Single<Response> {
        
        let provider: MoyaProvider<MultiTarget> = ZJRequest.generateProvider(behavior: base.stubBehavior,
                                                                             plugins: base.plugins,
                                                                             timeoutInterval: base.timeoutInterval,
                                                                             callbackQueue: base.callbackQueue)
        
        return Single.just(MultiTarget(base)).flatMap { provider.rx.request($0) }.filterHTTPStatusCodes()
        
    }
    
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func mapSwiftyJSON() -> Single<JSON> {
        flatMap { .just(try $0._mapSwiftyJSON()) }
    }
    
    func mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<T> {
        flatMap { .just(try $0._mapObject(T.self, path: path)) }
    }
    
    func mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        flatMap { .just(try $0._mapObjectArray(T.self, path: path)) }
    }
    
    func filterHTTPStatusCodes() -> Single<Element> {
        flatMap { .just(try $0._filterHTTPStatusCodes() ) }
    }
    
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == JSON {
    
    func mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<T> {
        flatMap { .just(try $0._mapObject(T.self, path: path)) }
    }
    
    func mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        flatMap { .just(try $0._mapObjectArray(T.self, path: path)) }
    }
    
}

extension JSON {
    
    func _mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> T {
        guard let model = JSONDeserializer<T>
            .deserializeFrom(dict: dictionaryObject, designatedPath: path) else {
                throw JSONMapError.objectMapping
        }
        return model
    }
    
    func _mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> [T] {
        guard let modelArray = JSONDeserializer<T>
            .deserializeModelArrayFrom(json: rawString(), designatedPath: path) as? [T] else {
                throw JSONMapError.objectArrayMapping
        }
        return modelArray
    }
    
}

enum JSONMapError: LocalizedError {
    
    case objectMapping
    case objectArrayMapping
    
    public var errorDescription: String? {
        switch self {
        case .objectMapping:
            return "Failed to map data to object."
        case .objectArrayMapping:
            return "Failed to map data to objectArray."
        }
    }
    
}
