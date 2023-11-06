//
//  ZJActionSheetTransitionAnimator.swift
//  ZJModalTransition
//
//  Created by Jercan on 2023/9/21.
//

import Foundation

public struct ZJActionSheetTransitionAnimator: ZJModalTransitionAnimator {
    
    public let frame: CGRect?
    
    public let tapToDismiss: Bool
    
    public let duration: TimeInterval
    
    public let backgroundColor: UIColor?
    
    public init(frame: CGRect, tapToDismiss: Bool = false, duration: TimeInterval = 0.25, backgroundColor: UIColor? = nil) {
        self.frame = frame
        self.tapToDismiss = tapToDismiss
        self.duration = duration
        self.backgroundColor = backgroundColor
    }
    
    public func performPresentedTransition(presentingView: UIView, presentedView: UIView, context: UIViewControllerContextTransitioning) {
        
        var initialFrame = frame!
        
        initialFrame.origin = .init(x: (context.containerView.frame.width - initialFrame.width) / 2, y: context.containerView.frame.height)
        
        let finalFrame = presentedView.frame
        
        presentedView.frame = initialFrame
        
        UIView.animate(withDuration: duration, animations: {
            
            presentedView.frame = finalFrame
            
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
        
        let initialFrame = presentedView.frame
        
        var finalFrame = frame!
        
        finalFrame.origin = .init(x: (context.containerView.frame.width - finalFrame.width) / 2, y: context.containerView.frame.height)
        
        presentedView.frame = initialFrame
        
        UIView.animate(withDuration: duration, animations: {
            
            presentedView.frame = finalFrame
            
            presentedView.alpha = 0
            
        }) {
            
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition($0)
            }
            
        }
        
    }
    
}

