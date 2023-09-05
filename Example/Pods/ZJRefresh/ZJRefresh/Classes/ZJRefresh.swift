//
//  ZJRefresh.swift
//  ESPullToRefresh
//
//  Created by Jercan on 2023/9/4.
//

import ESPullToRefresh

public extension UIScrollView {
    
    func addPullToRefresh(_ action: @escaping () -> ())  {
        es.addPullToRefresh(animator: ZJRefreshHeader(), handler: action)
    }
    
    func addInfinityScroll(info: ZJRefreshInfo? = nil, _ action: @escaping () -> ())  {
        es.addInfiniteScrolling(animator: ZJRefreshFooter(info: info), handler: action)
    }
    
    func beginPullToRefresh() {
        es.startPullToRefresh()
    }
    
    func endPullToRefresh() {
        es.stopPullToRefresh()
    }
    
    func removePullToRefresh() {
        es.removeRefreshHeader()
    }
    
    func endInfinityScroll() {
        es.stopLoadingMore()
    }
    
    func removeInfinityScroll() {
        es.removeRefreshFooter()
    }
    
    func stopPullToRefresh() {
        header?.isHidden = true
        es.stopPullToRefresh()
    }
    
    func resetPullToRefresh() {
        header?.isHidden = false
    }
    
    func noticeNoMoreData() {
        footer?.isHidden = true
        es.noticeNoMoreData()
    }
    
    func noticeTipNoMoreData() {
        footer?.isHidden = false
        footer?.alpha = 1.0
        es.noticeNoMoreData()
    }
    
    func resetNoMoreData() {
        footer?.isHidden = false
        es.resetNoMoreData()
    }
    
}
