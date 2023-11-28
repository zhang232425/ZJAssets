//
//  InProgressVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import RxDataSources

final class InProgressVM {

    enum SectionItem {
        case item(TransactionListCellVM)
        case noMoreData
        case empty
    }
    
    enum ActionType {
        case reload
        case loadMore
    }
    
    private(set) lazy var fetchAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchDatas() ?? .just(false)
    }
    
    private(set) lazy var reloadAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchInProgressList(type: .reload) ?? .just(false)
    }
    
    private(set) lazy var loadMoreAction: Action<(), Bool> = .init { [weak self] in
        self?.fetchInProgressList(type: .loadMore) ?? .just(false)
    }
    
    let datas = BehaviorRelay(value: [SectionModel<String, SectionItem>]())
    
    private let countDown = BehaviorRelay(value: ())
    
    private var bag = DisposeBag()
    
    private var param = TransactionParam()
    
    private var filterValues: [Int] {
        var ret = [0]
        if let vals = category.productItems?.map({ $0.value }) {
            ret.append(contentsOf: vals)
        }
        return ret
    }
    
    var filterTitles: [String] {
        var ret = [Locale.all.localized]
        if let titles = category.productItems?.map({ $0.name }) {
            ret.append(contentsOf: titles)
        }
        return ret
    }
    
    var selectedIndex = 0 {
        didSet {
            if selectedIndex != oldValue {
                param.productType = filterValues[selectedIndex]
                fetchAction.execute()
            }
        }
    }
    
    let category: FilterCategory
    
    init(category: FilterCategory) {
        self.category = category
    }
    
}

private extension InProgressVM {
    
    func fetchDatas() -> Observable<Bool> {
        Observable.zip(fetchFilterCategory(),
                       fetchInProgressList(type: .reload))
        .map { (_, hasNext) in hasNext }
    }

    func fetchFilterCategory() -> Observable<()> {
        
        Observable<Bool>.create { observer -> Disposable in
            
            if let items = self.category.productItems, !items.isEmpty {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
            
        }.flatMap {
            
            $0 ? .just(()) : Request.fetchFilterCategory().map {
                
                if let items = $0?.productItems, !items.isEmpty {
                    self.category.productItems = items
                }
                
                if let items = $0?.tradeItems, !items.isEmpty {
                    self.category.tradeItems = items
                }
                
            }
            
        }
        
    }
    
    func fetchInProgressList(type: ActionType) -> Observable<Bool> {
        
        switch type {
        case .reload:
            param.page = nil
        case .loadMore:
            if param.page == nil {
                return .just(false)
            }
        }
        
        return Request.fetchInProgressList(param: param).map { self.buildSections(list: $0, type: type) }
        
    }

    func buildSections(list: TransactionListPage?, type: ActionType) -> Bool {
        
        param.page = list?.nextPage
        
        let hasNext = list?.nextPage == nil ? false : true
        
        switch type {
            
        case .reload:
            
            datas.accept([])
            
            resetCountDown()
            
            guard let items = list?.list, !items.isEmpty else {
                datas.accept([.init(model: "", items: [.empty])])
                return hasNext
            }
            
            buildSections(list: items, hasNext: hasNext)
            
        case .loadMore:
            
            buildSections(list: list?.list, hasNext: hasNext)
            
        }
        
        return hasNext
        
    }
    
    func buildSections(list: [TransactionListItem]?, hasNext: Bool) {
        
        var newList = datas.value.first?.items ?? []
        
        if let items = list?.map({ SectionItem.item(.init(item: $0, countDown: countDown.asObservable())) }), !items.isEmpty {
            newList.append(contentsOf: items)
        }
        
        if !hasNext {
            newList.append(.noMoreData)
        }
        
        datas.accept([.init(model: "", items: newList)])
        
        countDownIfNeeded()
        
    }
    
    
}

private extension InProgressVM {
    
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
