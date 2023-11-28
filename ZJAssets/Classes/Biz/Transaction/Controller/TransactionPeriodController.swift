//
//  TransactionPeriodController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/27.
//

import UIKit
import ZJModalTransition
import ZJCommonView
import JXSegmentedView
import ZJHUD

class TransactionPeriodController: UIViewController {
    
    enum PeriodType {
        case month(start: Date?, end: Date?)
        case period(start: Date?, end: Date?)
    }
    
    private var viewModel: TransactionPeriodVM
    
    private let confirmAction: (PeriodType) -> ()
    
    // MARK: - Lazy load
    private lazy var transition = ZJModalTransition(animator: ZJActionSheetTransitionAnimator(frame: UIScreen.main.bounds, backgroundColor: .init(white: 0, alpha: 0.6)))
    
    private lazy var contentView = RoundCornerView(radius: 10).then {
        $0.corners = [.topLeft, .topRight]
    }
    
    private lazy var segmentView = ZJSegmentedView().then {
        $0.delegate = self
        $0.titles = [Locale.select_month.localized, Locale.set_time_Periods.localized]
    }
    
    private lazy var closeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_close"), for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var confirmButton = RoundCornerButton(type: .system).then {
        $0.backgroundColor = .init(hexString: "#FF7D0F")
        $0.setTitle(Locale.confirm.localized, for: .normal)
        $0.titleLabel?.font = .bold16
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    private lazy var monthView = MonthPickerView().then {
        $0.selectHandler = { [weak self] in
            self?.viewModel.selectMonth = .init(year: $0.year, month: $0.month, day: 1)
        }
    }
    
    private lazy var periodsView = TimePeriodsView().then {
        
        let view = $0
        
        $0.pickerSelectHandler = { [weak self] (type, info) in
            
            guard let self = self else { return }
            
            switch type {
            case .customStart:
                
                self.viewModel.startPeriods = info
                view.setPeriods(start: self.viewModel.startPeriodsFormat,
                                end: self.viewModel.endPeriodsFormat)
                
            case .customEnd:
                
                self.viewModel.endPeriods = info
                view.setPeriods(start: self.viewModel.startPeriodsFormat,
                                end: self.viewModel.endPeriodsFormat)
                
            case .lastMonth, .last3Month, .lastYear:
                break
                
            }
            
        }
        
        $0.typeChangeHandler = { [weak self] in
            
            guard let self = self else { return }
            
            switch $0 {
            case .customStart:
                                
                view.setPickerInfo(minDate: self.viewModel.minPeriods,
                                   maxDate: self.viewModel.endPeriods,
                                   selectDate: self.viewModel.startPeriods)
                
            case .customEnd:
                
                view.setPickerInfo(minDate: self.viewModel.startPeriods,
                                   maxDate: self.viewModel.maxPeriods,
                                   selectDate: self.viewModel.endPeriods)
                
            case .lastMonth:
                
                let end = Date()
                let start = end.lastMonth
                self.viewModel.startPeriods = .init(year: start.year, month: start.month, day: start.day)
                self.viewModel.endPeriods = .init(year: end.year, month: end.month, day: end.day)
                
            case .last3Month:
                
                let end = Date()
                let start = end.last3Month
                self.viewModel.startPeriods = .init(year: start.year, month: start.month, day: start.day)
                self.viewModel.endPeriods = .init(year: end.year, month: end.month, day: end.day)
                
            case .lastYear:
                
                let end = Date()
                let start = end.lastYear
                self.viewModel.startPeriods = .init(year: start.year, month: start.month, day: start.day)
                self.viewModel.endPeriods = .init(year: end.year, month: end.month, day: end.day)
                
            }
            
        }
        
    }
    
    // MARK: - Init method
    init(viewModel: TransactionPeriodVM, confirmAction: @escaping (PeriodType) -> ()) {
        self.viewModel = viewModel
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

private extension TransactionPeriodController {
    
    func setupViews() {
        
        contentView.add(to: view).snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
        }
    
        segmentView.add(to: contentView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(25.auto)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40.auto)
        }
        
        closeButton.add(to: contentView).snp.makeConstraints {
            $0.right.equalToSuperview().inset(5.auto)
            $0.top.equalToSuperview().inset(5.auto)
            $0.width.height.equalTo(40.auto)
        }
        
        stackView.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom)
            $0.left.right.equalTo(segmentView)
        }
        
        confirmButton.add(to: contentView).snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16.auto)
            $0.height.equalTo(45.auto)
            $0.left.right.equalToSuperview().inset(16.auto)
            $0.bottom.equalToSafeArea(of: view).inset(20.auto)
        }
        
        stackView.addArrangedSubview(monthView)
        
    }
    
    func bindViewModel() {
        
        monthView.setInfo(year: viewModel.selectMonth.year, month: viewModel.selectMonth.month)
        
        periodsView.currentType = viewModel.selectedPeriodsType
        
        periodsView.setPeriods(start: viewModel.startPeriodsFormat,
                               end: viewModel.endPeriodsFormat)
        
        periodsView.setPickerInfo(minDate: viewModel.minPeriods,
                                  maxDate: viewModel.endPeriods,
                                  selectDate: viewModel.startPeriods)
        
        segmentView.defaultSelectedIndex = viewModel.selectedTypeIndex
        
        switchViewWith(index: segmentView.defaultSelectedIndex)
        
    }
    
}

private extension TransactionPeriodController {
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @objc func confirm() {
        
        switch segmentView.selectedIndex {
        case 0:
            confirmAction(.month(start: viewModel.startMonthTime, end: viewModel.endMonthTime))
        case 1:
            if !viewModel.isPeriodValid() {
                ZJHUD.show(message: Locale.more_than_one_year.localized, in: contentView)
                ZJHUD.hideMessage(afterDelay: 2)
                return
            }
            confirmAction(.period(start: viewModel.startTime, end: viewModel.endTime))
        default:
            break
        }
        
        viewModel.selectedTypeIndex = segmentView.selectedIndex
        
        viewModel.selectedPeriodsType = periodsView.currentType
        
        dismiss(animated: true)
        
    }
    
    func switchViewWith(index: Int) {
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch index {
        case 0:
            stackView.addArrangedSubview(monthView)
        case 1:
            stackView.addArrangedSubview(periodsView)
        default:
            break
        }
        
    }
    
}

extension TransactionPeriodController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        switchViewWith(index: index)
        
    }
    
}
