//
//  TransactionListCellVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/24.
//

import Foundation
import RxSwift

final class TransactionListCellVM {
    
    let item: TransactionListItem
    
    private var remainInterval: TimeInterval
    
    let countDown: Observable<()>
    
    init(item: TransactionListItem, countDown: Observable<()>) {
        self.item = item
        self.countDown = countDown
        remainInterval = item.countDownPeriod
    }
    
}

extension TransactionListCellVM {
    
    var needCountDown: Bool {
        item.showCountDown && remainInterval > 0
    }
    
    var remainTimeFormat: String {
        guard remainInterval > 0 else {
            return "00:00:00"
        }
        return remainInterval.countDownTime
    }
    
}

extension TransactionListCellVM {
    
    func executeCountDown() {
        if remainInterval > 0 {
            remainInterval -= 1
        }
    }
    
}
