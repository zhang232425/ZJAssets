//
//  ZJRefreshFooter.swift
//  ZJRefresh
//
//  Created by Jercan on 2023/9/4.
//

import Foundation
import ESPullToRefresh

open class ZJRefreshFooter: UIView, ESRefreshAnimatorProtocol {
    
    public var view: UIView { return self }
    
    public var insets: UIEdgeInsets = .zero
    
    public var trigger: CGFloat = 60
    
    public var executeIncremental: CGFloat = 60
    
    public var state: ESPullToRefresh.ESRefreshViewState = .pullToRefresh
    
    private var refreshInfo: ZJRefreshInfo?
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    init(info: ZJRefreshInfo? = nil) {
        super.init(frame: .zero)
        refreshInfo = info
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        titleLabel.sizeToFit()
        if let title = titleLabel.text, title.count > 0 {
            titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0 - 5.0)
            indicatorView.center = CGPoint(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
        } else {
            indicatorView.center = center
        }
    }
    
}

extension ZJRefreshFooter: ESRefreshProtocol {
    
    public func refreshAnimationBegin(view: ESPullToRefresh.ESRefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = refreshInfo?.loadingDescription
        indicatorView.isHidden = false
    }
    
    public func refreshAnimationEnd(view: ESPullToRefresh.ESRefreshComponent) {
        indicatorView.stopAnimating()
        titleLabel.text = refreshInfo?.loadingMoreDescription
        indicatorView.isHidden = true
    }
    
    public func refresh(view: ESPullToRefresh.ESRefreshComponent, progressDidChange progress: CGFloat) {}
    
    public func refresh(view: ESPullToRefresh.ESRefreshComponent, stateDidChange state: ESPullToRefresh.ESRefreshViewState) {
        
        guard self.state != state else { return }
        
        self.state = state
        
        switch state {
        case .pullToRefresh:
            titleLabel.text = refreshInfo?.loadingMoreDescription
            break
        
        case .refreshing, .autoRefreshing:
            titleLabel.text = refreshInfo?.loadingDescription
            break
            
        case .noMoreData:
            titleLabel.text = refreshInfo?.loadingMoreDescription
            break
            
        default:
            break
            
        }
        
        setNeedsLayout()
        
    }
    
}

