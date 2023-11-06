//
//  ViewController.swift
//  ZJAssets
//
//  Created by zhang232425 on 09/05/2023.
//  Copyright (c) 2023 zhang232425. All rights reserved.
//

import UIKit
import ZJRoutableTargets

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func assetClick() {
        
        if let vc = ZJAssetsRoutableTarget.assets.viewController {
            present(vc, animated: true)
        }
        
    }
    
    @IBAction func loginClick() {
        
        if let vc = ZJLoginRoutableTarget.login.viewController {
            present(vc, animated: true)
        }
        
    }
    
}

