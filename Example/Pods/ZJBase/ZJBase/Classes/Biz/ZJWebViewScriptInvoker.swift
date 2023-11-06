//
//  ZJWebViewScriptInvoker.swift
//  ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import Foundation
import WebKit

struct ZJWebViewScriptInvoker {
    
    /// 不存在
    private let handler: (WKWebView, WKScriptMessage) -> ()
    
    init(handler: @escaping (WKWebView, WKScriptMessage) -> ()) {
        self.handler = handler
    }
    
    func invoke(with webView: WKWebView, message: WKScriptMessage) {
        handler(webView, message)
    }
    
}
