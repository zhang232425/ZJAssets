//
//  ZJRequest.swift
//  Pods-ZJRequest_Example
//
//  Created by Jercan on 2022/10/17.
//

import Moya
import Alamofire
import ZJDevice
import ZJRegion

public final class ZJRequest {
    
    public enum AcceptLanguage: String {
        // 英语
        case en = "102"
        // 印尼语
        case id = "123"
    }
    
    private class CustomServerTrustPoliceManager : ServerTrustManager {
        
        override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
            #if DEBUG
            return DisabledTrustEvaluator()
            #else
            return DefaultTrustEvaluator(validateHost: true)
            #endif
        }
        
        init() {
            super.init(evaluators: [:])
        }
        
    }
    
    private static var httpHeaders: HTTPHeaders = {
        
        let device = ZJDevice()
        
        var headers = HTTPHeaders()
        headers["deviceType"]     = device.deviceType
        headers["appVersion"]     = device.appVersion
        headers["vc"]             = device.appVersion
        headers["appVersionCode"] = device.build
        headers["osVersion"]      = device.systemVersion
        headers["deviceId"]       = device.deviceId
        headers["languageId"]     = languageId.rawValue
        headers["countryId"]      = ZJRegion.current.id
        headers["Authorization"]  = accessToken ?? ""
        headers["deviceToken"]    = deviceToken ?? ""
        
        return headers
        
    }()
    
    public static var accessToken: String? {
        didSet { httpHeaders["Authorization"] = accessToken ?? "" }
    }
    
    public static var languageId = AcceptLanguage.en {
        didSet { httpHeaders["languageId"] = languageId.rawValue }
    }
    
    public static var deviceToken: String? {
        didSet { httpHeaders["deviceToken"] = deviceToken ?? "" }
    }
    
}

extension ZJRequest {
    
    static func generateProvider<T: TargetType>(behavior: StubBehavior,
                                                plugins: [PluginType],
                                                timeoutInterval: TimeInterval,
                                                callbackQueue: DispatchQueue?) -> MoyaProvider<T> {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = httpHeaders.dictionary
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = timeoutInterval
        
        let session = Session(configuration: configuration,
                              serverTrustManager: CustomServerTrustPoliceManager())
        
        var moyaPlugins = plugins
        
        moyaPlugins.append(ZJRequestPlugin())
        moyaPlugins.append(ZJRequestPrintPlugin())
        
        return MoyaProvider<T>(stubClosure: { _ in behavior },
                               callbackQueue: callbackQueue,
                               session: session,
                               plugins: moyaPlugins)
        
    }
    
}
