//
//  DepositIncomeController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/22.
//

import UIKit
import RxSwift
import RxDataSources
import ZJDevice

class DepositIncomeController: DepositBaseController {
    
    private let viewModel: DepositIncomeViewModel
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, DepositIncomeViewModel.SectionItem>>!
    
    // MARK: - Lazy load
    private lazy var tableView = UITableView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 100
        $0.registerCell(DepositIncomeHeaderCell.self)
        $0.registerCell(DepositIncomeTitleCell.self)
        $0.registerCell(DepositIncomeItemCell.self)
        $0.registerCell(DepositIncomeItemStatusCell.self)
        $0.registerCell(TransactionEmptyCell.self)
    }
    
    private lazy var tipView = DepositIncomeTipView().then {
        $0.isHidden = true
    }
    
    init(assets: DepositAssets) {
        self.viewModel = .init(assets: assets)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindViewModel()
    }
    
}

private extension DepositIncomeController {
    
    func config() {
        
        navigationItem.title = viewModel.title
        
    }
    
    func setupViews() {
        
        let topView = DepositTopView()
        
        topView.add(to: view).snp.makeConstraints {
            $0.top.self.right.equalToSuperview()
            $0.height.equalTo(topView.snp.width).multipliedBy(0.3)
        }
        
        tableView.add(to: view).snp.makeConstraints {
            $0.top.equalToSafeArea(of: view)
            $0.left.right.equalToSuperview()
        }
        
        tipView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.left.greaterThanOrEqualToSuperview()
            $0.right.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSafeArea(of: view)
        }
        
    }
    
    func bindViewModel() {
        
        bindTableViewDataSource()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.addPullToRefresh.bind(to: viewModel.reloadAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.addInfinityScroll.bind(to: viewModel.loadMoreAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DepositIncomeViewModel.SectionItem.self).subscribe(onNext: { [weak self] in
            switch $0 {
            case .item(let info), .status(let info):
                self?.navigationOrderDetail(info: info)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.fetchAction.elements.map { _ in }
            .subscribeNext(weak: self, DepositIncomeController.updateUI)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, DepositIncomeController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, DepositIncomeController.showNoSignalView)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.reloadAction.errors,
                         viewModel.loadMoreAction.errors)
        .subscribeNext(weak: self, DepositIncomeController.doError).disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements.map { _ in },
                         viewModel.fetchAction.errors.map { _ in },
                         viewModel.reloadAction.elements.map { _ in },
                         viewModel.reloadAction.errors.map { _ in })
        .bind(to: tableView.rx.endPullToRefresh).disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements,
                         viewModel.reloadAction.elements,
                         viewModel.loadMoreAction.elements,
                         viewModel.fetchAction.errors.map { _ in false },
                         viewModel.reloadAction.errors.map { _ in false },
                         viewModel.loadMoreAction.errors.map { _ in true })
        .bind(to: tableView.rx.endInfinityScroll).disposed(by: disposeBag)
        
        viewModel.fetchAction.execute()
        
    }
    
    func bindTableViewDataSource() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
    
            switch item {
                
            case .header(let val):
                
                let cell: DepositIncomeHeaderCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.item = val
                return cell
                
            case .title:
                
                let cell: DepositIncomeTitleCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                return cell
                
            case .item(let val):
                
                let cell: DepositIncomeItemCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                
                cell.item = val
                
                return cell
                
            case .status(let val):
                
                let cell: DepositIncomeItemStatusCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.item = val
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

private extension DepositIncomeController {
    
    func updateUI(_ :()) {
        tipView.isHidden = false
        tableView.isHidden = false
    }
    
    func navigationOrderDetail(info: DepositIncome) {
        
        let vc = OrderDetailViewController(productId: info.productId, orderId: info.orderId)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension DepositIncomeController: UITableViewDelegate {
    
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
