//
//  Auto.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
private let designWidth: CGFloat = 375

public extension Double {
    var auto: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return ceil(CGFloat(self) * screenWidth / designWidth)
        }
        return self
    }
}

public extension Int {
    var auto: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return ceil(CGFloat(self) * screenWidth / designWidth)
        }
        return CGFloat(self)
    }
}

public extension CGFloat {
    var auto: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return ceil(CGFloat(self) * screenWidth / designWidth)
        }
        return self
    }
}

