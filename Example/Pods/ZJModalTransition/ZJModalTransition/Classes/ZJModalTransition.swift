//
//  ZJModalTransition.swift
//  ZJModalTransition
//
//  Created by Jercan on 2023/9/21.
//

import Foundation

public final class ZJModalTransition: NSObject {
    
    enum ZJTransitionState {
        case presented
        case dismissed
    }
    
    private var transitionState = ZJTransitionState.presented
    
    private let animator: ZJModalTransitionAnimator
    
    public init(animator: ZJModalTransitionAnimator) {
        self.animator = animator
        super.init()
    }
    
    public func prepare(viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
    }
    
}

extension ZJModalTransition: UIViewControllerTransitioningDelegate {
    
    public final func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionState = .presented
        return self
    }
    
    public final func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionState = .dismissed
        return self
    }
    
    public final func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ZJModalPresentationController(presentedViewController: presented, presentingViewController: presenting, animator: animator)
    }
    
}


extension ZJModalTransition: UIViewControllerAnimatedTransitioning {
    
    public final func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animator.duration
    }
    
    public final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toController = transitionContext.toController, let fromController = transitionContext.fromController else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        transitionContext.toView?.frame = transitionContext.finalFrame(for: toController)
        
        switch transitionState {
        case .presented:
            animator.performPresentedTransition(presentingView: fromController.view, presentedView: transitionContext.toView!, context: transitionContext)
        case .dismissed:
            animator.performDismissedTransition(presentingView: fromController.view, presentedView: transitionContext.fromView!, context: transitionContext)
        }
        
    }
    
}

private extension UIViewControllerContextTransitioning {
    
    var fromController: UIViewController? { viewController(forKey: .from) }
    
    var toController: UIViewController? { viewController(forKey: .to) }
    
    var fromView: UIView? { view(forKey: .from) }
    
    var toView: UIView? { view(forKey: .to) }
    
}
