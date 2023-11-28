//
//  TransactionTypeController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit
import RxSwift
import RxDataSources
import ZJExtension
import ZJModalTransition
import ZJCommonView

class TransactionTypeController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: TransactionTypeVM
    
    private let confirmAction: (TransactionTypeVM.SectionItem) -> ()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, TransactionTypeVM.SectionItem>>!
    
    private lazy var transition = ZJModalTransition(animator: ZJActionSheetTransitionAnimator(frame: UIScreen.main.bounds, backgroundColor: .init(white: 0, alpha: 0.6)))
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .medium16
        $0.textColor = UIColor(hexString: "#333333")
        $0.textAlignment = .center
        $0.text = viewModel.title
    }
    
    private lazy var tableView = UITableView().then {
        $0.alwaysBounceVertical = false
        $0.separatorStyle = .none
        $0.rowHeight = 51.auto
        $0.registerCell(TransactionTypeCell.self)
    }
    
    private lazy var closeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_close"), for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    init(category: FilterCategory, selectedType: Int, confirmAction: @escaping (TransactionTypeVM.SectionItem) -> ()) {
        viewModel = .init(category, selectedType: selectedType)
        self.confirmAction = confirmAction
        super.init(nibName: nil, bundle: nil)
        transition.prepare(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
}

private extension TransactionTypeController {
    
    func setupViews() {
        
        let contentView = RoundCornerView(radius: 10.auto)
        contentView.corners = [.topLeft, .topRight]
        
        contentView.add(to: view).snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
        }
        
        let topView = UIView()
        
        topView.add(to: contentView).snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(50.auto)
        }
        
        closeButton.add(to: topView).snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.right.equalTo(topView.safeAreaLayoutGuide).inset(5.auto)
            } else {
                $0.right.equalToSuperview().inset(5.auto)
            }
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40.auto)
        }
        
        titleLabel.add(to: topView).snp.makeConstraints {
            $0.right.equalTo(closeButton.snp.left).offset(-5)
            if #available(iOS 11.0, *) {
                $0.left.equalTo(topView.safeAreaLayoutGuide).inset(50.auto)
            } else {
                $0.left.equalToSuperview().inset(50.auto)
            }
            $0.centerY.equalToSuperview()
        }
        
        tableView.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            if #available(iOS 11.0, *) {
                $0.left.right.equalTo(contentView.safeAreaLayoutGuide).inset(16.auto)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
            } else {
                $0.left.right.equalToSuperview().inset(16.auto)
                $0.bottom.equalToSuperview().inset(38.auto)
            }
            $0.height.equalTo(viewModel.contentHeight)
        }
        
    }
    
    func bindViewModel() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
            
            let cell: TransactionTypeCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.item = item
            return cell
            
        })
        
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(TransactionTypeVM.SectionItem.self)
            .subscribe(onNext: { [weak self] in
                self?.confirmAction($0)
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        
    }
    
}

private extension TransactionTypeController {
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
}
