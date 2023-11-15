//
//  ZJAssetsViewController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/9/5.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class ZJAssetsViewController: BaseScrollViewController {
    
    // MARK: - Property
    private let viewModel = AssetsViewModel()
    
    // MARK: - Lazy load
    private lazy var barContainerView = UIImageView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var naviBar = AssetsNavigationBar().then { [weak self] in
        $0.backgroundColor = .clear
        $0.reportClick = {
            debugPrint("reportClick ---- ")
        }
        $0.recordClick = {
            debugPrint("recordClick ---- ")
        }
    }

    private var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            if statusBarStyle != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    private lazy var backgroundView = AssetsBackgroundHeaderView()
    
    private lazy var headerView = AssetsHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindViewModel()
    }
    

}

private extension ZJAssetsViewController {
    
    func config() {
        
        view.backgroundColor = .white
        
    }
    
    func setupViews() {
        
        barContainerView.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
        }
        
        naviBar.add(to: barContainerView).snp.makeConstraints {
            $0.top.equalToSafeArea(of: barContainerView)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        contentView.backgroundColor = .clear
        
        backgroundView.add(to: scrollView).then {
            scrollView.sendSubview(toBack: $0)
        }.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(backgroundView.snp.width).multipliedBy(0.34)
        }
        
        scrollView.then {
            $0.backgroundColor = .clear
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }.snp.remakeConstraints {
            if #available(iOS 11.0, *) {
                $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        addBubbleViewIfNeeded()
        
    }
    
    func bindViewModel() {
        
        viewModel.fetchAction.elements.unwrap()
            .subscribeNext(weak: self, ZJAssetsViewController.refreshUI)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.execute()
        
    }
    
    func addBubbleViewIfNeeded() {
        
        
        
    }
    
}

private extension ZJAssetsViewController {
    
    func refreshUI(_ level: VipLevel) {
        
        barContainerView.image = .named(level.imageName)
        
        switch level {
        case .sixth:
            backgroundView.image = .named("vip_6_bottom")
        default:
            backgroundView.colors = [.init(hexString: level.colorHex), .white]
        }
        
        statusBarStyle = level.statusBarStyle
        naviBar.style = level.navigationBarStyle
        naviBar.title = viewModel.navigationTitle
        
//        bubbleView?.refreshText()
        
    }
    
}
