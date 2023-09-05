//
//  ZJHUD.swift
//  Pods-ZJHUD_Example
//
//  Created by Jercan on 2022/10/20.
//

import NVActivityIndicatorView
import SnapKit
import ZJExtension
import UIKit

public final class ZJHUD {
    
    public enum HUDType {
        case `default`
        case dimBackground(color: UIColor?)
    }
    
    public enum HudPosition {
        case center
        case bottom
    }
    
    private var hud: ZJHUDView?
    
    private var toast: ZJHUDView?
    
    private static let shared = ZJHUD()
    
    private init() {}
    
}

public extension ZJHUD {
    
    static func showProgress(in view: UIView? = UIApplication.shared.keyWindow, type: HUDType = .default) {
        let hud = ZJHUDView()
        if case .dimBackground(let color) = type {
            hud.dimBackground = true
            hud.dimBackgroundColor = color
        }
        shared.hud?.hide()
        shared.hud = hud
        hud.showProgress(in: view)
    }
    
    static func showProgress(message: String?, in view: UIView? = UIApplication.shared.keyWindow, type: HUDType = .default) {
        let hud = ZJHUDView()
        if case .dimBackground(let color) = type {
            hud.dimBackground = true
            hud.dimBackgroundColor = color
        }
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        shared.hud?.hide()
        shared.hud = hud
        hud.showProgress(message: message, in: view)
    }
    
    static func show(message: String?, in view: UIView? = UIApplication.shared.keyWindow) {
        let toast = ZJHUDView()
        shared.toast?.hide()
        shared.toast = toast
        toast.show(message: message, image: nil, in: view)
    }
    
    //吐司成功
    static func showSuccess(message: String?, image: UIImage? = nil , delay: TimeInterval = 2, in view: UIView? = UIApplication.shared.keyWindow) {
        let toast = ZJHUDView()
        shared.toast?.hide()
        shared.toast = toast
        let showImage = image ?? UIImage.named("toast_success")
        toast.show(message: message, image: showImage, in: view)
        toast.hide(afterDelay: delay)
    }
    
    //吐司提示
    static func showTip(message: String?, image: UIImage? = nil , delay: TimeInterval = 2, in view: UIView? = UIApplication.shared.keyWindow) {
        let showImage = image ?? UIImage.named("toast_tip")
        showSuccess(message: message, image: showImage, delay: delay, in: view)
    }
    
    static func hideProgress(afterDelay delay: TimeInterval = 0) {
        delay > 0 ? shared.hud?.hide(afterDelay: delay) : shared.hud?.hide()
    }
    
    static func hideMessage(afterDelay delay: TimeInterval = 0) {
        delay > 0 ? shared.toast?.hide(afterDelay: delay) : shared.toast?.hide()
    }
    
    //吐司
    static func noticeOnlyText(_ text: String?, delay: TimeInterval = 2) {
        let toast = ZJHUDView()
        shared.toast?.hide()
        shared.toast = toast
        toast.show(message: text, image: nil)
        toast.hide(afterDelay: delay)
    }
    
    //底部吐司
    static func noticeOnlyTextBottom(_ text: String?, delay: TimeInterval = 2) {
        let toast = ZJHUDView()
        shared.toast?.hide()
        shared.toast = toast
        toast.show(message: text, image: nil, position: .bottom)
        toast.hide(afterDelay: delay)
    }
    
}

public final class ZJHUDView: UIView {
    
    private lazy var indicatorView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin)
    
    private var dimBackgroundView: UIView?
    
    private var imageView: UIImageView?
    
    public var dimBackground = true
    
    public var titleLabel: UILabel?
    
    public var dimBackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .init(white: 0, alpha: 0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if indicatorView.isAnimating {
            indicatorView.stopAnimating()
            indicatorView.startAnimating()
        }
    }
    
}

public extension ZJHUDView {
    
    func showProgress(in view: UIView? = UIApplication.shared.keyWindow) {
        
        guard let v = view else { return }
        subviews.forEach { $0.removeFromSuperview() }
        dimBackgroundView?.removeFromSuperview()
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        if dimBackground {
            let dimView = UIView()
            if let dimColor = dimBackgroundColor {
                dimView.backgroundColor = dimColor
            }
            dimView.addSubview(self)
            v.addSubview(dimView)
            dimBackgroundView = dimView
        } else {
            v.addSubview(self)
        }
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.width.height.equalTo(40)
        }
        
        snp.makeConstraints { $0.center.equalToSuperview() }
        dimBackgroundView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
    
    func showProgress(message: String?, in view: UIView? = UIApplication.shared.keyWindow) {
        
        guard let msg = message, !msg.isEmpty, let v = view else { return }
        subviews.forEach { $0.removeFromSuperview() }
        dimBackgroundView?.removeFromSuperview()
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        if dimBackground {
            
            let dimView = UIView()
            if let dimColor = dimBackgroundColor {
                dimView.backgroundColor = dimColor
            }
            dimView.addSubview(self)
            v.addSubview(dimView)
            dimBackgroundView = dimView
            
        } else {
            v.addSubview(self)
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        dimBackgroundView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = msg
        addSubview(label)
        v.addSubview(self)
        
        titleLabel = label
        
        label.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.width.greaterThanOrEqualTo(80)
            $0.height.greaterThanOrEqualTo(16)
        }
        
        snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
    }
    
}

public extension ZJHUDView {

    func show(message: String?, image: UIImage? = nil, position: ZJHUD.HudPosition = .center, in view: UIView? = UIApplication.shared.keyWindow) {

        guard let msg = message, !msg.isEmpty, let v = view else { return }
        subviews.forEach { $0.removeFromSuperview() }
        imageView?.removeFromSuperview()
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = msg
        addSubview(label)
        v.addSubview(self)
        
        titleLabel = label
        
        if let image = image {
            let theView = UIImageView()
            theView.image = image
            addSubview(theView)
            imageView = theView
            
            imageView!.snp.makeConstraints {
                $0.top.equalToSuperview().inset(18)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(32)
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(imageView!.snp.bottom).offset(8)
                $0.bottom.equalToSuperview().inset(14)
                $0.left.right.equalToSuperview().inset(14)
                $0.width.greaterThanOrEqualTo(80)
                $0.height.greaterThanOrEqualTo(16)
            }
            
        } else {
            label.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        }
        
        switch position {
        case .center:
            snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            }
        case .bottom:
            var bottomHeight: CGFloat = 90.0
            if #available(iOS 11.0, *) {
                bottomHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 90.0
            }
            snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(bottomHeight)
                $0.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            }
        }
        
    }
    
    func updateMsg(_ msg: String) {
        titleLabel?.text = msg
    }
}

public extension ZJHUDView {
    
    func hide() {
        indicatorView.stopAnimating()
        removeFromSuperview()
        dimBackgroundView?.removeFromSuperview()
    }
    
    func hide(afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { self.hide() }
    }
    
}
