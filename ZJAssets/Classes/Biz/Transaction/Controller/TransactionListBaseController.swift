//
//  TransactionListBaseController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/23.
//

import UIKit
import ZJHUD
import JXPagingView

class TransactionListBaseController: BaseViewController {
    
    private var listViewDidScrollCallBack: ((UIScrollView) -> ())?
    
    private(set) var noSignalView: ZJNoSignalView?
    
    private(set) lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func doProgress(_ executing: Bool) {
        
        noSignalView?.removeFromSuperview()
        
        view.endEditing(true)
        
        if executing {
            hud?.hide()
            hud = ZJHUDView()
            hud?.dimBackground = true
            hud?.showProgress(in: view)
        } else {
            hud?.hide()
        }
        
    }
    
    func showNoSignalView(_ :()) {
        
        let errorView = noSignalView ?? ZJNoSignalView()
        
        errorView.removeFromSuperview()
        
        errorView.add(to: view).then {
            noSignalView = $0
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

}

extension TransactionListBaseController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallBack?(scrollView)
    }
    
}

extension TransactionListBaseController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        view
    }
    
    func listScrollView() -> UIScrollView {
        tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallBack = callback
    }
    
}
