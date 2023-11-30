//
//  String+Extension.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/30.
//

import Foundation

extension String: NamespaceWrappable {}

extension NamespaceWrapper where T == String {
    
    func sizeWithFont(_ font: UIFont, maxSize: CGSize) -> CGSize {
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let rect = warppedValue.boundingRect(with: maxSize,
                                             options: .usesLineFragmentOrigin ,
                                             attributes: attributes,
                                             context: nil)
        
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    /// 截取Index以前的字符串
    func substring(to index: Int) -> String {
       
        guard warppedValue.count > index else { return "" }
       
       let star = warppedValue.startIndex
       
       let index = warppedValue.index(star, offsetBy: index)
       
       return String(warppedValue[..<index])
    }

    /// 截取Index以后的字符串
    func substring(from index: Int) -> String {
       
       guard warppedValue.count > index else { return "" }
       
       let star = warppedValue.startIndex
       
       let index = warppedValue.index(star, offsetBy: index)
       
       return String(warppedValue[index...])
    }
    
    /// 截取最后Index位的字符串
    func substring(last index: Int) -> String {
       
        guard warppedValue.count > index else { return "" }
       
        let star = warppedValue.startIndex
        
        let length = warppedValue.count - index
        
        let index = warppedValue.index(star, offsetBy: length)
        
        return String(warppedValue[index...])
    }

    /// 设置高亮富文本
    func setHighlight(keywords: [String]?, font: UIFont, highFont: UIFont? = nil, color: UIColor, highColor: UIColor)-> NSAttributedString {
       
       let attrStr = NSMutableAttributedString(string: warppedValue,
                                               attributes: [.font: font, .foregroundColor: color])
       
       guard let keywords = keywords, !keywords.isEmpty else { return attrStr }
       
       let highFont = highFont ?? font
       
       var location: Int = 0
       var content = warppedValue
       var range = NSRange()
       
       keywords.forEach {
           range = (content as NSString).range(of: $0)
           if range.location != NSNotFound {
               range.location += location
               attrStr.addAttributes([.font: highFont, .foregroundColor: highColor], range: range)
               
               location = range.location + range.length
               
               if content.count > location {
                   content = warppedValue.dd.substring(from: location)
               }
               
           }
       }
       
       return attrStr
    }
    
    var decimalNumber: NSDecimalNumber? {
        
        guard !warppedValue.isEmpty else { return nil }
        
        let val = NSDecimalNumber(string: warppedValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        
        return val == NSDecimalNumber.notANumber ? nil : val
        
    }
    
}
