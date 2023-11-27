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
            self?.viewModel.nextStep.accept(.monthReport)
        }
        $0.recordClick = {
            self?.viewModel.nextStep.accept(.transaction)
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
    
    private var bubbleView: AssetsBubbleView?
    
    private var progressView: AssetsProgressView?
    
    private var noSignalView: ZJNoSignalView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

private extension ZJAssetsViewController {
    
    func config() {
        
        view.backgroundColor = .white
        
    }
    
    func setupViews() {
        
        barContainerView.add(to: view).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        naviBar.add(to: barContainerView).snp.makeConstraints {
            $0.top.equalToSafeArea(of: barContainerView)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44.auto)
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
            $0.top.equalTo(barContainerView.snp.bottom)
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
        
        viewModel.isMonthReportHidden.bind(to: naviBar.reportButton.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.hasProcessOrder.not().bind(to: naviBar.processPointView.rx.isHidden).disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.errors,
                         viewModel.refreshAction.errors,
                         viewModel.investCheckAction.errors)
        .subscribeNext(weak: self, ZJAssetsViewController.doError)
        .disposed(by: disposeBag)
        
        viewModel.fetchAction.errors.map { _ in }.delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext(weak: self, ZJAssetsViewController.showNoSignalView)
            .disposed(by: disposeBag)
        
        viewModel.investCheckAction.executing
            .subscribeNext(weak: self, ZJAssetsViewController.doProgress)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.executing
            .subscribeNext(weak: self, ZJAssetsViewController.doFetchProgress)
            .disposed(by: disposeBag)
        
        Observable.merge(viewModel.fetchAction.elements,
                         viewModel.refreshAction.elements).unwrap()
            .subscribeNext(weak: self, ZJAssetsViewController.refreshUI)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UserDefaults.secureTextStateDidChange)
            .map { $0.object as? Bool }
            .unwrap().bind(to: viewModel.isSecureText)
            .disposed(by: disposeBag)
        
        scrollView.rx.addPullToRefresh.bind(to: viewModel.refreshAction.inputs).disposed(by: disposeBag)
    
        Observable.merge(viewModel.refreshAction.elements.map { _ in },
                         viewModel.refreshAction.errors.map { _ in })
        .bind(to: scrollView.rx.endPullToRefresh)
        .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset.map { $0.y }.subscribe(onNext: { [weak self] in
            self?.backgroundView.adjustPositionBy(offsetY: $0)
        }).disposed(by: disposeBag)
        
        viewModel.datas.subscribeNext(weak: self, ZJAssetsViewController.buildSections).disposed(by: disposeBag)
        
        viewModel.nextStep.unwrap()
            .subscribeNext(weak: self, ZJAssetsViewController.doNextStep)
            .disposed(by: disposeBag)
        
        viewModel.fetchAction.execute()
        
    }
    
    func addBubbleViewIfNeeded() {
        
        guard !UserDefaults.standard.isDisplayAssetsBubble else {
            return
        }
        
        UserDefaults.standard.isDisplayAssetsBubble = true
        
        AssetsBubbleView().add(to: view).then {
            bubbleView = $0
        }.snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview()
            $0.top.equalTo(barContainerView.snp.bottom)
            $0.right.equalToSuperview().inset(10.auto)
        }
        
    }

    func buildSections(_ items: [AssetsViewModel.SectionItem]) {
        
        removeAllArrangedSubview()
        
        items.forEach {
            
            switch $0 {
            case .assets(let info, let secureAction, let unpayAction):
                headerView.info = info
                headerView.secureClickAction = secureAction
                headerView.unpayClickAction = unpayAction
                addArrangedSubview(headerView)
            case .balance(let info, let clickAction):
                addArrangedSubview(createBalanceView(info: info, action: clickAction))
            case .hold(let info, let clickHandler):
                addArrangedSubview(createHoldView(info: info, clickHandler: clickHandler))
            case .chart:
                //addArrangedSubview(AssetsChartView().then { $0.infos = info })
                break
            case .insure(let info, let handler):
                addArrangedSubview(createInsureView(info: info, handler: handler))
            case .separator(let height):
                addArrangedSubview(createSeparatorView(height: height))
            }
            
        }
        
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
        
        bubbleView?.refreshText()
        
    }
    
    func showNoSignalView(_ :()) {
        
        let errorView = noSignalView ?? ZJNoSignalView()
        
        errorView.removeFromSuperview()
        
        errorView.add(to: view).then {
            $0.refreshAction = { [weak self] in
                self?.viewModel.fetchAction.execute()
            }
            noSignalView = $0
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func doFetchProgress(_ executing: Bool) {
        
        view.endEditing(true)
        
        noSignalView?.removeFromSuperview()
        
        if executing {
            
            progressView?.removeFromSuperview()
            
            let progress = AssetsProgressView()
            
            progress.add(to: view).then {
                $0.title = viewModel.navigationTitle
                progressView = $0
            }.snp.makeConstraints {
                $0.top.equalToSuperview()
                if #available(iOS 11.0, *) {
                    $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
                } else {
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalTo(bottomLayoutGuide.snp.top)
                }
            }
            
        } else {
            
            progressView?.removeFromSuperview()
            progressView = nil
            
        }
        
    }

    func doNextStep(_ step: AssetsViewModel.NavigationStep) {
        
        switch step {
        case .monthReport:
            break
        case .renewInvest(let balance):
            break
        case .insure(let url):
            break
        case .deposit:
            navigationToDeposit()
        case .flex:
            break
        case .fund:
            break
        case .gold:
            break
        case .transaction:
            viewModel.hasProcessOrder.accept(false)
            navigationToTransaction()
        }
        
    }
    
    
}

private extension ZJAssetsViewController {
    
    func createBalanceView(info: AssetsBalanceInfo, action: (() -> ())?) -> UIView {
        
        let view = UIView()
        
        AssetsBalanceView().add(to: view).then {
            $0.info = info
            $0.clickAction = action
        }.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.auto)
        }
        
        return view
        
    }
    
    func createHoldView(info: AssetsHoldInfo, clickHandler: ((AssetsInfo.AssetsType) -> ())?) -> UIView {
        
        let view = UIView()
        
        AssetsHoldView().add(to: view).then {
            $0.info = info
            $0.clickHandler = clickHandler
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview().inset(28.auto)
        }
        
        return view
        
    }

    func createInsureView(info: InsureInfo?, handler: (() -> ())?) -> UIView {
        
        let view = UIView()
        
        AssetsInsureView().add(to: view).then {
            $0.info = info
            $0.clickHandler = handler
        }.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSuperview().inset(30.auto)
        }
        
        return view
    }
    

    func createSeparatorView(height: CGFloat) -> UIView {
        
        let separatorView = UIView()
        separatorView.backgroundColor = .clear
        
        UIView().add(to: separatorView).then {
            $0.backgroundColor = .clear
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        return separatorView
        
    }
    
    
}

private extension ZJAssetsViewController {
    
    func navigationToDeposit() {
        
        let vc = DepositAssetsController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func navigationToTransaction() {
        
        bubbleView?.removeFromSuperview()
        bubbleView = nil

        let vc = TransactionRecordController(type: .all)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
