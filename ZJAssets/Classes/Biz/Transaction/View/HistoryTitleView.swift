//
//  HistoryTitleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

import UIKit

class HistoryTitleView: BaseView {
    
    enum UIState {
        case normal
        case highlight
    }
    
    private lazy var periodView = TransactionTitleSelectView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(periodClick)))
    }
    
    private lazy var filterLabel = UILabel().then {
        $0.font = .regular12
        $0.text = Locale.filter.localized
    }
        
    private lazy var filterImageView = UIImageView(image: .named("ico_filter")).then {
        $0.backgroundColor = .init(hexString: "#F3F3F3")
    }
    
    var state: UIState = .normal {
        didSet {
            filterLabel.textColor = state.textColor
            filterImageView.image = state.icon
        }
    }
    
    var periodTitle: String? {
        didSet {
            periodView.titleLabel.text = periodTitle
        }
    }
    
    var periodClickHandler: (() -> ())?
    
    var filterClickHandler: (() -> ())?

    override func setupViews() {
        
        backgroundColor = .init(hexString: "#F3F3F3")
        
        state = .normal
        
        periodView.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(16.auto)
            $0.top.equalToSuperview().inset(12.auto)
        }
        
        let rightView = UIView()
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterClick)))
        
        rightView.add(to: self).snp.makeConstraints {
            $0.right.equalToSuperview().inset(16.auto)
            $0.centerY.equalToSuperview()
        }
        
        filterImageView.add(to: rightView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.height.equalTo(16.auto)
        }
        
        filterLabel.add(to: rightView).snp.makeConstraints {
            $0.left.equalTo(filterImageView.snp.right).offset(2.auto)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        UIView().add(to: self).then {
            $0.backgroundColor = .init(hexString: "#EAEAEB")
        }.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }

}

private extension HistoryTitleView {
    
    @objc
    func filterClick() {
        filterClickHandler?()
    }
    
    @objc
    func periodClick() {
        periodClickHandler?()
    }
    
}

private extension HistoryTitleView.UIState {
    
    var textColor: UIColor {
        switch self {
        case .normal:
            return .init(hexString: "#666666")
        case .highlight:
            return .init(hexString: "#FF7D0F")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .normal:
            return .named("ico_filter")
        case .highlight:
            return .named("ico_filter_h")
        }
    }
    
}
