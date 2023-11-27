//
//  DepositIncomeViewModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import Foundation
import Action
import RxCocoa
import RxSwift
import RxDataSources

final class DepositIncomeViewModel {

    enum SectionItem {
        case header(DepositAssets)
        case title
        case item(DepositIncome)
        case status(DepositIncome)
        case empty
    }
    
    enum ActionType {
        case reload
        case loadMore
    }
    
    private(set) lazy var fetchAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchIncomeList(type: .reload) ?? .just(false)
    }
    
    private(set) lazy var reloadAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchIncomeList(type: .reload) ?? .just(false)
    }
    
    private(set) lazy var loadMoreAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchIncomeList(type: .loadMore) ?? .just(false)
    }
    
    let datas = BehaviorRelay(value: [SectionModel<String, SectionItem>]())
    
    let title = Locale.earningDetail.localized
    
    private var page: Int?
    
    private let assets: DepositAssets
    
    init(assets: DepositAssets) {
        self.assets = assets
    }
    
}

private extension DepositIncomeViewModel {
    
    func fetchIncomeList(type: ActionType) -> Observable<Bool> {
        
        switch type {
        case .reload:
            page = nil
        case .loadMore:
            if page == nil {
                return .just(false)
            }
        }
        
        return Request.fetchIncomeList(page: page).map { self.buildSections(list: $0, type: type) }
        
    }
    
    func buildSections(list: DepositIncomePage?, type: ActionType) -> Bool {
        
        page = list?.nextPage
        
        let hasNext = list?.nextPage == nil ? false : true
        
        switch type {
            
        case .reload:
            
            datas.accept([])
            
            guard let items = list?.list, !items.isEmpty else {
                datas.accept([.init(model: "", items: [.header(assets), .title, .empty])])
                return hasNext
            }
            
            buildSections(list: items)
            
        case .loadMore:
            
            buildSections(list: list?.list)
            
        }
        
        return hasNext
        
    }

    func buildSections(list: [DepositIncome]?) {
        
        var newList: [SectionItem] = [.header(assets), .title]
        
        if let items = datas.value.first?.items.filter({
            switch $0 {
            case .item, .status:
                return true
            default:
                return false
            }
        }) {
            newList.append(contentsOf: items)
        }
        
        if let items = list, !items.isEmpty {
            
            for item in items {
                
                if item.statusDesc.isEmpty {
                    newList.append(.item(item))
                } else {
                    newList.append(.status(item))
                }
                
            }
            
        }
        
        datas.accept([.init(model: "", items: newList)])
        
    }
    
    
}
