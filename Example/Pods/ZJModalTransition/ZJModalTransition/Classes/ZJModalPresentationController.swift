//
//  ZJModalPresentationController.swift
//  ZJModalTransition
//
//  Created by Jercan on 2023/9/21.
//

import Foundation
import SnapKit
import UIKit

class ZJModalPresentationController: UIPresentationController {
    
    private lazy var dimView = UIView()
    
    private let tapToDismiss: Bool
    
    private let dimColor: UIColor?
    
    private let animator: ZJModalTransitionAnimator
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, animator: ZJModalTransitionAnimator) {
        self.animator = animator
        self.dimColor = animator.backgroundColor
        self.tapToDismiss = animator.tapToDismiss
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame: CGRect
        if let f = animator.frame {
            frame = f
        } else {
            let size = presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            presentedViewController.view.translatesAutoresizingMaskIntoConstraints = true
            frame = .init(x: (UIScreen.main.bounds.width - size.width) * 0.5,
                          y: (UIScreen.main.bounds.height - size.height) * 0.5,
                          width: size.width, height: size.height)
        }
        
        if let containerView = containerView {
            limit(frame: &frame, withSize: containerView.bounds.size)
        }
        
        return frame
        
    }
    
}

private extension ZJModalPresentationController {
    
    func setupDimBackgroundView() {
        
        guard let containerView = containerView else { return }
        
        if let color = dimColor {
            dimView.backgroundColor = color
        }
        
        dimView.alpha = 0
        
        if animator.tapToDismiss {
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss)))
        }
        
        containerView.insertSubview(dimView, at: 0)
        
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
    
    @objc func handleTapToDismiss() {
        presentingViewController.dismiss(animated: true)
    }
    
    func animateDimmingView() {
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimView.alpha = 1
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimView.alpha = 1
        })
        
    }
    
    func limit(frame: inout CGRect, withSize size: CGSize) {
        
        if frame.size.height > size.height {
            frame.origin.y = 0
            frame.size.height = size.height
        }
        
        if frame.size.width > size.width {
            frame.origin.x = 0
            frame.size.width = size.width
        }
        
    }
    
}
