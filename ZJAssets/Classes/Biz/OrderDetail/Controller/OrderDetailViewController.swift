//
//  ZJOrderDetailViewController.swift
//  Action
//
//  Created by Jercan on 2023/9/5.
//

import UIKit
import RxSwift

class OrderDetailViewController: BaseScrollViewController {
    
    private let viewModel: OrderDetailVM
    
    init(productId: String? = nil, orderId: String) {
        self.viewModel = .init(productId: productId, orderId: orderId)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
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

private extension OrderDetailViewController {
    
    func setupViews() {
        
        scrollView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func bindViewModel() {
        
        Observable.merge(viewModel.fetchAction.executing,
                         viewModel.transcationRecordAction.executing)
        .subscribeNext(weak: self, OrderDetailViewController.doProgress)
        .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.transcationRecordAction.errors)
        .subscribeNext(weak: self, OrderDetailViewController.doError)
        .disposed(by: disposeBag)
        
        viewModel.datas.subscribeNext(weak: self, OrderDetailViewController.updateUI).disposed(by: disposeBag)
        
        viewModel.transcationRecordAction.elements.subscribeNext(weak: self, OrderDetailViewController.presentTranscationRecords).disposed(by: disposeBag)
        
        viewModel.fetchAction.execute()
        
    }
    
}

private extension OrderDetailViewController {
    
    func updateUI(_ items: [OrderDetailVM.SectionItem]) {
        
        navigationItem.title = viewModel.title
        
        scrollView.backgroundColor = .init(hexString: "F0F0F2")
        view.backgroundColor = .init(hexString: "F0F0F2")
        
        removeAllArrangedSubview()
        
        scrollView.snp.remakeConstraints {
            $0.top.equalToSafeArea(of: view)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        createItemViews(items: items).forEach(addArrangedSubview)
        
    }
    
    func createItemViews(items: [OrderDetailVM.SectionItem]) -> [UIView] {
        
        var itemViews: [UIView] = []
        
        items.forEach {
            
            switch $0 {
                
            case .noSignal:
                
                view.backgroundColor = .white
                scrollView.backgroundColor = .white
                let item = UIView()
                let contentView = ZJNoSignalView()
                contentView.refreshAction = { [weak self] in self?.viewModel.fetchAction.execute() }
                contentView.add(to: item).snp.makeConstraints {
                    $0.edges.equalToSuperview()
                    $0.size.equalTo(view.bounds.size)
                }
                itemViews.append(item)
                
            case .transaction(let info):
                
                let transactionView = OrderDetailTransactionView(model: info, recordsAction: { [weak self] in
                    self?.presentTranscationRecords(info: self?.viewModel.getTranscationRecords())
                })
                itemViews.append(transactionView)
                
            default:
                break
                
            }
        }
        
        return itemViews
        
    }
    
}

private extension OrderDetailViewController {

    func presentTranscationRecords(info: TranscationRecordAlertResult?) {
    
        guard let info = info else { return }
        
        print("info === \(info)")
        
    }
    
}
