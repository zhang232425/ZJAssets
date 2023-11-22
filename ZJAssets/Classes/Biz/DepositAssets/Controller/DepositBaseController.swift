//
//  DepositBaseController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import UIKit

class DepositBaseController: BaseViewController {
    
    private(set) var noSignalView: ZJNoSignalView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .clear), for: .default)
        
    }
    
    override func doProgress(_ executing: Bool) {
        noSignalView?.removeFromSuperview()
        super.doProgress(executing)
    }
    
    func showNoSignalView(_ : ()) {
        
        let errorView = noSignalView ?? ZJNoSignalView()
        
        errorView.removeFromSuperview()
        
        errorView.add(to: view).then {
            noSignalView = $0
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
