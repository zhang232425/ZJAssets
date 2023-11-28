//
//  HistoryVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import RxDataSources

final class HistoryVM {
    
    enum SectionItem {
        case item(TransactionListCellVM)
        case noMoreData
        case empty
    }
    
    enum ActionType {
        case reload
        case loadMore
    }
    
    typealias Section = SectionModel<String, SectionItem>
    
    private(set) lazy var fetchAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchDatas() ?? .just(false)
    }
    
    private(set) lazy var reloadAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchHistoryList(type: .reload) ?? .just(false)
    }
    
    private(set) lazy var loadMoreAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchHistoryList(type: .loadMore) ?? .just(false)
    }
    
    private(set) var isPeriodSelect = false
    
    private(set) var showOldEntrance = false {
        didSet { isSetOldEntrance = true }
    }
    
    private var isSetOldEntrance = false
    
    private let countDown = BehaviorRelay(value: ())
    
    private var bag = DisposeBag()
    
    private var param = TransactionParam()
    
    var filterParam = TransactionFilterParam(productType: 0, tradeType: 0) {
        
        didSet {
            
            if (filterParam.productType != oldValue.productType) ||
                (filterParam.tradeType != oldValue.tradeType) {
                
                param.productType = filterParam.productType
                param.tradeType = filterParam.tradeType
                
                fetchAction.execute()
                
            }
            
        }
        
    }
    
    let filterPeriodVM = TransactionPeriodVM(type: .all)
    
    let datas = BehaviorRelay(value: [Section]())
    
    let filterCategory: FilterCategory
    
    init(_ category: FilterCategory) {
        filterCategory = category
    }
    
}

extension HistoryVM {
    
    func handlePeriodSelect(start: Date?, end: Date?) {
        
        isPeriodSelect = true
        
        param.startTime = start
        
        param.endTime = end
        
        fetchAction.execute()
        
    }
    
}

private extension HistoryVM {
    
    func fetchDatas() -> Observable<Bool> {
        Observable.zip(fetchFilterCategory(),
                       fetchHistoryList(type: .reload),
                       fetchOldEntrance())
            .map { (_, hasNext, _) in hasNext }
    }
    
    func fetchOldEntrance() -> Observable<()> {
        Observable.just(isSetOldEntrance).flatMap {
            $0 ? .just(()) : Request.showOldOrderEntrance().map {
                self.showOldEntrance = $0
            }
        }
    }
    
    func fetchFilterCategory() -> Observable<()> {
        
        Observable<Bool>.create { observer -> Disposable in
            
            if let items = self.filterCategory.tradeItems, !items.isEmpty {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
            
        }.flatMap {
            
            $0 ? .just(()) : Request.fetchFilterCategory().map {
                
                if let items = $0?.productItems, !items.isEmpty {
                    self.filterCategory.productItems = items
                }
                
                if let items = $0?.tradeItems, !items.isEmpty {
                    self.filterCategory.tradeItems = items
                }
                
            }
            
        }
        
    }
    
    func fetchHistoryList(type: ActionType) -> Observable<Bool> {
        
        switch type {
        case .reload:
            param.page = nil
        case .loadMore:
            if param.page == nil {
                return .just(false)
            }
        }
        
        return Request.fetchHistoryList(param: param).map { self.buildSections(list: $0, type: type) }
        
    }
    
    func buildSections(list: TransactionListPage?, type: ActionType) -> Bool {
        
        param.page = list?.nextPage
        
        let hasNext = list?.nextPage == nil ? false : true
        
        switch type {
        case .reload:
            
            datas.accept([])
            
            resetCountDown()
            
            guard let items = list?.list, !items.isEmpty else {
                datas.accept([.init(model: Date().monthFormat, items: [.empty])])
                return hasNext
            }
            
            buildSections(list: items, hasNext: hasNext)
            
        case .loadMore:
            
            buildSections(list: list?.list, hasNext: hasNext)
            
        }
        
        return hasNext
        
    }
    
    func buildSections(list: [TransactionListItem]?, hasNext: Bool) {
        
        guard let items = list, !items.isEmpty else {
            return
        }
        
        let countDownObserver = countDown.asObservable()
        
        var sections = datas.value
        
        var lastMonth: String
        
        if let month = sections.last?.model {
            lastMonth = month
        } else {
            lastMonth = items.first!.createMonth
        }
        
        var lastSectionItems = sections.last?.items ?? []
        
        if !sections.isEmpty {
            sections.removeLast()
        }
        
        for item in items {
           
            if item.createMonth == lastMonth {
                
                lastSectionItems.append(.item(.init(item: item, countDown: countDownObserver)))
                
            } else {
                
                sections.append(.init(model: lastMonth, items: lastSectionItems))
                
                lastMonth = item.createMonth
                
                lastSectionItems = [.item(.init(item: item, countDown: countDownObserver))]
                
            }
            
        }
        
        if !lastSectionItems.isEmpty {
            
            if !hasNext {
                lastSectionItems.append(.noMoreData)
            }
            
            sections.append(.init(model: lastMonth, items: lastSectionItems))
            
        }
        
        datas.accept(sections)
        
        countDownIfNeeded()
        
    }
    
    func countDownIfNeeded() {
        
        var need = false
        
        for section in datas.value {
            
            for item in section.items {
                
                switch item {
                case .item(let vm) where vm.needCountDown == true:
                    startCountDown()
                    need = true
                    return
                default:
                    break
                }
                
            }
            
        }
        
        if !need {
            bag = DisposeBag()
        }
        
    }
    
    func startCountDown() {
        
        bag = DisposeBag()
        
        Observable<Int>.interval(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { _ in}
            .subscribe(onNext: { [weak self] in
                
                self?.datas.value.forEach {
                    
                    $0.items.forEach {
                        switch $0 {
                        case .item(let vm):
                            vm.executeCountDown()
                        default:
                            break
                        }
                    }
                    
                }
                
                self?.countDown.accept(())
                
            }).disposed(by: bag)
        
    }
    
    func resetCountDown() {
        bag = DisposeBag()
    }
    
}

