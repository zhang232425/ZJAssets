//
//  Request.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import ZJRequest
import ZJValidator

struct Request {}

struct RequestError: LocalizedError, CustomDebugStringConvertible {
    
    let code: String?
    let msg: String
    
    init(code: String?) {
        self.code = code
        self.msg = ""
    }
    
    init(msg: String) {
        self.code = nil
        self.msg = msg
    }
    
    init(code: String?, msg: String) {
        self.code = code
        self.msg = msg
    }
    
    var errorDescription: String? { msg }
    
    var debugDescription: String { "code:\(code ?? ""), msg:\(msg)" }
    
}

extension ZJRequestResult {
    
    var mappedMsg: String {
        ZJResponseCodeValidator.validate(success: success, code: errCode, msg: errMsg).message ?? ""
    }
    
}
