//
//  ZJRefreshHeader.swift
//  ESPullToRefresh
//
//  Created by Jercan on 2023/9/4.
//

import Foundation
import ESPullToRefresh

open class ZJRefreshHeader: UIView, ESRefreshAnimatorProtocol {
    
    public var view: UIView { return self }
    
    public var insets: UIEdgeInsets = .zero
    
    public var trigger: CGFloat = 60
    
    public var executeIncremental: CGFloat = 60
    
    public var state: ESRefreshViewState = .pullToRefresh
    
    private lazy var imageView = UIImageView()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "down", in: Bundle.framework_ZJRefresh, compatibleWith: nil)
        imageView.frame = .init(origin: .zero, size: imageView.image?.size ?? .zero)
        addSubview(imageView)
        addSubview(indicatorView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            indicatorView.center = center
            imageView.center = center
        }
    }
    
}

extension ZJRefreshHeader: ESRefreshProtocol {
    
    public final func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        imageView.isHidden = true
        imageView.transform = .init(rotationAngle: 0.000001 - CGFloat.pi)
    }
    
    public final func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        imageView.isHidden = false
        imageView.transform = .identity
    }
    
    public final func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {}
    
    public final func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        
        guard self.state != state else { return }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = .identity
            }) { _ in}
            
        case .releaseToRefresh:
            setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = .init(rotationAngle: 0.000001 - CGFloat.pi)
            }) { _ in}
            
        case .refreshing, .autoRefreshing:
            setNeedsLayout()
            
        default:
            break
        }
        
    }
    
}
