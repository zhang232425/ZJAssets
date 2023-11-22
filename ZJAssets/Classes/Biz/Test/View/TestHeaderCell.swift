//
//  TestHeaderCell.swift
//  Action
//
//  Created by Jercan on 2023/11/21.
//

import UIKit
import ZJExtension
import RxSwift

class TestHeaderCell: UITableViewCell {
    
    private var bag = DisposeBag()
    
    var secureClickAction: (() -> ())?
    
    var info: TestHeaderInfo? {
        didSet {
            bag = DisposeBag()
            nameLabel.text = info?.name
            info?.isSecureText.subscribeNext(weak: self, TestHeaderCell.updateText).disposed(by: bag)
        }
    }

    // MARK: - Lazy load
    private lazy var nameLabel = UILabel().then {
        $0.font = .bold15
    }
    
    private lazy var ageLabel = UILabel().then {
        $0.font = .medium15
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.font = .medium15
    }
    
    private lazy var avatarView = UIImageView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    private lazy var eyeButton = UIButton(type: .custom).then {
        $0.setImage(.named("icon_eye"), for: .normal)
        $0.addTarget(self, action: #selector(eyeClick), for: .touchUpInside)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

private extension TestHeaderCell {
    
    func setupViews() {
        
        nameLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.top.equalToSuperview().inset(20.auto)
        }
        
        eyeButton.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.left.equalTo(nameLabel.snp.right).offset(5.auto)
            $0.width.height.equalTo(12.auto)
        }
        
        ageLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.auto)
        }
        
        addressLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(ageLabel)
            $0.top.equalTo(ageLabel.snp.bottom).offset(6.auto)
            $0.bottom.equalToSuperview().inset(20.auto)
        }
        
        avatarView.add(to: contentView).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15.auto)
            $0.size.equalTo(40)
        }
        
    }
    
}

private extension TestHeaderCell {

    func updateText(_ isSecure: Bool) {
        
        if isSecure {
            ageLabel.text = info?.secureText
            addressLabel.text = info?.secureText
        } else {
            guard let model = info else { return }
            ageLabel.text = "\(model.age)"
            addressLabel.text = model.address
        }
        
    }
    
    @objc func eyeClick() {
        secureClickAction?()
    }
    
}
