//
//  TransactionFilterController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit
import RxSwift
import RxDataSources
import ZJModalTransition
import ZJCommonView

class TransactionFilterController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var transition = ZJModalTransition(animator: ZJActionSheetTransitionAnimator(frame: UIScreen.main.bounds,
                                                                                              backgroundColor: .init(white: 0,
                                                                                                                     alpha: 0.6)))
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .medium16
        $0.textColor = .init(hexString: "#333333")
        $0.textAlignment = .center
        $0.text = viewModel.title
    }
    
    private lazy var closeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_close"), for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 8
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.register(TransactionFilterTitleView.self,
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    withReuseIdentifier: "TransactionFilterTitleView")
        $0.registerCell(TransactionFilterItemCell.self)
    }
    
    private lazy var confirmButton = RoundCornerButton(type: .system).then {
        $0.backgroundColor = .init(hexString: "#FF7D0F")
        $0.setTitle(Locale.confirm.localized, for: .normal)
        $0.titleLabel?.font = .bold16
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<TransactionFilterVM.Section>!
    
    private let viewModel: TransactionFilterVM
    
    private let confirmAction: (TransactionFilterParam) -> ()
    
    init(category: FilterCategory, param: TransactionFilterParam, confirmAction: @escaping (TransactionFilterParam) -> ()) {
        viewModel = .init(category, param: param)
        self.confirmAction = confirmAction
        super.init(nibName: nil, bundle: nil)
        transition.prepare(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }

}

private extension TransactionFilterController {
    
    @objc
    func confirm() {
        confirmAction(viewModel.param)
        dismiss(animated: true)
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
}

extension TransactionFilterController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (collectionView.bounds.width - 16) / 3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.bounds.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleSelectItem(at: indexPath)
    }
    
}

private extension TransactionFilterController {
    
    func bindViewModel() {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource = .init(configureCell: { (ds, collectionView, indexPath, item) in
            
            let cell: TransactionFilterItemCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
            
            cell.item = item
            
            return cell
            
        }, configureSupplementaryView: { (ds, collectionView, kind, indexPath) in
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "TransactionFilterTitleView",
                                                                       for: indexPath)
            
            (view as? TransactionFilterTitleView)?.title = ds[indexPath.section].model
            
            return view
            
        })
        
        viewModel.datas.observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
                
    }
    
    func createUI() {
        
        let contentView = RoundCornerView(radius: 9)
        contentView.corners = [.topLeft, .topRight]
        
        contentView.add(to: view).snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
        }
        
        let topView = UIView()
        
        topView.add(to: contentView).snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        closeButton.add(to: topView).snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.right.equalTo(topView.safeAreaLayoutGuide).inset(5)
            } else {
                $0.right.equalToSuperview().inset(5)
            }
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        titleLabel.add(to: topView).snp.makeConstraints {
            $0.right.equalTo(closeButton.snp.left).offset(-5)
            if #available(iOS 11.0, *) {
                $0.left.equalTo(topView.safeAreaLayoutGuide).inset(50)
            } else {
                $0.left.equalToSuperview().inset(50)
            }
            $0.centerY.equalToSuperview()
        }
        
        collectionView.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            if #available(iOS 11.0, *) {
                $0.left.right.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            } else {
                $0.left.right.equalToSuperview().inset(16)
            }
            $0.height.equalTo(viewModel.contentHeight)
        }
        
        confirmButton.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalTo(collectionView)
            $0.top.greaterThanOrEqualTo(collectionView.snp.bottom).offset(52)
            $0.height.equalTo(45)
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            } else {
                $0.bottom.equalToSuperview().inset(20)
            }
        }
        
    }
    
}
