//
//  ZJScrollViewController.swift
//  ZJBase
//
//  Created by Jercan on 2023/11/9.
//

import UIKit

open class ZJScrollViewController: ZJViewController {
    
    public private(set) final var scrollView = UIScrollView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        createScrollView()
        
    }
    
    private func createScrollView() {
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            } else {
                $0.top.equalTo(topLayoutGuide.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
    }

}
