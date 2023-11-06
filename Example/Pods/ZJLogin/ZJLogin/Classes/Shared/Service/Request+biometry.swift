//
//  Request+biometry.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/10.
//

import RxSwift
import HandyJSON
import ZJRequest
import LocalAuthentication

extension Request {
    enum biometry {}
}

extension Request.biometry {
    
    private static var notAvailableError: Error {
        if #available(iOS 11.0, *) {
            return NSError(domain: LAErrorDomain, code: LAError.biometryNotAvailable.rawValue)
        } else {
            return NSError(domain: LAErrorDomain, code: LAError.touchIDNotAvailable.rawValue)
        }
    }

    enum LoginResult {
        
        case success(Self.Data)
        case bizError(RequestError)
        case invalid(RequestError)
        
        struct Data: HandyJSON {
            var accessToken = ""
            var biometricsId = ""
            var isSetGesture = false
            mutating func mapping(mapper: HelpingMapper) {
                mapper <<< isSetGesture <-- "gesture"
            }
        }
        
    }
    
    static func login(account: String, id: String) -> Single<LoginResult> {
        
        guard let type = BiometricsType.current else { return .error(notAvailableError) }
        
        return API.checkBiometrics(account: account, biometricsType: type.rawValue, biometricsId: id).rx.request()
            .mapObject(ZJRequestResult<LoginResult.Data>.self)
            .map { root -> LoginResult in
                
                if root.success, let data = root.data, !data.biometricsId.isEmpty {
                    return .success(data)
                } else if root.errCode == "BIOMETRICS.0001" || root.errCode == "BIOMETRICS.0002" || root.errCode == "USER.0014" {
                    return .invalid(.init(code: root.errCode, msg: root.mappedMsg))
                } else {
                    return .bizError(.init(code: root.errCode, msg: root.mappedMsg))
                }
        
            }
        
    }
    
    static func fetchBiometricsId(account: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let type = BiometricsType.current else {
            completion(.failure(notAvailableError))
            return
        }
        
        API.fetchBiometricInfo(account: account, biometricsType: type.rawValue)
            .requestObject(success: { (root: ZJRequestResult<[String: Any]>) in
                
                if root.success, let id = root.data?["biometricsId"] as? String, !id.isEmpty {
                    completion(.success(id))
                } else {
                    completion(.failure(RequestError(code: root.errCode, msg: root.mappedMsg)))
                }
                
            },  failure: {
                completion(.failure($0))
            })
        
    }
    
    
}
