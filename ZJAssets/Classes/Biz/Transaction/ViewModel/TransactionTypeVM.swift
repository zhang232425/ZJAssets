//
//  TransactionTypeVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import Foundation
import RxDataSources
import RxCocoa

final class TransactionTypeVM {

    struct SectionItem {
        let name: String
        let value: Int
        let selected: Bool
    }
    
    let datas = BehaviorRelay(value: [SectionModel<String, SectionItem>]())
    
    let title = Locale.tradeType.localized
    
    let contentHeight: CGFloat
    
    private let tradeItems: [FilterTradeItem]
    
    private let filterCategory: FilterCategory
    
    private(set) var selectedType: Int

    init(_ category: FilterCategory, selectedType: Int) {
        
        filterCategory = category
        
        self.selectedType = selectedType
    
        /// 筛选出定期对应的交易类型
        var enabledItems: [Int]?
        
        if let items = filterCategory.productItems, !items.isEmpty {
            
            for item in items {
                if item.value == 1 {
                    enabledItems = item.enabledTradeItems
                    break
                }
            }
            
        }
        
        /// 从总的交易类型中过滤出支持的类型
        if let items = filterCategory.tradeItems, !items.isEmpty, let enabledItems = enabledItems, !enabledItems.isEmpty {
            tradeItems = items.filter { enabledItems.contains($0.value) }
        } else {
            tradeItems = []
        }
        
        /// 计算高度
        var height: CGFloat = 0
        
        if !tradeItems.isEmpty {
            height += CGFloat(tradeItems.count + 1) * 51.auto
        }
        
        contentHeight = height
        
        buildSections()
        
    }
    
    
    
}

private extension TransactionTypeVM {
    
    func buildSections() {
        
        var sections = [SectionModel<String, SectionItem>]()
        
        var sectionItems = [SectionItem(name: Locale.all.localized, value: 0, selected: 0 == selectedType)]
        
        if !tradeItems.isEmpty {
            
            sectionItems.append(contentsOf: tradeItems.map {
                .init(name: $0.name, value: $0.value, selected: $0.value == selectedType)
            })
            
        }
        
        sections.append(.init(model: Locale.tradeType.localized, items: sectionItems))
        
        datas.accept(sections)
        
    }
    
}
