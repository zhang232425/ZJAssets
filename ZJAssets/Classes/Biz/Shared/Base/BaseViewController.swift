//
//  BaseViewController.swift
//  ZJAssets
//
//  Created by Jercan on 2023/9/5.
//

import ZJBase
import RxSwift
import Then
import ZJHUD
import Action

class BaseViewController: ZJViewController {
    
    let disposeBag = DisposeBag()
    
    private var hud: ZJHUDView?
    
    var hudSuperView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func doProgress(_ executing: Bool) {
        view.endEditing(true)
        if executing {
            hud?.hide()
            hud = ZJHUDView()
            hudSuperView == nil ? hud?.showProgress(in: view) : hud?.showProgress(in: hudSuperView)
        } else {
            hud?.hide()
        }
    }
    
    func doError(_ error: ActionError) {
        if case .underlyingError(let err) = error {
            ZJHUD.noticeOnlyText(err.localizedDescription)
        }
    }
    
    deinit {
        hud?.hide()
        ZJHUD.hideProgress()
    }
    
}

