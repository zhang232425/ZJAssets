//
//  DepositAssetsViewModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire

final class DepositAssetsViewModel {
    
    enum SectionItem {
        case header(info: DepositAssetsHeaderInfo, clickAction: () -> ())
        case function(signCount: Int, isAppoint: Bool)
        case item(DepositListItem)
        case itemRenew(DepositListItem)
        case itemRenewing(DepositListItem)
        case separator(height: CGFloat)
        case empty
    }
    
    enum ActionType {
        case reload
        case loadMore
    }
    
    let title = Locale.p2p.localized

    private(set) lazy var fetchAction: Action<(), ()> = .init { [weak self] in
        self?.fetchOrderList(type: .reload).map { _ in } ?? .just(())
    }
    
    private(set) lazy var reloadAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchOrderList(type: .reload) ?? .just(false)
    }
    
    private(set) lazy var loadMoreAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchOrderList(type: .loadMore) ?? .just(false)
    }
    
    private(set) var assetsInfo = DepositAssets() {
        didSet {
            signCount = assetsInfo.appointOrderToConfirmCount
            isAppoint = assetsInfo.displayAppointment
        }
    }
    
    let isSecureText = BehaviorRelay(value: UserDefaults.standard.isDepositSecureText)
    
    private var signCount = 0
    
    private var isAppoint = false
    
    private var page: Int?
    
    let datas = BehaviorRelay(value: [SectionModel<String, SectionItem>]())
    
}

private extension DepositAssetsViewModel {
    
    func fetchOrderList(type: ActionType) -> Observable<Bool> {
        
        switch type {
        case .reload:
            page = nil
            return Observable.zip(Request.fetchDepositAssets(),
                                  Request.fetchDepositOrderList(page: page))
            .map { self.buildSections(assets: $0, list: $1.0, type: type, sysTime: $1.1) }
        case .loadMore:
            if page == nil {
                return .just(false)
            }
            return Request.fetchDepositOrderList(page: page).map { self.buildScetions(list: $0.0, type: type, sysTime: $0.1) }
        }
        
    }
    
    func buildSections(assets: DepositAssets?, list: DepositOrderPage?, type: ActionType, sysTime: NSNumber?) -> Bool {
        
        if let val = assets {
            assetsInfo = val
        }
        
        return buildScetions(list: list, type: type, sysTime: sysTime)
        
    }
    
    func buildScetions(list: DepositOrderPage?, type: ActionType, sysTime: NSNumber?) -> Bool {
        
        page = list?.nextPage
        
        let hasNext = list?.nextPage == nil ? false : true
        
        switch type {
        case .reload:
            
            datas.accept([])
            
            guard let items = list?.list, !items.isEmpty else {
                
                datas.accept([.init(model: "", items: [buildHeaderItem(),
                                                       .function(signCount: signCount, isAppoint: isAppoint),
                                                       .empty])])
                
                return hasNext
            }
            
            buildScetions(list: items, sysTime: sysTime)
        
        case .loadMore:
            
            buildScetions(list: list?.list, sysTime: sysTime)
    
        }
        
        return hasNext
        
    }
    
    func buildScetions(list: [DepositOrder]?, sysTime: NSNumber?) {
        
        var newList: [SectionItem] = [buildHeaderItem(), .function(signCount: signCount, isAppoint: isAppoint), .separator(height: 4)]
        
        if let items = datas.value.first?.items.filter({
            switch $0 {
            case .item, .itemRenew, .itemRenewing:
                return true
            default:
                return false
            }
        }) {
            newList.append(contentsOf: items)
        }
        
        var sysTimeDiff: NSNumber?
        if let time = sysTime {
            
            let serverTime = time.int64Value / 1000
            let currentTime = Int64(Date().timeIntervalSince1970)
            sysTimeDiff = NSNumber(value: (currentTime - serverTime))
            
        }
        
        if let items = list?.map({ DepositListItem(order: $0, sysTimeDiff: sysTimeDiff, isSecureText: isSecureText.asObservable()) }),
           !items.isEmpty {
            
            for item in items {
                
                if item.isExpired || item.isFailed || item.isWaitRenew {
                    
                    newList.append(.itemRenew(item))
                } else if item.isRenewing {
                    newList.append(.itemRenewing(item))
                } else {
                    newList.append(.item(item))
                }
                
            }
            
        }
        
        newList.append(.separator(height: 26))
        
        datas.accept([.init(model: "", items: newList)])
        
        
    }
    
    func buildHeaderItem() -> SectionItem {
        .header(info: .init(assets: assetsInfo, isSecureText: isSecureText.asObservable())) { [weak self] in
            self?.handleSecureClick()
        }
    }
    
    func handleSecureClick() {
        var secure = UserDefaults.standard.isDepositSecureText
        secure.toggle()
        UserDefaults.standard.isDepositSecureText = secure
    }
    
    
}
