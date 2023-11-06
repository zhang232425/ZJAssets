//
//  AutoLayout+Extension.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import SnapKit

extension ConstraintMakerExtendable {
    
    @discardableResult
    public func equalToSafeArea(of other: ConstraintRelatableTarget,
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


