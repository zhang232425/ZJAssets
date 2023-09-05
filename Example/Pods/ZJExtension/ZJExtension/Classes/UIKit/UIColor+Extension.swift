//
//  UIColor+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

public extension UIColor {
    
    /// 背景色 F6F8FA
    static var backgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9803921569, alpha: 1)}
    
    /// 分割线颜色 EFF2F7
    static var lineColor: UIColor {#colorLiteral(red: 0.937254902, green: 0.9490196078, blue: 0.968627451, alpha: 1)}
    
}

public extension UIColor {
    
    static var random: UIColor {
        return .color(red: .random(in: 0 ..< 256), green: .random(in: 0 ..< 256), blue: .random(in: 0 ..< 256))
    }
    
    static func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        .init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

public extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1) {
        
        var string = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if string.lowercased().hasPrefix("0x") {
            string = string.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = string.replacingOccurrences(of: "#", with: "")
        }
        
        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        // 断言，条件满足才往下执行
        assert(string.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: string).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
        
    }
    
}
