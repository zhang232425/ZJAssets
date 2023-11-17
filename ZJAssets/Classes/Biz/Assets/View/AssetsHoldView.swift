//
//  AssetsHoldView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/16.
//

import UIKit
import RxSwift

class AssetsHoldView: UIStackView {
    
    private var bag = DisposeBag()
        
    var clickHandler: ((AssetsInfo.AssetsType) -> ())?
        
    var info: AssetsHoldInfo? {
        
        didSet {
            
            bag = DisposeBag()
            
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            if let count = info?.rowCount, count > 0, let assets = info?.assets {
                
                var n = 0
                                
                while n < assets.count {
                    
                    let view: UIView
                    
                    if n + 1 < assets.count {
                        view = createNormalView(leftItem: assets[n], rightItem: assets[n + 1], showLine: (n + 1) % 2 < count)
                    } else {
                        view = createSingleView(item: assets[n])
                    }
                    
                    addArrangedSubview(view)
                    
                    n = n + 2
                    
                }
                
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
        layer.cornerRadius = 4
        layer.borderColor = UIColor(hexString: "#F0F0F0").cgColor
        layer.borderWidth = 1
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension AssetsHoldView {
        
    func createNormalView(leftItem: AssetsInfo, rightItem: AssetsInfo, showLine: Bool) -> UIView {
        
        let view = UIView()
        
        let leftView = AssetsHoldContentView()
        
        leftView.add(to: view).then {
            $0.tag = leftItem.type.tag
            $0.titleLabel.text = leftItem.name
            $0.earningLabel.textColor = leftItem.earning.earningColor
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemClick(_:))))
        }.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(12)
        }
        
        let line = UIView()
        
        line.add(to: view).then {
            $0.backgroundColor = .init(hexString: "#F0F0F0")
        }.snp.makeConstraints {
            $0.left.equalTo(leftView.snp.right).offset(12)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
        }
        
        let rightView = AssetsHoldContentView()
        
        rightView.add(to: view).then {
            $0.tag = rightItem.type.tag
            $0.titleLabel.text = rightItem.name
            $0.earningLabel.textColor = rightItem.earning.earningColor
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemClick(_:))))
        }.snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(12)
            $0.top.bottom.right.equalToSuperview().inset(12)
        }
        
        if showLine {
            UIView().add(to: view).then {
                $0.backgroundColor = .init(hexString: "F0F0F0")
            }.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        let secureText = info?.secureText
        
        info?.isSecureText.subscribe(onNext: { isSecure in
            
            if isSecure {
                
                leftView.amountLabel.text = secureText
                leftView.earningLabel.text = secureText
                
                rightView.amountLabel.text = secureText
                rightView.earningLabel.text = secureText
                
            } else {
                
                leftView.amountLabel.text = leftItem.amount.amountValue
                leftView.earningLabel.text = leftItem.earning.assetsValue
                
                rightView.amountLabel.text = rightItem.amount.amountValue
                rightView.earningLabel.text = rightItem.earning.assetsValue
                
            }
            
        }).disposed(by: bag)
        
        return view
        
    }
    
    func createSingleView(item: AssetsInfo) -> UIView {
        
        let view = UIView()
        
        let singleView = AssetsHoldSingleView()
        
        singleView.add(to: view).then {
            $0.tag = item.type.tag
            $0.titleLabel.text = item.name
//            $0.earningLabel.textColor = item.earning.earningColor
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemClick(_:))))
        }.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(15)
        }
                
        let secureText = info?.secureText
        
        info?.isSecureText.subscribe(onNext: { isSecure in
            if isSecure {
                singleView.amountLabel.text = secureText
//                singleView.earningLabel.text = secureText
            } else {
                singleView.amountLabel.text = item.amount.amountValue
//                singleView.earningLabel.text = item.earning.assetsValue
            }
        }).disposed(by: bag)
        
        return view
        
    }
    
    @objc
    func handleItemClick(_ gesture: UIGestureRecognizer) {
        
        if let tag = gesture.view?.tag,
           let type = AssetsInfo.AssetsType.allCases.first(where: { $0.tag == tag }) {
            clickHandler?(type)
        }
        
    }
        
}

private class AssetsHoldSingleView: BaseView {
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#999999")
    }
    
    private(set) lazy var amountLabel = UILabel().then {
        $0.font = .medium14
        $0.textColor = .init(hexString: "#333333")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }

    override func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        amountLabel.add(to: self).snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(snp.centerX).offset(6)
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(amountLabel)
        }
    
    }
    
}

private class AssetsHoldContentView: BaseView {
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#999999")
    }
    
    private(set) lazy var amountLabel = UILabel().then {
        $0.font = .medium14
        $0.textColor = .init(hexString: "#333333")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    private(set) lazy var earningLabel = UILabel().then {
        $0.font = .medium12
        $0.textColor = .init(hexString: "#1CB395")
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    override func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        amountLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
        }
        
        earningLabel.add(to: self).snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(3)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

