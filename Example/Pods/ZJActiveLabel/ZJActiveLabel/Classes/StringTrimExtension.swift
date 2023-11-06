//
//  StringTrimExtension.swift
//  Pods-ZJActiveLabel_Example
//
//  Created by Jercan on 2023/9/15.
//

import Foundation

extension String {

    func trim(to maximumCharacters: Int) -> String {
        "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
    
}
