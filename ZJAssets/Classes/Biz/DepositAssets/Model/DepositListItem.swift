//
//  DepositListItem.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import Foundation
import RxSwift

struct DepositListItem: AssetsSecureProtocol {
    
    var order: DepositOrder
    
    var sysTimeDiff: NSNumber?
    
    let isSecureText: Observable<Bool>
    
}

extension DepositListItem {
    
    var matureDaysTip: String {
        Locale.fundDayTip.localized(arguments: order.matureDays)
    }
    
}

extension DepositListItem {
//    开启了自动续投，就不展示续投按钮，未开启续投展示开启续投按钮
    //是否失败，true展示续投按钮
    var isFailed: Bool {
        if order.status == .expired {
            if order.continueStatus == .failed {
                return true
            }
        }
        return false
    }
    //是否到期，true展示续投按钮
    var isExpired: Bool {
        if order.status == .expired {
            if order.continueStatus == .expired {
                return true
            }
        }
        return false
    }
    //是否在续投中，true展示续投中的样式
    var isRenewing: Bool {
        if order.status == .expired {
            if order.continueStatus == .renew {
                return true
            }
        }
        return false
    }
    //等待续投，隐藏续投及开启续投按钮
    var isWaitRenew: Bool {
        switch order.status {
        case .expired:
            return false
        default:
            return true
        }
    }
    //是否选择了自动续投模板， 选中了可以直接开启，否则要跳转到自动续投产品列表
    var isSelectAutoTmpl: Bool { !order.autoTmplId.isEmpty }
    
}

