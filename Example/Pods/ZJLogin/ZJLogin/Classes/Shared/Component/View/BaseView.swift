//
//  BaseView.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/13.
//

import UIKit
import SnapKit
import ZJExtension
import RxSwift
import RxCocoa

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
