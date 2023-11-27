//
//  BaseTableViewCell.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/20.
//

import UIKit
import ZJExtension

class BaseTableViewCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViews() {
        fatalError("initialize() has not been implemented")
    }

}
