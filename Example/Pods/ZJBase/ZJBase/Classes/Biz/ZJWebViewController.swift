//
//  ZJWebViewController.swift
//  ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import UIKit
import WebKit
import SDWebImage

open class ZJWebViewController: ZJViewController {
    
    /// 弹起键盘是否缩小webview的frame 默认关闭
    private var inputViewShrinkIsOpen = false
    
    public final var displaysWebViewTitle = true
    
    var iOS12: Bool { ProcessInfo.processInfo.operatingSystemVersion.majorVersion == 12 }
    
    private var keyBoardPoint: CGPoint?
    
    private var leftButtonItemJSFunc: String?
        
    private var rightButtonItemJSFunc: String?
    
    private var callBackFuncName: String?
        
    private var isNavigationBarHidden = false {
        didSet {
            if oldValue != isNavigationBarHidden {
                navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
                updateLayout()
            }
        }
    }
    
    private var isImmersive = false {
        didSet {
            if oldValue != isImmersive {
                navigationController?.navigationBar.isTranslucent = isImmersive
                updateLayout()
            }
        }
    }
    
    private var navigationBarStyle: NavigationBarStyle = .default {
        didSet {
            switch navigationBarStyle {
            case .default:
                changeNavigationBarBackgroundWith(color: .white)
                navigationController?.navigationBar.shadowImage = UIImage(color: UIColor(hexString: "#EDEDED"),
                                                                          size: .init(width: 1, height: 0.4))
            case .custom(let color):
                changeNavigationBarBackgroundWith(color: color)
                navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
    }
    
    private var navigationTextStyle: NavigationTextStyle? {
        didSet {
            if navigationTextStyle != oldValue {
                setNeedsStatusBarAppearanceUpdate()
                navigationItem.leftBarButtonItem?.tintColor = navigationTextStyle?.tintColor
                let textColor: UIColor
                if let color = navigationTextStyle?.textColor {
                    textColor = color
                } else {
                    textColor = .black
                }
                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor,
                                                                           .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
            }
        }
    }
    
    // MARK: - Lazy Load
    public final var webView: WKWebView { get { _webView } }
    
    public final var progressBar: UIProgressView { get { _progressBar } }
    
    public final var urlRequest: URLRequest { didSet { webView.load(urlRequest) } }
    
    private lazy final var _webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.addObserver(self, forKeyPath: String.titleKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: String.estimatedProgressKeyPath, options: .new, context: nil)
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = true
        }
        return webView
    }()
    
    private let configuration: WKWebViewConfiguration
    
    private lazy final var _progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.backgroundColor = .clear
        progressBar.trackTintColor = .clear
        progressBar.progressTintColor = UIColor(hexString: "#FFA138")
        return progressBar
    }()
    
    private lazy var scriptMessageHandler = ZJWebViewScriptMessageHandler(scripts: ZJWebViewController.scriptTable.keys.map{$0}) { [unowned self] in
        self.handlerAction($0)
    }
    
    // MARK: - Init Method
    public init(urlRequest: URLRequest, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        configuration.mediaTypesRequiringUserActionForPlayback = .audio
        configuration.allowsInlineMediaPlayback = true
        self.configuration = configuration
        self.urlRequest = urlRequest
        super.init(nibName: nil, bundle: nil)
        scriptMessageHandler.addScriptMessageHandler(for: configuration)
        addUserScript()
    }
    
    public convenience init(url: URL) {
        self.init(urlRequest: URLRequest(url: url))
    }
    
    required public init?(coder: NSCoder) {
        self.urlRequest = URLRequest(url: URL(string: "http://")!)
        self.configuration = WKWebViewConfiguration()
        self.configuration.mediaTypesRequiringUserActionForPlayback = .audio
        self.configuration.allowsInlineMediaPlayback = true
        super.init(coder: coder)
        scriptMessageHandler.addScriptMessageHandler(for: configuration)
        addUserScript()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
        setupViews()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    // MARK: - KVO
    override open func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        
        guard let theKeyPath = keyPath , object as? WKWebView == webView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if displaysWebViewTitle && theKeyPath == String.titleKeyPath {
            navigationItem.title = webView.title
        }
        
        if theKeyPath == String.estimatedProgressKeyPath {
            updateProgress()
        }
        
    }
    
    deinit {
        scriptMessageHandler.removeScriptMessageHandler(for: configuration)
        webView.removeObserver(self, forKeyPath: String.titleKeyPath)
        webView.removeObserver(self, forKeyPath: String.estimatedProgressKeyPath)
        NotificationCenter.default.removeObserver(self)
    }
    
}

