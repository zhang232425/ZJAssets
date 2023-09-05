//
//  UIFont+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

// MARK: - Regular
public extension UIFont {
    
    static var regular5: UIFont { .regular(5.auto) }
    static var regular6: UIFont { .regular(6.auto) }
    static var regular7: UIFont { .regular(7.auto) }
    static var regular8: UIFont { .regular(8.auto) }
    static var regular9: UIFont { .regular(9.auto) }
    static var regular10: UIFont { .regular(10.auto) }
    static var regular11: UIFont { .regular(11.auto) }
    static var regular12: UIFont { .regular(12.auto) }
    static var regular13: UIFont { .regular(13.auto) }
    static var regular14: UIFont { .regular(14.auto) }
    static var regular15: UIFont { .regular(15.auto) }
    static var regular16: UIFont { .regular(16.auto) }
    static var regular17: UIFont { .regular(17.auto) }
    static var regular18: UIFont { .regular(18.auto) }
    static var regular19: UIFont { .regular(19.auto) }
    static var regular20: UIFont { .regular(20.auto) }
    static var regular21: UIFont { .regular(21.auto) }
    static var regular22: UIFont { .regular(22.auto) }
    static var regular23: UIFont { .regular(23.auto) }
    static var regular24: UIFont { .regular(24.auto) }
    static var regular25: UIFont { .regular(25.auto) }
    static var regular26: UIFont { .regular(26.auto) }
    static var regular27: UIFont { .regular(27.auto) }
    static var regular28: UIFont { .regular(28.auto) }
    static var regular29: UIFont { .regular(29.auto) }
    static var regular30: UIFont { .regular(30.auto) }
    
}

// MARK: - Medium
public extension UIFont {
    
    static var medium5: UIFont { .medium(5.auto) }
    static var medium6: UIFont { .medium(6.auto) }
    static var medium7: UIFont { .medium(7.auto) }
    static var medium8: UIFont { .medium(8.auto) }
    static var medium9: UIFont { .medium(9.auto) }
    static var medium10: UIFont { .medium(10.auto) }
    static var medium11: UIFont { .medium(11.auto) }
    static var medium12: UIFont { .medium(12.auto) }
    static var medium13: UIFont { .medium(13.auto) }
    static var medium14: UIFont { .medium(14.auto) }
    static var medium15: UIFont { .medium(15.auto) }
    static var medium16: UIFont { .medium(16.auto) }
    static var medium17: UIFont { .medium(17.auto) }
    static var medium18: UIFont { .medium(18.auto) }
    static var medium19: UIFont { .medium(19.auto) }
    static var medium20: UIFont { .medium(20.auto) }
    static var medium21: UIFont { .medium(21.auto) }
    static var medium22: UIFont { .medium(22.auto) }
    static var medium23: UIFont { .medium(23.auto) }
    static var medium24: UIFont { .medium(24.auto) }
    static var medium25: UIFont { .medium(25.auto) }
    static var medium26: UIFont { .medium(26.auto) }
    static var medium27: UIFont { .medium(27.auto) }
    static var medium28: UIFont { .medium(28.auto) }
    static var medium29: UIFont { .medium(29.auto) }
    static var medium30: UIFont { .medium(30.auto) }
    
}

// MARK: - Black
public extension UIFont {
    
    static var black5: UIFont { .black(5.auto) }
    static var black6: UIFont { .black(6.auto) }
    static var black7: UIFont { .black(7.auto) }
    static var black8: UIFont { .black(8.auto) }
    static var black9: UIFont { .black(9.auto) }
    static var black10: UIFont { .black(10.auto) }
    static var black11: UIFont { .black(11.auto) }
    static var black12: UIFont { .black(12.auto) }
    static var black13: UIFont { .black(13.auto) }
    static var black14: UIFont { .black(14.auto) }
    static var black15: UIFont { .black(15.auto) }
    static var black16: UIFont { .black(16.auto) }
    static var black17: UIFont { .black(17.auto) }
    static var black18: UIFont { .black(18.auto) }
    static var black19: UIFont { .black(19.auto) }
    static var black20: UIFont { .black(20.auto) }
    static var black21: UIFont { .black(21.auto) }
    static var black22: UIFont { .black(22.auto) }
    static var black23: UIFont { .black(23.auto) }
    static var black24: UIFont { .black(24.auto) }
    static var black25: UIFont { .black(25.auto) }
    static var black26: UIFont { .black(26.auto) }
    static var black27: UIFont { .black(27.auto) }
    static var black28: UIFont { .black(28.auto) }
    static var black29: UIFont { .black(29.auto) }
    static var black30: UIFont { .black(30.auto) }
    
}

// MARK: - Bold
public extension UIFont {
    
    static var bold5: UIFont { .bold(5.auto) }
    static var bold6: UIFont { .bold(6.auto) }
    static var bold7: UIFont { .bold(7.auto) }
    static var bold8: UIFont { .bold(8.auto) }
    static var bold9: UIFont { .bold(9.auto) }
    static var bold10: UIFont { .bold(10.auto) }
    static var bold11: UIFont { .bold(11.auto) }
    static var bold12: UIFont { .bold(12.auto) }
    static var bold13: UIFont { .bold(13.auto) }
    static var bold14: UIFont { .bold(14.auto) }
    static var bold15: UIFont { .bold(15.auto) }
    static var bold16: UIFont { .bold(16.auto) }
    static var bold17: UIFont { .bold(17.auto) }
    static var bold18: UIFont { .bold(18.auto) }
    static var bold19: UIFont { .bold(19.auto) }
    static var bold20: UIFont { .bold(20.auto) }
    static var bold21: UIFont { .bold(21.auto) }
    static var bold22: UIFont { .bold(22.auto) }
    static var bold23: UIFont { .bold(23.auto) }
    static var bold24: UIFont { .bold(24.auto) }
    static var bold25: UIFont { .bold(25.auto) }
    static var bold26: UIFont { .bold(26.auto) }
    static var bold27: UIFont { .bold(27.auto) }
    static var bold28: UIFont { .bold(28.auto) }
    static var bold29: UIFont { .bold(29.auto) }
    static var bold30: UIFont { .bold(30.auto) }
    
}

public extension UIFont {
    
    static func regular(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .medium)
    }
    
    static func black(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .black)
    }
    
    static func bold(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .bold)
    }
    
}

