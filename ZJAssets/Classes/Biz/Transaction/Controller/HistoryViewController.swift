//
//  HistoryViewController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import RxSwift
import RxDataSources
import ZJCommonDefines
import ZJDevice

class HistoryViewController: TransactionListBaseController {
    
    private lazy var titleView = HistoryTitleView().then {
        $0.isHidden = true
        $0.periodClickHandler = { [weak self] in self?.navigationToPeriod() }
        $0.filterClickHandler = { [weak self] in self?.navigationToFilter() }
    }
    
    private var oldEntranceView: UIView?
    
    private var bubbleView: HistoryBubbleView?
    
    private let viewModel: HistoryVM
    
    private var dataSource: RxTableViewSectionedReloadDataSource<HistoryVM.Section>!
    
    init(category: FilterCategory) {
        viewModel = .init(category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func showNoSignalView(_: ()) {
        super.showNoSignalView(())
        noSignalView?.refreshAction = { [weak self] in
            self?.viewModel.fetchAction.execute()
        }
    }

}

extension HistoryViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.isPeriodSelect {
            titleView.periodTitle = dataSource[indexPath.section].model
        }
    }
    
}

private extension HistoryViewController {
    
    func navigationToFilter() {
        
        let vc = TransactionFilterController(category: viewModel.filterCategory,
                                             param: viewModel.filterParam) { [weak self] in
            
            self?.viewModel.filterParam = $0
            
            if $0.productType == 0, $0.tradeType == 0 {
                self?.titleView.state = .normal
            } else {
                self?.titleView.state = .highlight
            }
            
        }
        
        present(vc, animated: true)
        
    }
    
    func navigationToPeriod() {
        
        let vc = TransactionPeriodController(viewModel: viewModel.filterPeriodVM) { [weak self] in
            
            switch $0 {
            case .month(let start, let end):
                
                self?.titleView.periodTitle = start?.monthFormat
                
                self?.viewModel.handlePeriodSelect(start: start, end: end)
                
            case .period(let start, let end):
                
                if let start = start?.periodFormat, let end = end?.periodFormat {
                    self?.titleView.periodTitle = "\(start)-\(end)"
                }
                
                self?.viewModel.handlePeriodSelect(start: start, end: end?.nextDay)
                
            }
            
        }
        
        present(vc, animated: true)
        
    }
    
    @objc
    func navigationToOldHistory() {
        
        bubbleView?.removeFromSuperview()
        bubbleView = nil
        
//        let vc = HistoryViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func navigationToHistoryDetail(item: TransactionListItem) {
        
        print(#function)
        
    }
    
}

private extension HistoryViewController {
    
    func bindViewModel() {
        
        bindTableViewDataSource()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.addPullToRefresh.bind(to: viewModel.reloadAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.addInfinityScroll.bind(to: viewModel.loadMoreAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HistoryVM.SectionItem.self).subscribe(onNext: { [weak self] in
            switch $0 {
            case .item(let info):
                self?.navigationToHistoryDetail(item: info.item)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchAction.elements.map { _ in}
            .subscribeNext(weak: self, HistoryViewController.updateUI)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.elements
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.contentOffset = .zero
            }).disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, HistoryViewController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in}
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, HistoryViewController.showNoSignalView)
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
            .subscribeNext(weak: self, HistoryViewController.doError)
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
                
            case .empty:
                
                let cell: TransactionEmptyCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                                
                return cell
                
            case .noMoreData:
                
                let cell: NoMoreDataCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                
                return cell
                
            }
            
        })
        
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    func updateUI(_ :()) {
        
        titleView.isHidden = false
        tableView.isHidden = false
        
        oldEntranceView?.removeFromSuperview()
        
        bubbleView?.removeFromSuperview()
        bubbleView = nil
        
        if viewModel.showOldEntrance {
            
            tableView.snp.remakeConstraints {
                $0.top.equalTo(titleView.snp.bottom)
                $0.left.right.equalToSuperview()
            }
            
            let bottomView = OldEntranceView()
            
            bottomView.add(to: view).then {
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigationToOldHistory)))
                oldEntranceView = $0
            }.snp.makeConstraints {
                $0.top.equalTo(tableView.snp.bottom)
                $0.left.greaterThanOrEqualToSuperview()
                $0.right.lessThanOrEqualToSuperview()
                $0.centerX.equalToSuperview()
                if #available(iOS 11.0, *) {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide)
                } else {
                    $0.bottom.equalToSuperview()
                }
            }
            
            if !UserDefaults.standard.isDisplayTradeBubble {
                
                UserDefaults.standard.isDisplayTradeBubble = true
                
                HistoryBubbleView().add(to: view).then {
                    bubbleView = $0
                }.snp.makeConstraints {
                    $0.bottom.equalTo(bottomView.snp.top).offset(12)
                    $0.centerX.equalTo(bottomView)
                }
                
            }
            
        } else {
            
            tableView.snp.remakeConstraints {
                $0.top.equalTo(titleView.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
            
        }
        
    }
    
    func setupViews() {
        
        titleView.add(to: view).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(46)
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
    
}

extension HistoryViewController {
    
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