private extension ZJWebViewController {
    
    func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow(noty:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHide(noty:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func setupViews() {
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(webView)
        view.addSubview(progressBar)
        webView.load(urlRequest)
        navigationItem.leftBarButtonItem = rt_customBackItem(withTarget: self, action: #selector(handleLeftItemClick))
    
    }
    
    func updateLayout() {
        
        webView.frame = view.bounds
        let top: CGFloat
        if isNavigationBarHidden || isImmersive {
            top = 0
        } else {
            let isIOS11 = ProcessInfo.processInfo.isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0))
            top = isIOS11 ? CGFloat(0.0) : topLayoutGuide.length
        }

        let insets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        webView.scrollView.contentInset = insets
        webView.scrollView.scrollIndicatorInsets = insets
        view.bringSubview(toFront: progressBar)
        progressBar.frame = .init(x: view.frame.minX, y: topLayoutGuide.length, width: view.frame.width, height: 2)
        
    }
    
    func updateProgress() {
        
        let completed = webView.estimatedProgress == 1.0
        progressBar.setProgress(completed ? 0.0 : Float(webView.estimatedProgress), animated: !completed)
        UIApplication.shared.isNetworkActivityIndicatorVisible = !completed
        
    }
    
    @objc func keyBoardShow(noty: Notification) {
        
        if inputViewShrinkIsOpen {
            guard let userInfo = noty.userInfo else { return }
            let value = userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue
            let keyboardRect = value.cgRectValue
            let keyboradHeigt = keyboardRect.size.height
            webView.scrollView.isScrollEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.view.frame = .init(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight - keyboradHeigt)
            }
        }
        
        if iOS12 {
            keyBoardPoint = webView.scrollView.contentOffset
        }
        
    }
    
    @objc func keyBoardHide(noty: Notification) {
        
        if inputViewShrinkIsOpen {
            
            UIView.animate(withDuration: 0.2) {
                self.view.frame = UIScreen.main.bounds
            }
            webView.scrollView.isScrollEnabled = true
        }
        
        if iOS12, let point = keyBoardPoint {
            webView.scrollView.contentOffset = point
        }
        
    }
    
    @objc func handleLeftItemClick() {
        
        func back() {
            
            guard let _ = self.presentingViewController else {
                navigationController?.popViewController(animated: true)
                return
            }
            
            dismiss(animated: true)
            
        }
        
    }
    
    
}

private extension ZJWebViewController {
    
    private static var scriptTable = [String: ZJWebViewScriptInvoker]()
    
    private static var userScripts = [() -> WKUserScript?]()
    
    func addUserScript() {
        fixUserAgent()
        ZJWebViewController.userScripts.compactMap { $0() }.forEach { configuration.userContentController.addUserScript($0) }
    }
    
    func fixUserAgent() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] in
                self?.webView.customUserAgent = ($0 as? String)?.replacingOccurrences(of: "iPad", with: "iPhone")
                if let err = $1 { debugPrint(err) }
            }
        }
    }

}

private extension ZJWebViewController {
    
    func handlerAction(_ action: ZJWebViewScriptMessageHandler.Action) {
        
        switch action {
        case .setTitle(let title):
            self.navigationItem.title = title
        case .setNavigation(let params):
            self.handleSetNavigation(params: params)
        case .showRightItem(let title, let funcName, let color):
            self.handleSetRightItem(title: title, funcName: funcName, color: color)
        case .hideRightItem:
            self.navigationItem.rightBarButtonItem = nil
            self.rightButtonItemJSFunc = nil
        case .openWeb(let url, let funcName):
            navigationController?.pushViewController(ZJWebViewController(url: url), animated: true)
            callBackFuncName = funcName
        case .closeWeb:
            guard let _ = self.presentingViewController else {
                navigationController?.popViewController(animated: true)
                return
            }
            dismiss(animated: true)
        case .closeAllWeb:
            self.handleCloseAllWeb()
        case .leftItemHandle(let funcName):
            self.leftButtonItemJSFunc = funcName
        case .goBackHandle(let funcName):
            self.leftButtonItemJSFunc = funcName
        case .exitApp:
            break
        default:
            break
        }
        
    }

