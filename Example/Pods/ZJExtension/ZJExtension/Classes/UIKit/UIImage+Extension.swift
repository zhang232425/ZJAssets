//
//  UIImage+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

public extension UIImage {
    
    var round: UIImage? {
        
        UIGraphicsBeginImageContext(size)
        
        defer { UIGraphicsEndImageContext() }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        ctx?.addEllipse(in: rect)
        
        ctx?.clip()
        
        draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
}

public extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = .init(width: 1, height: 1)) {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.translateBy(x: 0.0, y: -size.height)
        
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        color.setFill()
        
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        
        guard let aCgImage = image?.cgImage else { return nil }
        
        self.init(cgImage: aCgImage)
        
    }
    
}

public extension UIImage {
    
    convenience init?(name: String, bundle: Bundle) {
        
        let bundleName = bundle.infoDictionary?[kCFBundleNameKey as String] as? String
        
        if let resourceBundle = bundle.path(forResource: bundleName, ofType: "bundle").flatMap(Bundle.init) {
            self.init(named: name, in: resourceBundle, compatibleWith: nil)
        } else {
            self.init(named: name, in: bundle, compatibleWith: nil)
        }
        
    }
    
}

