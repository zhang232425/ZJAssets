//
//  AssetsViewModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa
import Action

final class AssetsViewModel {
    
    enum SectionItem {
        case assets(info: AssetsHeaderInfo, secureAction: () -> (), unpayAction: () -> ())
        case balance(info: AssetsBalanceInfo, clickAction: () -> ())
        case hold(info: AssetsHoldInfo, clickHandler: (AssetsInfo.AssetsType) -> ())
        case chart(infos: [ChartInfo])
        case insure(info: InsureInfo?, clickAction: () -> ())
        case separator(CGFloat)
    }

    enum NavigationStep {
        case monthReport
        case renewInvest(NSNumber)
        case insure(URL)
        case deposit
        case flex
        case fund
        case gold
        case transaction
    }
    
    var navigationTitle: String { Locale.assets.localized }
    
    private(set) var monthReportUrl: String?
    
    let isMonthReportHidden = BehaviorRelay(value: true)
    
    let hasProcessOrder = BehaviorRelay(value: false)
    
    let isSecureText = BehaviorRelay(value: UserDefaults.standard.isSecureText)
    
    let datas = BehaviorRelay(value: [SectionItem]())

    let nextStep = BehaviorRelay<NavigationStep?>(value: nil)
    
    private(set) lazy var fetchAction: Action<(), VipLevel?> = .init { [weak self] in
        self?.fetchData() ?? .just(nil)
    }
    
    private(set) lazy var refreshAction: Action<(), VipLevel?> = .init { [weak self] in
        self?.fetchData() ?? .just(nil)
    }

    private(set) lazy var investCheckAction: Action<(), ()> = .init { [weak self] in
        Request.investCheck().map { self?.refreshBalanceItem(balance: $0) }
    }
    
    
}

private extension AssetsViewModel {
    
    func buildSections(base: AssetsBaseInfo?, extra: AssetsExtraInfo?, chart: [ChartInfo]?) -> VipLevel? {
                
        guard let baseInfo = base, let extraInfo = extra else {
            return nil
        }
        
        monthReportUrl = baseInfo.monthReportUrl
        
        isMonthReportHidden.accept(!baseInfo.showMonthReport)
        
        hasProcessOrder.accept(baseInfo.hasUnread)
        
        let secureText = isSecureText.asObservable()
        
        var items = [SectionItem]()
        
        items.append(.assets(info: .init(baseInfo: baseInfo, isSecureText: secureText), secureAction: { [weak self] in
            self?.handleSecureClick()
        }, unpayAction: { [weak self] in
            self?.handleUnpayClick()
        }))
        
        if Int(truncating: baseInfo.balance) > 0 {
            
            items.append(.balance(info: .init(rate: baseInfo.continueRate,
                                              balance: baseInfo.balance,
                                              isSecureText: secureText), clickAction: { [weak self] in
                self?.handleBalanceClick()
            }))
            
        } else {
            
            items.append(.separator(16))
            
        }
        
        if let assets = extraInfo.assets, !assets.isEmpty {
            items.append(.hold(info: .init(assets: assets, isSecureText: secureText), clickHandler: { [weak self] in
                self?.handleAssetsClick($0)
            }))
        }
        
        if let charts = chart, !charts.filter({ Int(truncating: $0.income) > 0 }).isEmpty {
            items.append(.chart(infos: charts))
        }
        
        if extraInfo.insure?.isShowInsure ?? false {
            items.append(.insure(info: extraInfo.insure, clickAction: { [weak self] in
                self?.handleInsureClick(urlStr: extraInfo.insure?.insuranceUrl)
            }))
        }
        
        datas.accept(items)
        
        return baseInfo.vipLevel
        
    }
    
    func refreshBalanceItem(balance: NSNumber?) {
        
        guard let balance = balance else { return }
        
        var sections = datas.value
        
        for (idx, item) in sections.enumerated() {
            
            if case .balance(let info, let clickAction) = item {
                
                sections.remove(at: idx)
                
                let newInfo = AssetsBalanceInfo(rate: info.rate, balance: balance, isSecureText: info.isSecureText)
                
                sections.insert(.balance(info: newInfo, clickAction: clickAction), at: idx)
                
                break
                
            }
            
        }
        
        datas.accept(sections)
        
        if balance.intValue > 0 {
            nextStep.accept(.renewInvest(balance))
        }
        
    }
    
    func handleSecureClick() {
        
        var secure = UserDefaults.standard.isSecureText
        secure.toggle()
        UserDefaults.standard.isSecureText = secure
    
    }
    
    func handleUnpayClick() {
        
    }
    
    func handleBalanceClick() {
        
    }
    
    func handleAssetsClick(_ type: AssetsInfo.AssetsType) {
    
        switch type {
        case .flex:
            nextStep.accept(.flex)
        case .deposit:
            nextStep.accept(.deposit)
        case .fund:
            nextStep.accept(.fund)
        case .gold:
            nextStep.accept(.gold)
        }
        
    }
    
    func handleInsureClick(urlStr: String?) {
        
    }
    
}

private extension AssetsViewModel {

    func fetchData() -> Observable<VipLevel?> {
        Observable.zip(Request.fetchAssetsBaseInfo(),
                       Request.fetchAssetsExtraInfo(),
                       Request.fetchChartInfo())
        .map { self.buildSections(base: $0, extra: $1, chart: $2) }
    }
    
}
