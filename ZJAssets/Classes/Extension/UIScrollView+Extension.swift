//
//  UIScrollView+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import RxSwift
import RxCocoa
import ZJRefresh

extension Reactive where Base: UIScrollView {

    var addPullToRefresh: Observable<()> {
        
        .create { [weak base] (observer) -> Disposable in
            
            if let base = base {
                base.addPullToRefresh {
                    observer.onNext(())
                }
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create {
                base?.endPullToRefresh()
            }
            
        }
        
    }
    
    var addInfinityScroll: Observable<()> {
        
        .create { [weak base] (observer) -> Disposable in
            
            if let base = base {
                base.addInfinityScroll {
                    observer.onNext(())
                }
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create {
                base?.endInfinityScroll()
            }
            
        }
        
    }
    
    var endPullToRefresh: Binder<()> {
        
        Binder(base) { control, _ in
            control.endPullToRefresh()
            control.resetNoMoreData()
        }
        
    }
    
    var endInfinityScroll: Binder<Bool> {
        
        Binder(base) { control, content in
            if content {
                control.endInfinityScroll()
            } else {
                control.noticeNoMoreData()
            }
        }
        
    }
    
}