    /// * al_jsSetNavigation:设置沉侵式导航
    /*
     * isTransparent: 导航是否透明，默认是""不透明（兼容老版本）
     * setNavColor: 导航颜色（16进制色值），
     * rightStyle：右边按钮样式，默认“无”，（0，1：会员月报按钮）
     * callbackName：右边按钮事件
     * statusFontColor: 1,只有白和黑（1：白和2：黑）
     * isImmersive：是否开启沉侵式（1：是和0：否）
     * isOpenSpring: 是否开启ios弹簧（1：是和0：否）
     * isRemoveNav:去除导航栏（1：是和0：否）
     */
    func handleSetNavigation(params: [String: Any]) {
        
        if let bounces = params["isOpenSpring"] as? Int {
            webView.scrollView.bounces = bounces == 1 ? true : false
        } else {
            webView.scrollView.bounces = true
        }
        
        if let hideNavigationBar = params["isRemoveNav"] as? Int, hideNavigationBar == 1 {
            
            isPopGestureEnabled = true
            
        } else {
            
            isPopGestureEnabled = false
            
            if let immersive = params["isImmersive"] as? Int, immersive == 1 {
                isImmersive = true
            } else {
                isImmersive = false
            }
            
            if let color = params["setNavColor"] as? String {
                let colors = color.components(separatedBy: .init(charactersIn: ", ")).filter { !$0.isEmpty }.compactMap { Float($0) }
                if colors.count == 4 {
                    navigationBarStyle = .custom(color: .color(red: CGFloat(colors[0]),
                                                               green: CGFloat(colors[1]),
                                                               blue: CGFloat(colors[2]),
                                                               alpha: CGFloat(colors[3])))
                } else {
                    navigationBarStyle = .default
                }
            }
            
            navigationTextStyle = NavigationTextStyle(style: params["statusFontColor"] as? Int)
            
            if let rightIcon = params["rightStyle"] as? String, !rightIcon.isEmpty {
                SDWebImageDownloader.shared.downloadImage(with: URL(string: rightIcon)) { [weak self] (image, _, _, _) in
                    if let img = image {
                        self?.setRightItem(image: img)
                    }
                }
            } else {
                navigationItem.rightBarButtonItem = nil
            }
            
        }
        
    }
    
    func handleSetRightItem(title: String, funcName: String, color: String?) {
        navigationItem.rightBarButtonItem = nil
        rightButtonItemJSFunc = funcName
        if let rightColor = color {
            let rightBtn = UIButton(type: .custom)
            rightBtn.setTitle(title, for: .normal)
            rightBtn.titleLabel?.font = .systemFont(ofSize: 16)
            rightBtn.setTitleColor(UIColor(hexString: rightColor), for: .normal)
            rightBtn.addTarget(self, action: #selector(handleRightItemClick), for: .touchUpInside)
            navigationItem.rightBarButtonItem = .init(customView: rightBtn)
        } else {
            navigationItem.rightBarButtonItem = .init(title: title, style: .plain, target: self, action: #selector(handleRightItemClick))
        }
    }
    
    func setRightItem(image: UIImage) {
        navigationItem.rightBarButtonItem = nil
        let button = UIButton(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 25, height: 25)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleRightItemClick), for: .touchUpInside)
        let customView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
        customView.addSubview(button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    @objc func handleRightItemClick() {
        if var js = rightButtonItemJSFunc, !js.isEmpty {
            if !js.hasSuffix(")") || !js.hasSuffix("()"){
                js = js + "()"
            }
            webView.evaluateJavaScript(js)
        }
    }
    
    func handleCloseAllWeb() {
        
        guard let _ = self.presentingViewController else {
            if let controllers = navigationController?.viewControllers {
                var vc: UIViewController?
                for item in controllers.reversed() {
                    if !(item is ZJWebViewController) {
                        vc = item
                        break
                    }
                }
                if vc != nil {
                    navigationController?.popToViewController(vc!, animated: true)
                } else {
                    navigationController?.popToRootViewController(animated: true)
                }
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        
        dismiss(animated: true)
        
    }

}

private enum NavigationBarStyle {
    case `default`
    case custom(color: UIColor)
}

private enum NavigationTextStyle: Int {
    
    case light = 1
    case dark  = 2
    
    init?(style: Int?) {
        switch style {
        case 1: self = .light
        case 2: self = .dark
        default: return nil
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light: return .white
        case .dark: return .color(red: 62, green: 74, blue: 90)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light: return .white
        case .dark: return .black
        }
    }
    
}

private extension String {
    
    static var titleKeyPath: String {
        return "title"
    }
    
    static var estimatedProgressKeyPath: String {
        return "estimatedProgress"
    }
    
}

