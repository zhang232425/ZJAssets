//
//  WithdrawDetailController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit
import RxSwiftExt

class HistoryDetailViewController: BaseViewController {
    
    private let viewModel: HistoryDetailVM
    
    private var scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    init(id: String) {
        self.viewModel = HistoryDetailVM(recordId: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
    }


}

private extension HistoryDetailViewController {
    
    func bindViewModel() {
        
        navigationItem.title = viewModel.title
        
        viewModel.reloadAction.executing.subscribeNext(weak: self, HistoryDetailViewController.doProgress).disposed(by: disposeBag)
        
        viewModel.reloadAction.errors.subscribeNext(weak: self, HistoryDetailViewController.doError).disposed(by: disposeBag)
        
        viewModel.datas.subscribeNext(weak: self, HistoryDetailViewController.setupViews).disposed(by: disposeBag)
        
        viewModel.reloadAction.execute()
    }

}

private extension HistoryDetailViewController {
    
    func setupViews(_ items: [HistoryDetailVM.SectionItem]) {
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        view.subviews.forEach { $0.removeFromSuperview() }
        
        scrollView.backgroundColor = UIColor(hexString: "F0F0F2")
        
        view.backgroundColor = UIColor(hexString: "F0F0F2")
        
        if let bottomString = viewModel.bottomString {
            
            /// 底部按钮
            let buttomView = BottomButtonView(title: bottomString, clickAction: { [weak self] in self?.clickBottom() })
            buttomView.add(to: view).snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
            }
            
            scrollView.add(to: view).snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(buttomView.snp.top)
            }
            
        } else {
            
            scrollView.add(to: view).snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        }
        
        let infoView = UIStackView(arrangedSubviews: createItemViews(items: items)).then {
            $0.axis = .vertical
        }
        
        infoView.add(to: scrollView).snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
    
    }
    
    func createItemViews(items: [HistoryDetailVM.SectionItem]) -> [UIView] {
        
        var itemViews: [UIView] = []
        
        items.forEach {
            
            switch $0 {
                
            case .noSignal:
                view.backgroundColor = .white
                scrollView.backgroundColor = .white
                
                let item = UIView()
                
                let contentView = ZJNoSignalView()
                contentView.refreshAction = { [weak self] in self?.viewModel.reloadAction.execute() }
                contentView.add(to: item).snp.makeConstraints {
                    $0.edges.equalToSuperview()
                    $0.size.equalTo(view.bounds.size)
                }
                
                itemViews.append(item)
                
            case .header(let info):
                itemViews.append(HistoryDetailHeaderView(info: info))
                
            case .record(let info):
                itemViews.append(HistoryDetailRecordView(records: info))
                
            }
        }
       
        return itemViews
        
    }
    
}

private extension HistoryDetailViewController {
    
    func clickBottom() {
        
        
        
    }
    
}
