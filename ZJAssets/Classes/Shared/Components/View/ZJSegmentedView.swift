//
//  ZJSegmentedView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/23.
//

import UIKit
import JXSegmentedView
import Then

class ZJSegmentedView: JXSegmentedView {

    private lazy var dotDataSource = JXSegmentedDotDataSource().then {
        $0.titleSelectedColor = UIColor(hexString: "#FF7D0F")
        $0.titleNormalColor = UIColor(hexString: "#333333")
        $0.dotSize = .init(width: 8, height: 8)
        $0.dotColor = UIColor(hexString: "#FF3737")
        $0.dotOffset = .init(x: 2, y: 0)
        $0.titleNormalFont = .regular14
        $0.titleSelectedFont = .medium14
    }
    
    var titles: [String] = [] {
        didSet {
            dotDataSource.titles = titles
            dotDataSource.dotStates = titles.map { _ in false}
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    

}

private extension ZJSegmentedView {
    
    func setupViews() {
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(hexString: "#FF7D0F")
        lineView.indicatorHeight = 3.auto
        lineView.indicatorWidth = 50.auto
        indicators = [lineView]
        backgroundColor = .white
        dataSource = dotDataSource
        isContentScrollViewClickTransitionAnimationEnabled = false
        
    }
    
}

extension JXSegmentedBaseDataSource: Then {}
