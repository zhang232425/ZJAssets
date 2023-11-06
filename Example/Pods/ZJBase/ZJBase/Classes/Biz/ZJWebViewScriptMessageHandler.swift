//
//  ZJWebViewScriptMessageHandler.swift
//  ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import Foundation
import WebKit

class ZJWebViewScriptMessageHandler: NSObject {
    
    /// 不存在
    enum JSMethod: String, CaseIterable {
        case setTitle           = "setTitleText"
        case alSetTitle         = "al_jsSetNavTitle"
        case setNavigation      = "al_jsSetNavigation"
        case showRightItem      = "al_jsShowTitleRightBtn"
        case hideRightItem      = "al_jsHideTitleRightBtn"
        case closeWeb           = "al_jsCloseCurrentWebview"
        case closeAllWeb        = "al_jsCloseAllWebview"
        case openWeb            = "al_jsCreateWebview"
        case leftItemHandle     = "al_jsIOSGoback"
        case goBackHandle       = "al_jsLeftHandle"
        case checkCamera        = "al_jsReadStorageAndCameraPermissions"
        case jumpNativeRouter   = "al_jsJumpNativeActivity"
        case inputViewShrink    = "al_jsInputViewShrink"
        case installAPP         = "al_jsCheckWhetherInstallAPP"
        case updateUserInfo     = "al_jsUpdateUserInfo"
        case pushNotification   = "al_jsPushNotification"
        case limitsCamera       = "al_jsReadCameraPermissions"
        case limitsAlbum        = "al_jsReadStoragePermissions"
        case borrowerCamera     = "al_jsRecordPermissions"
        case location           = "al_jsRequestGpsInfo"
        case deviceData         = "al_jsReportBaseInfo"
        case afiReportInfo      = "al_jsGetAfiReportInfo"
        case adjustReport       = "al_jsAdjustReport"
        case jumpNativeMain     = "al_jsJumpNativeMain"
        case exitApp            = "al_jsExitApp"
    }
    
    enum Action {
        case setTitle(String)
        case setNavigation([String: Any])
        case handleScriptMessage(WKScriptMessage)
        case showRightItem(title: String, funcName: String, color: String?)
        case hideRightItem
        case openWeb(url: URL, funcName: String?)
        case closeWeb
        case closeAllWeb
        case leftItemHandle(String?)
        case goBackHandle(String?)
        case jumpNativeRouter(nativeUrl: String, funcName: String?, callbackParam: String?)
        case checkCamera(String?)
        case inputViewShrink(Bool)
        case installApp(funcName: String?, pckName: String?)
        case updateUserInfo
        case pushNotification(String)
        case limitsCamera(String?)
        case borrowerCamera(String?)
        case limitsAlbum(String?)
        case location(String?)
        case deviceData(String?, String?)
        case afiReportInfo(String?, String?)
        case adjustReport(String?, String?)
        case jumpNativeMain
        case exitApp
    }
    
    private let scripts: [String]
    
    private let handler: (Action) -> ()
    
    init(scripts: [String], handler: @escaping (Action) -> ()) {
        self.scripts = scripts
        self.handler = handler
        super.init()
    }
    
    
}

extension ZJWebViewScriptMessageHandler {
    
    func serializeBody(_ body: Any) -> [String: Any]? {
        try! (body as? [String])?.first?.data(using: .utf8)?.jsonObject() as? [String: Any]
    }
    
    func addScriptMessageHandler(for configuration: WKWebViewConfiguration) {
        JSMethod.allCases.forEach { configuration.userContentController.add(self, name: $0.rawValue) }
        scripts.forEach { configuration.userContentController.add(self, name: $0) }
    }
    
    func removeScriptMessageHandler(for configuration: WKWebViewConfiguration) {
        JSMethod.allCases.forEach { configuration.userContentController.removeScriptMessageHandler(forName: $0.rawValue) }
        scripts.forEach { configuration.userContentController.removeScriptMessageHandler(forName: $0) }
    }
    
}

extension ZJWebViewScriptMessageHandler: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch JSMethod(rawValue: message.name) {
            
        case .setTitle:
            
            if let title = message.body as? String, !title.isEmpty {
                handler(.setTitle(title))
            }
            
        case .alSetTitle:
            
            if let dict = serializeBody(message.body), let title = dict["title"] as? String, !title.isEmpty {
                handler(.setTitle(title))
            }
            
        case .setNavigation:
            
            if let param = serializeBody(message.body) {
                handler(.setNavigation(param))
            }
            
        case .showRightItem:
            
            if let param = serializeBody(message.body), let title = param["rightTitle"] as? String, !title.isEmpty,
                let funcName = param["rightFunc"] as? String, !funcName.isEmpty {
                if let color = param["rightTextColor"] as? String {
                    handler(.showRightItem(title: title, funcName: funcName, color: color))
                } else {
                    handler(.showRightItem(title: title, funcName: funcName, color: nil))
                }
            }
            
        case .hideRightItem:
            handler(.hideRightItem)
            
        case .openWeb:
            
            if let dict = serializeBody(message.body), let urlStr = dict["newWebview"] as? String,
                !urlStr.isEmpty, let url = URL(string: urlStr) {
                handler(.openWeb(url: url, funcName: dict["callbackName"] as? String))
            }
            
        case .closeWeb:
            handler(.closeWeb)
            
        case .closeAllWeb:
            handler(.closeAllWeb)
            
        case .leftItemHandle:
            
            if let param = serializeBody(message.body), let isWebHandle = param["isWebHandle"] as? Bool, isWebHandle,
                let funcName = param["callbackName"] as? String, !funcName.isEmpty {
                handler(.leftItemHandle("\(funcName)()"))
            } else {
                handler(.leftItemHandle(nil))
            }
            
        case .goBackHandle:
            
            if let param = serializeBody(message.body), let isWebHandle = param["isWebHandle"] as? Bool, isWebHandle,
                let funcName = param["callbackName"] as? String, !funcName.isEmpty {
                handler(.goBackHandle("\(funcName)()"))
            } else {
                handler(.goBackHandle(nil))
            }
            
        default:
            break
            
            
        }
        
    }
    
}

