//
//  TestViewController.swift
//  Action
//
//  Created by Jercan on 2023/11/21.
//

import UIKit
import ZJExtension
import RxDataSources
import RxSwift

class TestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = TestViewModel()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, TestViewModel.SectionItem>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(TestCell.self)
        $0.registerCell(TestHeaderCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindViewModel()
    }

}

private extension TestViewController {
    
    func config() {
        
        navigationItem.title = "Test"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .named("icon_record_dark"), style: .plain, target: self, action: #selector(backClick))
        
    }
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        NotificationCenter.default.rx.notification(UserDefaults.testSecureTextStateDidChange)
            .map { $0.object as? Bool }
            .unwrap().bind(to: viewModel.isSecureText)
            .disposed(by: disposeBag)
        
        dataSource = .init(configureCell: { (dataSource, tableView, indexPath, item) in
            
            switch item {
            case .header(let info, let clickAction):
                let cell: TestHeaderCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.info = info
                cell.secureClickAction = clickAction
                return cell
            case .item(let info):
                let cell: TestCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.info = info
                return cell
            }
            
        })
    
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}

private extension TestViewController {
    
    @objc func backClick() {
        self.dismiss(animated: true)
    }
    
}
