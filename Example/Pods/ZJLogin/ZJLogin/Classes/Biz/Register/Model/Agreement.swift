//
//  Agreement.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import ZJCommonDefines

enum Agreement: CaseIterable {
    
    case tnc
    case privacy
    
    var title: String {
        switch self {
        case .tnc:
            return Locale.tncLendingBorrowing.localized
        case .privacy:
            return Locale.privacyPolicy.localized
        }
    }
    
    var url: URL {
        let string: String
        switch self {
        case .tnc:
            string = ZJUrl.lendAndBorrowContract
        case .privacy:
            string = ZJUrl.privacyPolicy
        }
        if let url = URL(string: string) { return url }
        return URL(string: "http://")!
    }
    
}
