//
//  ZJCountDownTimer.swift
//  Action
//
//  Created by Jercan on 2023/9/14.
//

import Foundation

final class ZJCountDownTimer {
    
    let totalCount: Int
    
    let handler: (_ rest: Int) -> Void
    
    private var timer: Timer?
    
    private var counted = 0
    
    init(totalCount: Int, interval: TimeInterval = 1, handler: @escaping (Int) -> Void) {
        self.totalCount = totalCount
        self.handler = handler
        timer = .repeatingTimer(interval: interval, handler: { [weak self] in
            self?.onTimer()
        })
        if let tm = timer {
            RunLoop.current.add(tm, forMode: .commonModes)
            tm.fireDate = .distantFuture // 暂停定时器
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
}

extension ZJCountDownTimer {
    
    func start() {
        if counted > 0 { return }
        timer?.fireDate = .init()
    }
    
}

private extension ZJCountDownTimer {
    
    func onTimer() {
        
        counted += 1
        let rest = totalCount - counted
        handler(rest)
        if rest == 0 {
            timer?.fireDate = .distantFuture
            counted = 0
        }
        
    }
    
}

private extension Timer {
    
    class func repeatingTimer(interval: TimeInterval, handler: @escaping () -> ()) -> Timer {
        
        let userInfo = handler
        
        let timer = Timer(timeInterval: interval,
                          target: self, selector: #selector(__timerSelector),
                          userInfo: userInfo,
                          repeats: true)
        
        return timer
        
    }
    
    @objc class func __timerSelector(_ timer: Timer) {
        
        if let block = timer.userInfo as? () -> () {
            block()
        }
        
    }
    
}
