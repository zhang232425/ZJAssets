//
//  DepositAssetsController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/17.
//

import UIKit
import RxSwift
import RxDataSources
import ZJExtension

class DepositAssetsController: DepositBaseController {
    
    private let viewModel = DepositAssetsViewModel()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, DepositAssetsViewModel.SectionItem>>!
        
    private lazy var backgroundView = AssetsBackgroundHeaderView().then {
        $0.isUserInteractionEnabled = false
        $0.layer.zPosition = -1
        $0.colors = [UIColor(hexString: "FFF8F0"), .white]
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 100
        $0.registerCell(DepositItemCell.self)
        $0.registerCell(DepositItemRenewCell.self)
        $0.registerCell(DepositItemRenewingCell.self)
        $0.registerCell(DepositPendingVACell.self)
        $0.registerCell(DepositUnpaidCell.self)
        $0.registerCell(DepositPendingSignatureCell.self)
        $0.registerCell(DepositHeaderCell.self)
        $0.registerCell(DepositFuncCell.self)
        $0.registerCell(DepositFuncAppointCell.self)
        $0.registerCell(DepositEmptyCell.self)
        $0.registerCell(DepositSeparatorCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

}

private extension DepositAssetsController {
    
    func setupViews() {
        
        let imageView = UIImageView(image: .named("deposit_top"))
        
        imageView.add(to: view).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        UIView().add(to: imageView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.statusBarHeight)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44.auto)
        }
        
        backgroundView.add(to: tableView).then {
            tableView.sendSubview(toBack: $0)
        }.snp.makeConstraints {
            $0.top.centerX.width.equalToSuperview()
            $0.height.equalTo(backgroundView.snp.width).multipliedBy(0.52)
        }
        
        tableView.add(to: view).snp.makeConstraints {
            $0.top.bottom.equalToSafeArea(of: view)
            $0.left.right.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        navigationItem.title = viewModel.title
        
        bindTableViewDataSource()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.contentOffset.map { $0.y }.subscribe(onNext: { [weak self] in
            self?.backgroundView.adjustPositionBy(offsetY: $0)
        }).disposed(by: disposeBag)
        
        tableView.rx.addPullToRefresh.bind(to: viewModel.reloadAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.addInfinityScroll.bind(to: viewModel.loadMoreAction.inputs).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DepositAssetsViewModel.SectionItem.self).subscribe(onNext: {
            print("点击了单元格 === \($0)")
        }).disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements,
                         viewModel.fetchAction.errors.map { _ in },
                         viewModel.reloadAction.elements.map { _ in },
                         viewModel.reloadAction.errors.map { _ in })
        .bind(to: tableView.rx.endPullToRefresh).disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors.map { _ in false},
                         viewModel.reloadAction.errors.map { _ in false},
                         viewModel.loadMoreAction.elements,
                         viewModel.loadMoreAction.errors.map { _ in true })
        .bind(to: tableView.rx.endInfinityScroll).disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, DepositAssetsController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in }
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, DepositAssetsController.showNoSignalView)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.reloadAction.errors,
                         viewModel.loadMoreAction.errors)
        .subscribeNext(weak: self, DepositAssetsController.doError)
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UserDefaults.depositSecureTextStateDidChange)
            .map { $0.object as? Bool }
            .unwrap().bind(to: viewModel.isSecureText)
            .disposed(by: disposeBag)
        
        
        viewModel.fetchAction.execute()
        
    }
    
    func bindTableViewDataSource() {
    
        dataSource = .init(configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
            
            switch item {
                
            case .header(let info, let clickAction):
                
                let cell: DepositHeaderCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.info = info
                cell.secureClickAction = clickAction
                return cell
                
            case .function(let signCount, let isAppoint):
                
                if isAppoint {
                    let cell: DepositFuncAppointCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                    cell.signCount = signCount
                    cell.incomeHandler = { self?.navigationToIncomeList() }
                    cell.transactionHandler = { self?.navigationToTransaction() }
                    cell.signHandler = { self?.navigationToAppoint() }
                    cell.appointHandler = { self?.navigationToAppoint() }
                    return cell
                }
                
                let cell: DepositFuncCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.signCount = signCount
                cell.incomeHandler = { self?.navigationToIncomeList() }
                cell.transactionHandler = { self?.navigationToTransaction() }
                cell.signHandler = { self?.navigationToAppoint() }
                return cell
                
            case .separator(let height):
                
                let cell: DepositSeparatorCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.height = height
                return cell
                
            case .item(let item):
                
                let cell: DepositItemCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.item = item
                return cell
                
            case .itemRenew(let val):
                
                if val.order.status == .unpaid {
                    if val.order.payId == 0 {
                        let cell: DepositPendingVACell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                        cell.item = val
                        cell.needRefresh = { [weak self] in
                            self?.tableView.reloadData()
                        }
                        return cell
                    }
                    let cell: DepositUnpaidCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                    cell.item = val
                    return cell
                } else if val.order.status == .investWaitSign {
                    let cell: DepositPendingSignatureCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                    cell.item = val
                    return cell
                } else {
                    let cell: DepositItemRenewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                    cell.item = val
                    cell.renewHandler = { self?.navigationToRenewProductList(item: $0) }
                    cell.turnOnHandler = { self?.handleTurnOnAction(item: $0) }
                    cell.overdueBlock = { self?.handleOverdueAlert(overdueTitle: $0, overdueExplain: $1) }
                    return cell
                }
                
            case .itemRenewing(let val):
                
                let cell: DepositItemRenewingCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.item = val
                return cell
                
            case .empty:
                
                let cell: DepositEmptyCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.clickHandler = { self?.navigationToProductList() }
                return cell
                
            
                
            }
            
        })
        
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    
}

private extension DepositAssetsController {
    
    func navigationToRenewProductList(item: DepositListItem) {
        print(#function)
    }
    
    func handleTurnOnAction(item: DepositListItem) {
        print(#function)
    }
    
    func handleOverdueAlert(overdueTitle: String?, overdueExplain: String?) {
        print(#function)
    }
    
    func navigationToTransaction() {
        
        let vc = TransactionRecordController(type: .deposit)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func navigationToIncomeList() {
        
        let vc = DepositIncomeController(assets: viewModel.assetsInfo)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func navigationToAppoint() {
        print(#function)
    }
    
    func navigationToProductList() {
        print(#function)
    }
    
}

extension DepositAssetsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch dataSource[indexPath] {
        case .empty:
            return max((tableView.bounds.height - 200), 240)

        default:
            return UITableViewAutomaticDimension
            
        }
        
    }
    
}
