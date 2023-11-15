//
//  BaseScrollViewController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/11/9.
//

import ZJBase
import ZJHUD
import RxSwift
import Action

class BaseScrollViewController: ZJScrollViewController {

    var disposeBag = DisposeBag()
    
    private var hud: ZJHUDView?
    
    private(set) lazy var contentView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor(hexString: "#FFFFFF")
        layoutContentView()
    }

    func doError(_ error: ActionError) {
        
        if case .underlyingError(let error) = error {
            ZJHUD.noticeOnlyText(error.localizedDescription)
        }
        
    }
    
    func doProgress(_ executing: Bool) {
        
        view.endEditing(true)
        
        if executing {
            hud?.hide()
            hud = ZJHUDView()
            hud?.showProgress(in: view)
        } else {
            hud?.hide()
        }
        
    }

    func addArrangedSubview(_ subView: UIView) {
        contentView.addArrangedSubview(subView)
    }
    
    func removeAllArrangedSubview() {
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func layoutContentView() {
        
        contentView.add(to: view).snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
    }
    
    deinit {
        hud?.hide()
    }
    

}
