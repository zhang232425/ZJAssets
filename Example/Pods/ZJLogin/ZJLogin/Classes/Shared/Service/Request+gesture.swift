//
//  Request+gesture.swift
//  ZJLogin
//
//  Created by Jercan on 2023/10/13.
//

import Foundation
import ZJRequest
import ZJHUD
import HandyJSON

typealias CallBack<T> = (ZJRequestResult<T>?, String?) -> Void

extension Request {
    
    /// 设置手势密码
    static func setGesture(gesture: String, loginPwd: String, callBack: @escaping (CallBack<String>)) {
        
        API.setGesture(gesture: gesture, loginPwd: loginPwd).requestObject(path: nil, success: { (response: ZJRequestResult<String>) in
            
            callBack(response, nil)
            
        }, failure: {
            
            callBack(nil, $0.localizedDescription)
            
        })
        
    }
    
}
