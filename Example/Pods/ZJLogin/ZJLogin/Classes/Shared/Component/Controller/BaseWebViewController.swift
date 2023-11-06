//
//  BaseWebViewController.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/19.
//

import WebKit
import ZJBase

enum ZJLoginJSMethod: String, CaseIterable {
    case finishRegisterProtocol = "al_jsFinishProtocol"
}

class BaseWebViewController: ZJWebViewController {
    
    private let configuration: WKWebViewConfiguration
    
    private var scriptTable = [String: ((WKWebView, WKScriptMessage) -> Void)]()
    
    private lazy var messageHandler = WebViewScriptMessageHandler { [weak self] message in
        let callBack = self?.scriptTable[message.name]
        if let webView = self?.webView {
            callBack?(webView, message)
        }
    }
    
    override init(urlRequest: URLRequest, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        self.configuration = configuration
        super.init(urlRequest: urlRequest, configuration: configuration)
        messageHandler.addScriptMessageHandler(for: configuration)
    }
    
    required init?(coder: NSCoder) {
        self.configuration = WKWebViewConfiguration()
        super.init(coder: coder)
        messageHandler.addScriptMessageHandler(for: configuration)
    }
    
    deinit {
        messageHandler.removeScriptMessageHandler(for: configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progressTintColor = UIColor(hexString: "#FFA138")
        view.backgroundColor = .white
        displaysWebViewTitle = true
    }
    
}

extension BaseWebViewController {
    
    func registerScript(_ method: String, handler: @escaping (WKWebView, WKScriptMessage) -> Void) {
        scriptTable[method] = handler
    }
    
}

private class WebViewScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    private let handler: (WKScriptMessage) -> Void
    
    init(handler: @escaping (WKScriptMessage) -> Void) {
        self.handler = handler
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handler(message)
    }
    
    func addScriptMessageHandler(for configuration: WKWebViewConfiguration) {
        ZJLoginJSMethod.allCases.forEach {
            configuration.userContentController.add(self, name: $0.rawValue)
        }
    }
    
    func removeScriptMessageHandler(for configuration: WKWebViewConfiguration) {
        ZJLoginJSMethod.allCases.forEach {
            configuration.userContentController.removeScriptMessageHandler(forName: $0.rawValue)
        }
    }
    
}
