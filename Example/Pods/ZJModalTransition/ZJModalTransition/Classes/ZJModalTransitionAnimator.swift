//
//  ZJModalTransitionAnimator.swift
//  ZJModalTransition
//
//  Created by Jercan on 2023/9/21.
//

import Foundation

public protocol ZJModalTransitionAnimator {
    
    var frame: CGRect? { get }
    
    var duration: TimeInterval { get }
    
    var tapToDismiss: Bool { get }
    
    var backgroundColor: UIColor? { get }
    
    func performPresentedTransition(presentingView: UIView, presentedView: UIView, context: UIViewControllerContextTransitioning)
    
    func performDismissedTransition(presentingView: UIView, presentedView: UIView, context: UIViewControllerContextTransitioning)
    
}

public extension ZJModalTransitionAnimator {
    
    var duration: TimeInterval { 0.25 }
    
    var tapToDismiss: Bool { false }
    
    var backgroundColor: UIColor? { nil }
    
}
