//
//  DepositInProgressController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/23.
//

import UIKit
import RxDataSources
import RxSwift
import ZJDevice
import ZJCommonDefines

class DepositInProgressController: TransactionListBaseController {

    private let viewModel = DepositInProgressVM()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, DepositInProgressVM.SectionItem>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

}

private extension DepositInProgressController {
    
    func setupViews() {
        
        tableView.add(to: view).then {
            $0.registerCell(TransactionEmptyCell.self)
            $0.registerCell(TransactionItemCell.self)
            $0.registerCell(NoMoreDataCell.self)
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        bindTableViewDataSource()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.addPullToRefresh.bind(to: viewModel.reloadAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.addInfinityScroll.bind(to: viewModel.loadMoreAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DepositInProgressVM.SectionItem.self).subscribe(onNext: { [weak self] in
            switch $0 {
            case .item(let info):
                self?.navigationToHistoryDetail(item: info.item)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchAction.elements
            .delay(.microseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.contentOffset = .zero
            }).disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, DepositInProgressController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in }
            .delay(.microseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, DepositInProgressController.showNoSignalView)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements.map { _ in },
                         viewModel.fetchAction.errors.map { _ in },
                         viewModel.reloadAction.elements.map { _ in},
                         viewModel.reloadAction.errors.map { _ in })
        .bind(to: tableView.rx.endPullToRefresh)
        .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.reloadAction.errors,
                         viewModel.loadMoreAction.errors)
        .subscribeNext(weak: self, DepositInProgressController.doError)
        .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements,
                         viewModel.reloadAction.elements,
                         viewModel.loadMoreAction.elements,
                         viewModel.fetchAction.errors.map { _ in false },
                         viewModel.reloadAction.errors.map { _ in false },
                         viewModel.loadMoreAction.errors.map { _ in false })
        .bind(to: tableView.rx.endInfinityScroll)
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(ZJNotification.refreshAssetsPage).subscribe(onNext: { [weak self] _ in
            self?.viewModel.reloadAction.execute()
        }).disposed(by: disposeBag)
        
        viewModel.fetchAction.execute()
        
    }
    
    func bindTableViewDataSource() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
            
            switch item {
            case .item(let val):
                
                let cell: TransactionItemCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                
                cell.viewModel = val
                                
                return cell
                
            case .noMoreData:
                
                let cell: NoMoreDataCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                                
                return cell
                
            case .empty:
                
                let cell: TransactionEmptyCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                                
                return cell
                
            }
            
        })
        
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}

private extension DepositInProgressController {
    
    func navigationToHistoryDetail(item: TransactionListItem) {
        
        
    }
    
}

extension DepositInProgressController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch dataSource[indexPath] {
        case .empty:
            if ZJDevice().isXseries {
                return tableView.bounds.height - 34
            }
            return tableView.bounds.height
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    
    
}

