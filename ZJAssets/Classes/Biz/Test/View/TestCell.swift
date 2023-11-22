//
//  TestCell.swift
//  Action
//
//  Created by Jercan on 2023/11/21.
//

import UIKit
import ZJExtension
import RxSwift

class TestCell: UITableViewCell {
    
    private var bag = DisposeBag()
    
    var info: TestItemInfo? {
        didSet {
            bag = DisposeBag()
            nameLabel.text = info?.model.name
            info?.isSecureText.subscribeNext(weak: self, TestCell.updateText).disposed(by: bag)
        }
    }
    
    // MARK: - Lazy load
    private lazy var nameLabel = UILabel().then {
        $0.font = .bold15
    }
    
    private lazy var ageLabel = UILabel().then {
        $0.font = .medium15
    }
    
    private lazy var deepLabel = UILabel().then {
        $0.font = .medium15
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TestCell {
    
    func setupViews() {
        
        nameLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.top.equalToSuperview().inset(20.auto)
        }
        
        ageLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.auto)
        }
        
        deepLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(ageLabel)
            $0.top.equalTo(ageLabel.snp.bottom).offset(6.auto)
            $0.bottom.equalToSuperview().inset(20.auto)
        }
        
    }
    
}

private extension TestCell {
    
    func updateText(_ isSecure: Bool) {
        
        if isSecure {
            ageLabel.text = info?.secureText
            deepLabel.text = info?.secureText
        } else {
            guard let model = info?.model else { return }
            ageLabel.text = "\(model.age)"
            deepLabel.text = "\(model.deep)"
        }
        
    }
    
}
