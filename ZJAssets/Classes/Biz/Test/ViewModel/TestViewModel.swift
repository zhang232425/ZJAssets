//
//  TestViewModel.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/21.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

final class TestViewModel {
    
    enum SectionItem {
        case header(info: TestHeaderInfo, clickAction: () -> ())
        case item(TestItemInfo)
    }
    
    let isSecureText = BehaviorRelay(value: UserDefaults.standard.isTestSecureText)
    
    let datas = BehaviorRelay(value: [SectionModel<String, SectionItem>]())
    
    init() {
        
        datas.accept([
            .init(model: "", items: [
                .header(info: .init(name: "张大春", age: 33, address: "湖南省麻阳县大桥江乡石垄溪村", isSecureText: isSecureText.asObservable()), clickAction: { [weak self] in
                    self?.handleSecureClick()
                }),
                .item(.init(model: .init(name: "王滕", age: 22, deep: 3), isSecureText: isSecureText.asObservable())),
                .item(.init(model: .init(name: "龙容", age: 28, deep: 0), isSecureText: isSecureText.asObservable())),
                .item(.init(model: .init(name: "孙丽雯", age: 22, deep: 0), isSecureText: isSecureText.asObservable())),
                .item(.init(model: .init(name: "黄英", age: 26, deep: 0), isSecureText: isSecureText.asObservable())),
                .item(.init(model: .init(name: "彭敏", age: 27, deep: 0), isSecureText: isSecureText.asObservable()))
            ])
        ])
        
    }
    
    
}

private extension TestViewModel {
    
    func handleSecureClick() {
        var secure = UserDefaults.standard.isTestSecureText
        secure.toggle()
        UserDefaults.standard.isTestSecureText = secure
    }
    
}
