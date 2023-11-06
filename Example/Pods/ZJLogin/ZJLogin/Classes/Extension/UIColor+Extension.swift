//
//  UIColor+Extension.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/15.
//

import Foundation

extension UIColor: UIStandardizable {}

extension UIStandard where Base: UIColor {
    
    static var black33: UIColor {
        #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // 333333
    }
    
    static var gray66: UIColor {
        #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) // 666666
    }
    
    static var gray99: UIColor {
        #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) // 999999
    }
    
    static var textHint: UIColor {
        #colorLiteral(red: 0.7490196078, green: 0.7450980392, blue: 0.7607843137, alpha: 1) // BFBEC2
    }
    
    static var grayE9: UIColor {
        #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1) // E9E9E9
    }
    
    static var grayF5: UIColor {
        #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) // F5F5F5
    }
    
    static var white: UIColor {
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // FFFFFF
    }
    
    static var orange: UIColor {
        #colorLiteral(red: 1, green: 0.4901960784, blue: 0.05882352941, alpha: 1) // FF7D0F
    }
    
}

extension UIColor {
    
    func withAlpha(_ a: CGFloat) -> UIColor {
        self.withAlphaComponent(a)
    }
}
