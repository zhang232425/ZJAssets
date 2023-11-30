//
//  HistoryDetailRecordView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/29.
//

import UIKit
import ZJCommonView

class HistoryDetailRecordView: UIView {
    
    private var records: [HistoryDetailRecordContentModel] = []
    
    convenience init(records: [HistoryDetailFlow]) {
        self.init()
        
        self.records = records.map{ HistoryDetailRecordContentModel(model: $0)}
        
        setUI()
        
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
       
        let bgView = UIView(backgroundColor: .white)
        bgView.layer.cornerRadius = 8.0
        bgView.clipsToBounds = true
        bgView.add(to: self).snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        
        let stackView = UIStackView(arrangedSubviews: records.enumerated().map{
            HistoryDetailRecordContentView(record: $0.element, isFirst: $0.offset == 0, isLast: $0.offset == records.count - 1)}
        )
        stackView.axis = .vertical
        stackView.add(to: bgView).snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        }
        
    }
    
}

fileprivate class HistoryDetailRecordContentView: UIView {
    
    convenience init(record: HistoryDetailRecordContentModel, isFirst: Bool, isLast: Bool) {
        self.init()
        
        setUI(record: record, isFirst: isFirst, isLast: isLast)
        
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(record: HistoryDetailRecordContentModel, isFirst: Bool, isLast: Bool) {
        
        let leftView = createLeftView(isFirst: isFirst, isLast: isLast)
        leftView.add(to: self).snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview()
        }
        
        let rightView = createRightView(record: record)
        rightView.add(to: self).snp.makeConstraints {
            $0.left.equalTo(leftView.snp.right).offset(16)
            $0.top.equalToSuperview()
            $0.right.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    private func createLeftView(isFirst: Bool, isLast: Bool) -> UIView {
        
        let bgView = UIView()
        
        if !isFirst {
            
            let lineView = UIView(backgroundColor: .init(hexString: "FF7D0F"))
            lineView.add(to: bgView).snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
                $0.width.height.equalTo(2)
            }
            
        }
        
        let circularView = RoundCornerView(radius: 5)
        circularView.backgroundColor = .init(hexString: "FF7D0F")
        circularView.add(to: bgView).snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.left.right.equalToSuperview()
            $0.width.height.equalTo(10)
        }
        
        if !isLast {
            
            let lineView = UIView(backgroundColor: .init(hexString: "FF7D0F"))
            lineView.add(to: bgView).snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(circularView.snp.bottom).offset(1)
                $0.bottom.equalToSuperview()
                $0.width.equalTo(2)
            }
        }
        
        return bgView
        
    }
    
    private func createRightView(record: HistoryDetailRecordContentModel) -> UIView {
        
        let bgView = UIStackView()
        bgView.axis = .vertical
        bgView.spacing = 4
        
        // 标题
        if let title = record.title {
            let titleLabel = UILabel().then {
                $0.textColor = UIColor(hexString: "666666")
                $0.font = UIFont.regular14
                $0.numberOfLines = 0
            }
            titleLabel.text = title
            bgView.addArrangedSubview(titleLabel)
        }
        
        // 描述
        if let content = record.content {
            
            let contentLabel =  UILabel().then {
                $0.textColor = UIColor(hexString: "999999")
                $0.font = UIFont.regular14
                $0.numberOfLines = 0
            }
            contentLabel.text = content
            bgView.addArrangedSubview(contentLabel)
        }
        
        return bgView
    }
    
}

struct HistoryDetailRecordContentModel {
    
    let title: String?
    
    let content: String?
    
    init(model: HistoryDetailFlow) {
        
        title = NSNumber(value: model.flowTime).dmDate() + " " + model.title
        
        content = model.subTitle

    }
    
}
