//
//  ZJAssetsViewController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/9/5.
//

import UIKit

class ZJAssetsViewController: BaseViewController {
    
    private lazy var label = UILabel().then {
        $0.text = "我是资产业"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
    }
    

}

private extension ZJAssetsViewController {
    
    func config() {
        
        view.backgroundColor = .white
        
    }
    
    func setupViews() {
        
        label.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
}
