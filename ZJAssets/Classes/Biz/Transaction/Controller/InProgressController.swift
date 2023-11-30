//
//  InProgressController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import ZJCommonDefines
import ZJDevice

class InProgressController: TransactionListBaseController {
    
    private let viewModel: InProgressVM

    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, InProgressVM.SectionItem>>!
    
    // MARK: - Lazy load
    private lazy var titleView = InProgressTitleView().then {
        $0.isHidden = true
        $0.itemSelectHandler = { [weak self] in
            self?.viewModel.selectedIndex = $0
        }
    }

    // MARK: - Init method
    init(category: FilterCategory) {
        self.viewModel = .init(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func showNoSignalView(_: ()) {
        super.showNoSignalView(())
        noSignalView?.refreshAction = { [weak self] in
            self?.viewModel.fetchAction.execute()
        }
    }
    
}

private extension InProgressController {
    
    func setupViews() {
        
        titleView.add(to: view).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(46.auto)
        }
        
        tableView.add(to: view).then {
            $0.isHidden = true
            $0.registerCell(TransactionEmptyCell.self)
            $0.registerCell(TransactionItemCell.self)
            $0.registerCell(NoMoreDataCell.self)
        }.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        bindTableViewDataSource()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.addPullToRefresh.bind(to: viewModel.reloadAction.inputs).disposed(by: disposeBag)
                
        tableView.rx.addInfinityScroll.bind(to: viewModel.loadMoreAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(InProgressVM.SectionItem.self).subscribe(onNext: { [weak self] in
            switch $0 {
            case .item(let info):
                self?.navigationToHistoryDetail(item: info.item)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchAction.elements.map { _ in}
            .subscribeNext(weak: self, InProgressController.updateUI)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.elements
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.contentOffset = .zero
            }).disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, InProgressController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in}
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, InProgressController.showNoSignalView)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements.map { _ in},
                         viewModel.fetchAction.errors.map { _ in},
                         viewModel.reloadAction.elements.map { _ in},
                         viewModel.reloadAction.errors.map { _ in})
            .bind(to: tableView.rx.endPullToRefresh)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.reloadAction.errors,
                         viewModel.loadMoreAction.errors)
            .subscribeNext(weak: self, InProgressController.doError)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements,
                         viewModel.reloadAction.elements,
                         viewModel.loadMoreAction.elements,
                         viewModel.fetchAction.errors.map { _ in false},
                         viewModel.reloadAction.errors.map { _ in false},
                         viewModel.loadMoreAction.errors.map { _ in true})
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
    
    func updateUI(_ : ()) {
        
        if !titleView.titles.isEmpty {
            return
        }
        
        titleView.titles = viewModel.filterTitles
        
        titleView.isHidden = false
        
        tableView.isHidden = false
        
    }
    
}

private extension InProgressController {
    
    func navigationToHistoryDetail(item: TransactionListItem) {
        
        switch item.jumpType {
            
        case .withdrawDetail:
            let vc = HistoryDetailViewController(id: item.refId)
            navigationController?.pushViewController(vc, animated: true)
            
        case .depositDetail:
            let vc = OrderDetailViewController(productId: item.productId, orderId: item.refId)
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}

extension InProgressController {
    
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
