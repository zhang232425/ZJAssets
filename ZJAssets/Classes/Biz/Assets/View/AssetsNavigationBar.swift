//
//  AssetsNavigationBar.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/8.
//

import UIKit

class AssetsNavigationBar: BaseView {
    
    enum Style {
        case light
        case dark
    }
    
    var style: Style = .dark {
        didSet {
            if style != oldValue {
                titleLabel.textColor = style.textColor
                reportButton.setImage(.named(style.reportIcon), for: .normal)
                recordButton.setImage(.named(style.recordIcon), for: .normal)
            }
        }
    }
    
    var title: String? { didSet { titleLabel.text = title } }
    
    var reportClick: (() -> ())?
    
    var recordClick: (() -> ())?
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "#333333")
        $0.font = UIFont.bold20
        $0.textColor = style.textColor
    }

    private(set) lazy var reportButton = UIButton(type: .custom).then {
        $0.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        $0.setImage(.named(style.reportIcon), for: .normal)
    }
    
    private lazy var recordButton = UIButton(type: .custom).then {
        $0.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        $0.setImage(.named(style.recordIcon), for: .normal)
    }
    
    private(set) lazy var processPointView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = UIColor(hexString: "#F13319")
    }
    
    override func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().inset(90)
        }
        
        reportButton.add(to: self).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.greaterThanOrEqualTo(titleLabel.snp.left).offset(1)
            $0.width.height.equalTo(28)
        }
        
        recordButton.add(to: self).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(reportButton.snp.right).offset(17)
            $0.right.equalToSuperview().inset(16)
        }
        
        processPointView.add(to: recordButton).snp.makeConstraints {
            $0.centerY.equalTo(recordButton.snp.top)
            $0.centerX.equalTo(recordButton.snp.right)
            $0.width.height.equalTo(8)
        }
        
    }

}

private extension AssetsNavigationBar {
    
    @objc func handleButtonClick(_ sender: UIButton) {
        
        switch sender {
        case reportButton:
            reportClick?()
        case recordButton:
            recordClick?()
        default:
            break
        }
        
    }
    
}

private extension AssetsNavigationBar.Style {
    
    var textColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(hexString: "#333333")
        }
    }
    
    var reportIcon: String {
        switch self {
        case .light:
            return "icon_report"
        case .dark:
            return "icon_report_dark"
        }
    }
    
    var recordIcon: String {
        switch self {
        case .light:
            return "icon_record"
        case .dark:
            return "icon_record_dark"
        }
    }
    
}
