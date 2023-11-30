//
//  WithdrawDetailVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import ZJRequest

final class HistoryDetailVM {

    enum SectionItem {
        case noSignal
        case header(HistoryDetailHeaderModel)
        case record([HistoryDetailFlow])
    }
    
    /// 是否网络错误
    var isNoSignal: Bool {
        if case .noSignal = datas.value.first { return true }
        return false
    }
    
    /// nil 底部无按钮 String 底部按钮内容
    var bottomString: String? {
        
        guard !isNoSignal else { return Locale.check_order.localized }
        
        switch type {
        case .payment:
            return Locale.check_order.localized
        case .withdrawalSuccessfulNew:
            return Locale.check_order.localized
        default:
            return Locale.check_order.localized
        }
    }
    
    private(set) lazy var reloadAction: CocoaAction = .init { [weak self] in
        self?.fetchData() ?? .just(())
    }
    
    private(set) var datas = BehaviorRelay(value: [SectionItem]())
    
    private var type: HistoryRecordType?
    
    let title = Locale.details.localized
    
    private let recordId: String
    
    init(recordId: String) {
        
        self.recordId = recordId
        
    }
    
}

private extension HistoryDetailVM {

    func fetchData() -> Observable<(Void)> {
        
        Request.getHistoryDetail(id: recordId).map { [weak self] in
            self?.buildSections(response: $0)
        }
        
    }
    // response
    func buildSections(response: HistoryDetailModel?) {
        
        guard let data = response else {
            datas.accept([.noSignal])
            return
        }
        
        type = data.type
        
        datas.accept([.header(.init(model: data)), .record(data.transactionFlow)])
        
    }
    
}
