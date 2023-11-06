//
//  ZJAlertTransitionAnimator.swift
//  ZJModalTransition
//
//  Created by Jercan on 2023/9/21.
//

import Foundation

public struct ZJAlertTransitionAnimator: ZJModalTransitionAnimator {
    
    public let frame: CGRect?
    
    public let tapToDismiss: Bool
    
    public let duration: TimeInterval
    
    public let backgroundColor: UIColor?
    
    public init(frame: CGRect? = nil, tapToDismiss: Bool = false, duration: TimeInterval = 0.25, backgroundColor: UIColor? = nil) {
        self.frame = frame
        self.tapToDismiss = tapToDismiss
        self.duration = duration
        self.backgroundColor = backgroundColor
    }
    
    public func performPresentedTransition(presentingView: UIView, presentedView: UIView, context: UIViewControllerContextTransitioning) {
        
        presentedView.transform = presentedView.transform.concatenating(.init(scaleX: 0.5, y: 0.5))
        
        presentedView.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            presentedView.transform = .identity
            
            presentedView.alpha = 1
            
        }) {
            
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition($0)
            }
            
        }
        
    }
    
    public func performDismissedTransition(presentingView: UIView, presentedView: UIView, context: UIViewControllerContextTransitioning) {
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            presentedView.transform = presentedView.transform.concatenating(.init(scaleX: 0.5, y: 0.5))
            
            presentedView.alpha = 0
            
            presentingView.transform = .identity
            
        }) {
            
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition($0)
            }
            
        }
        
    }
    
}
