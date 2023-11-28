//
//  TransactionFilterTitleView.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/28.
//

class TransactionFilterTitleView: UICollectionReusableView {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .regular14
        $0.textColor = .init(hexString: "#999999")
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TransactionFilterTitleView {
    
    func setupViews() {
        
        titleLabel.add(to: self).snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.auto)
            $0.left.right.equalToSuperview()
        }
        
    }
    
}
