//
//  String+Extension.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/25.
//

import ZJExtension

extension String: NamespaceWrappable {}

extension NamespaceWrapper where T == String {
    
    func isPhoneNumPrefix() -> Bool {
        return warppedValue.hasPrefix("08")
    }
    
    /// 手机号码位数
    func isPhoneNumLength() -> Bool {
        return (10...13).contains(warppedValue.count)
    }
    
    /// 密码位数
    func isPasswordLength() -> Bool {
        return (8...16).contains(warppedValue.count)
    }
    
    /// 密码正确性
    func isPassword() -> Bool {
        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regextestpwd = NSPredicate(format: "SELF MATCHES %@", pwd)
        if (regextestpwd.evaluate(with: warppedValue) == true) {
            return true
        } else {
            return false
        }
    }
    
    func sizeWithFont(_ font: UIFont, maxSize: CGSize) -> CGSize {
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let rect = warppedValue.boundingRect(with: maxSize,
                                             options: .usesLineFragmentOrigin,
                                             attributes: attributes,
                                             context: nil)
        
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    func phoneFormat() -> String {
        //移除所有空格
        let str = warppedValue.trimWhitespacesAndNewlines
        
        guard str.count >= 6 else { return str }
        
        return str.dd.substring(to: 2) + "****" + str.dd.substring(from: str.count - 4)
    }
    
    /// 截取Index以前的字符串
    func substring(to index: Int) -> String {
        
        let star = warppedValue.startIndex
        
        let index = warppedValue.index(star, offsetBy: index)
        
        return String(warppedValue[..<index])
    }
    
    /// 截取Index以后的字符串
    func substring(from index: Int) -> String {
        
        let star = warppedValue.startIndex
        
        let index = warppedValue.index(star, offsetBy: index)
        
        return String(warppedValue[index...])
    }
    
    
    
}
