//
//  AssetsBaseInfo.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/13.
//

import HandyJSON

enum VipLevel: Int, HandyJSONEnum {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case sixth
}

extension VipLevel {

    var imageName: String { "vip_\(rawValue)" }
    
    var colorHex: String {
        switch self {
        case .first:
            return "FFFBF7"
        case .second:
            return "80B6B4"
        case .third:
            return "B6B6B8"
        case .fourth:
            return "ECCA8B"
        case .fifth:
            return "92A4C1"
        case .sixth:
            return "2D2140"
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .sixth:
            return .lightContent
        default:
            return .default
        }
    }
    
    var navigationBarStyle: AssetsNavigationBar.Style {
        switch self {
        case .first:
            return .dark
        default:
            return .light
        }
    }
    
}

struct AssetsBaseInfo {
    
    //总资产
    var totalAmount = NSNumber(value: 0)
    
    //当前利息
    var totalIncome = NSNumber(value: 0)
    
    //昨日收益
    var lastIncome = NSNumber(value: 0)
    
    var balance = NSNumber(value: 0)
    
    var continueRate = NSNumber(value: 0)
    
    // 余额状态(统计中)
    var balanceStatus: String?
    
    //会员等级
    var vipLevel = VipLevel.first
    
    // 理财月报 内容
    var showMonthReport = false
    
    var hasNewMonthReport = false
    
    var monthReportTitle = ""
    
    var monthReportContent = ""
    
    var monthReportUrl: String?
    
    // 年报
    var yearReportTitle: String?
    
    var yearReportUrl: String?
    
    var hasUnread = false
    
    var unpaidCount = 0
    
}

extension AssetsBaseInfo: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< totalAmount         <-- "total"
        
        mapper <<< balance             <-- "maturedAmount"
                
        mapper <<< continueRate        <-- "continueInterest"
                
        mapper <<< showMonthReport     <-- "monthlyReportColumn.isShowMonthlyReport"
        
        mapper <<< hasNewMonthReport   <-- "monthlyReportColumn.isMonthlyReportNew"
        
        mapper <<< monthReportTitle    <-- "monthlyReportColumn.monthlyReportTitle"
        
        mapper <<< monthReportContent  <-- "monthlyReportColumn.monthlyReportContent"
        
        mapper <<< monthReportUrl      <-- "monthlyReportColumn.monthlyReportUrl"
        
        mapper <<< balanceStatus       <-- "clearingStatus"
        
        mapper <<< yearReportTitle     <-- "annualReportBanner.reportTitle"
        
        mapper <<< yearReportUrl       <-- "annualReportBanner.reportUrl"
        
        mapper <<< unpaidCount         <-- "unpaidOrderCount"
        
        mapper <<< hasUnread           <-- "hasProcessingUnread"
        
    }
    
}
