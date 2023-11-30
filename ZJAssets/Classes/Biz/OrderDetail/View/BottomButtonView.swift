//
//  BottomButtonView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit
import ZJExtension

class BottomButtonView: BaseView {

    var title: String? {
        didSet { setData() }
    }
    
    var clickAction: (() -> ())?
    
    // 默认隐藏分割线
    var hideSepector = true {
        didSet {
            sepectorView.isHidden = hideSepector
        }
    }
    
    private var sepectorView = UIView(backgroundColor: .init(hexString: "DEDEDE"))
    
    private var button = UIButton(backgroundColor: .init(hexString: "FF7D0F"), textColor: .white, font: UIFont.bold16, cornerRadius: 22.5.auto)
    
    convenience init(title: String?, clickAction: (() -> ())?) {
        self.init()
        self.title = title
        self.clickAction = clickAction
        setData()
    }
    
    override func setupViews() {
        
        backgroundColor = .white
        
        button.add(to: self).snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 16.auto, left: 16.auto, bottom: 20.auto + UIScreen.safeAreaBottom, right: 16.auto))
            $0.height.equalTo(45.auto)
        }
        
        sepectorView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        sepectorView.isHidden = hideSepector
        
        button.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
        
    }
    
    
}

private extension BottomButtonView {
    
    func setData() {
        
        button.setTitle(title, for: .normal)
        
    }
    
    @objc func clickEvent() {
        
        clickAction?()
        
    }
    
}
