//
//  HistoryBubbleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit

class HistoryBubbleView: BaseView {
    
    override func setupViews() {
        
        backgroundColor = .clear
        
        let contentView = AssetsBubbleContentView()
        contentView.label.text = Locale.tradeOldTip.localized
        
        contentView.closeHandler = { [weak self] in
            self?.removeFromSuperview()
        }
        
        contentView.add(to: self).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
                
        let arrowView = UIImageView(image: .named("icon_bubble_arrow"))
        
        arrowView.add(to: self).snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalTo(20.auto)
            $0.height.equalTo(7.auto)
        }
        
    }

}

