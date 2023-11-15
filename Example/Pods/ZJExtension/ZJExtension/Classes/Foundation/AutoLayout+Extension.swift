//
//  AutoLayout+Extension.swift
//  ZJExtension
//
//  Created by Jercan on 2023/11/8.
//

import SnapKit

public extension ConstraintMakerExtendable {
    
    @discardableResult
    func equalToSafeArea(of other: ConstraintRelatableTarget,
                                _ file: String = #file,
                                _ line: UInt = #line) -> ConstraintMakerEditable {

        let target: ConstraintRelatableTarget
        
        if let v = other as? UIView, #available(iOS 11.0, *) {
            target = v.safeAreaLayoutGuide
        } else {
            target = other
        }
        
        return equalTo(target, file, line)
        
    }

}
