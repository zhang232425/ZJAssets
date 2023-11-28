//
//  InProgressTitleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class InProgressTitleView: BaseView {

    private var bag = DisposeBag()
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 8.auto
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .init(hexString: "#F3F3F3")
        $0.registerCell(InProgressItemCell.self)
    }
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, InProgressItem>> {
        (ds, collectionView, indexPath, item) in
        let cell: InProgressItemCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
        cell.item = item
        return cell
    }
    
    private let datas = BehaviorRelay(value: [SectionModel<String, InProgressItem>]())
    
    var titles: [String] = [] {
        didSet {
            var items = [InProgressItem]()
            for (idx, item) in titles.enumerated() {
                items.append(.init(title: item, selected: idx == 0))
            }
            datas.accept([.init(model: "", items: items)])
        }
    }
    
    var itemSelectHandler: ((Int) -> ())?
    
    override func setupViews() {
        
        backgroundColor = .init(hexString: "#F3F3F3")
        
        collectionView.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(16).priority(.high)
            $0.height.equalTo(22)
        }
        
        UIView().add(to: self).then {
            $0.backgroundColor = .init(hexString: "#EAEAEB")
        }.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bindDataSource()
        
    }
    
    func bindDataSource() {
        
        collectionView.rx.setDelegate(self).disposed(by: bag)
        
        datas.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
    }

}

extension InProgressTitleView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        let label = UILabel()
        label.text = item.title
        label.font = item.selected ? .medium12 : .regular12
        label.sizeToFit()
        return .init(width: max(60, ceil(label.frame.width) + 24), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let items = datas.value.first?.items {
            
            itemSelectHandler?(indexPath.item)
            
            var newItems = [InProgressItem]()
            
            for (idx, item) in items.enumerated() {
                newItems.append(.init(title: item.title, selected: idx == indexPath.item))
            }
            
            datas.accept([.init(model: "", items: newItems)])
            
        }
        
    }
    
}

fileprivate struct InProgressItem {
    let title: String
    let selected: Bool
}

fileprivate class InProgressItemCell: UICollectionViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .init(hexString: "#333333")
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
    }
    
    var item: InProgressItem? {
        didSet {
            titleLabel.text = item?.title
            if let selected = item?.selected, selected {
                titleLabel.textColor = .white
                titleLabel.font = .medium12
                containerView.backgroundColor = .init(hexString: "#FF7D0F")
            } else {
                titleLabel.textColor = .init(hexString: "#333333")
                titleLabel.font = .regular12
                containerView.backgroundColor = .white
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        backgroundColor = .clear
        
        containerView.add(to: contentView).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.add(to: containerView).snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().inset(12)
            $0.right.lessThanOrEqualToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
        
    }
}
