//
//  TransactionFilterVM.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import RxDataSources

final class TransactionFilterVM {
    
    struct SectionItem {
        let name: String
        let value: Int
        let enabled: Bool
        let selected: Bool
    }
    
    typealias Section = SectionModel<String, SectionItem>
    
    let title = Locale.filter.localized
    
    let datas = BehaviorRelay(value: [Section]())
    
    let contentHeight: CGFloat
    
    private let filterCategory: FilterCategory
    
    private(set) var param: TransactionFilterParam
        
    init(_ category: FilterCategory, param: TransactionFilterParam) {
        
        filterCategory = category
        
        self.param = param
        
        func calculateHeight(itemCount: Int) -> CGFloat {
            
            var height: CGFloat = 0
            
            let row = CGFloat(itemCount / 3)
            
            height += (44 +  max(0, (row - 1)) * 12 + 40)
                        
            if itemCount % 3 > 0 {
                height += 52
            }
            
            return height
            
        }
        
        var height: CGFloat = 0
        
        if let items = filterCategory.productItems, !items.isEmpty {
            height += calculateHeight(itemCount: items.count + 1)
        }
        
        if let items = filterCategory.tradeItems, !items.isEmpty {
            height += calculateHeight(itemCount: items.count + 1)
        }
        
        contentHeight = height
        
        buildSections()
        
    }
    
}

extension TransactionFilterVM {
    
    func handleSelectItem(at indexPath: IndexPath) {
        
        var section = datas.value[indexPath.section]
        
        guard section.items[indexPath.item].enabled else {
            return
        }
        
        var newItems = [SectionItem]()
        
        var selectValue = 0
        
        for (idx, item) in section.items.enumerated() {
            
            let selected = idx == indexPath.item
            
            if selected {
                selectValue = item.value
            }
            
            newItems.append(.init(name: item.name, value: item.value, enabled: item.enabled, selected: selected))
            
        }
        
        section.items = newItems
        
        if indexPath.section == 0, let items = filterCategory.productItems, !items.isEmpty {
            
            param.productType = selectValue
            
            param.tradeType = 0
            
            var enabledItems: [Int]?
            
            for item in items {
                if item.value == selectValue {
                    enabledItems = item.enabledTradeItems
                    break
                }
            }
            
            var sectionItems = [SectionItem(name: Locale.all.localized, value: 0, enabled: true, selected: 0 == param.tradeType)]
            
            if let items = filterCategory.tradeItems, !items.isEmpty {
                
                sectionItems.append(contentsOf: items.map { .init(name: $0.name,
                                                                  value: $0.value,
                                                                  enabled: enabledItems?.contains($0.value) ?? true,
                                                                  selected: $0.value == param.tradeType) })
                
            }
            
            var sections: [Section] = [section]
            
            sections.append(.init(model: Locale.tradeType.localized, items: sectionItems))
            
            datas.accept(sections)
            
        } else {
            
            param.tradeType = selectValue
            
            var sections = datas.value
            
            sections.remove(at: indexPath.section)
            
            sections.insert(section, at: indexPath.section)
            
            datas.accept(sections)
            
        }
        
    }
    
}

private extension TransactionFilterVM {
        
    func buildSections() {
        
        var sections = [Section]()
        
        var enabledItems: [Int]?
        
        if let items = filterCategory.productItems, !items.isEmpty {
            
            var sectionItems = [SectionItem(name: Locale.all.localized,
                                            value: 0,
                                            enabled: true,
                                            selected: 0 == param.productType)]
            
            sectionItems.append(contentsOf: items.map { .init(name: $0.name,
                                                              value: $0.value,
                                                              enabled: true,
                                                              selected: $0.value == param.productType) })
            
            sections.append(.init(model: Locale.productType.localized, items: sectionItems))
            
            for item in items {
                if item.value == param.productType {
                    enabledItems = item.enabledTradeItems
                    break
                }
            }
            
        }
        
        if let items = filterCategory.tradeItems, !items.isEmpty {
            
            var sectionItems = [SectionItem(name: Locale.all.localized,
                                            value: 0,
                                            enabled: true,
                                            selected: 0 == param.tradeType)]
            
            sectionItems.append(contentsOf: items.map { .init(name: $0.name,
                                                              value: $0.value,
                                                              enabled: enabledItems?.contains($0.value) ?? true,
                                                              selected: $0.value == param.tradeType) })
            
            sections.append(.init(model: Locale.tradeType.localized, items: sectionItems))
            
        }
        
        datas.accept(sections)
        
    }
    
}

