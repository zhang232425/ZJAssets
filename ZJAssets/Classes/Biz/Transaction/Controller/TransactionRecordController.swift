//
//  TransactionRecordController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import UIKit
import JXPagingView
import JXSegmentedView

class TransactionRecordController: DepositBaseController {
    
    enum RecordType: Int {
        case all              = 0
        case deposit          = 1
        case corporateDeposit = 2
    }
    
    private let filterCategory = FilterCategory()
    
    private var type: RecordType
    
    private lazy var contentView = JXPagingListRefreshView(delegate: self)
    
    private lazy var segmentView = ZJSegmentedView().then {
        $0.titles = [Locale.processing.localized, Locale.history.localized]
        $0.listContainer = contentView.listContainerView
        $0.delegate = self
    }
    
    init(type: RecordType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
    }

}

private extension TransactionRecordController {
    
    func config() {
        
        navigationItem.title = Locale.transactionRecord.localized
        
    }
    
    func setupViews() {
    
        segmentView.add(to: view).snp.makeConstraints {
            $0.top.equalToSafeArea(of: view)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40.auto)
        }
        
        contentView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom)
            $0.left.right.equalTo(segmentView)
            $0.bottom.equalToSuperview()
        }
        
    }
    
}

extension TransactionRecordController: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        0
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        .init()
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        0
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        .init()
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return 2
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        
        switch type {
            
        case .all:
            
            if index == 0 {
                return DepositInProgressController()
            }
            
            return DepositHistoryController(category: nil)
            
        case .deposit:
            
            if index == 0 {
                return DepositInProgressController()
            }
            
            return DepositHistoryController(category: filterCategory)
            
        case .corporateDeposit:
            
            if index == 0 {
                return DepositInProgressController()
            }
            
            return DepositHistoryController(category: nil)
            
        }
        
    }
    
}

extension TransactionRecordController: JXSegmentedViewDelegate {}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}
