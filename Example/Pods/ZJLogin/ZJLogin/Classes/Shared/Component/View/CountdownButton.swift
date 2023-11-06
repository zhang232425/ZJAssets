//
//  TimerButton.swift
//  ZJLogin
//
//  Created by Jercan on 2023/9/14.
//

import UIKit

class CountdownButton: UIButton {
    
    enum CountState {
        case idle
        case counting(restCount: Int)
        case stopped
    }
    
    var onClick: (() -> ())?
    
    private(set) var countState = CountState.idle { didSet { update() } }
    
    private var timer: ZJCountDownTimer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CountdownButton {
    
    func config() {
        
        countState = .idle
        
        timer = ZJCountDownTimer(totalCount: 120, handler: { [weak self] in
            switch $0 {
            case 0:
                self?.countState = .stopped
            default:
                self?.countState = .counting(restCount: $0)
            }
        })
    
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    
    }
    
    func update() {
        
        let state = countState
        setTitle(state.title, for: .normal)
        setTitleColor(state.titleColor, for: .normal)
        setTitleColor(state.highlightTitleColor, for: .highlighted)
        
        backgroundColor = state.backgroundColor
        layer.borderColor = state.border.0
        layer.borderWidth = state.border.1
        
    }
    
    @objc func handleTap() {
        switch countState {
        case .idle, .stopped:
            onClick?()
        case .counting:
            break
        }
    }

}

extension CountdownButton {
    
    func startCountdown() {
        timer?.start()
    }
    
}

private extension CountdownButton.CountState {
    
    var title: String {
        switch self {
        case .idle:
            return Locale.send.localized
        case .counting(let count):
            return "\(count)s"
        case .stopped:
            return Locale.resend.localized
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .idle, .stopped:
            return UIColor.orange
        case .counting:
            return UIColor(hexString: "#999999")
        }
    }
    
    var highlightTitleColor: UIColor {
        switch self {
        case .idle, .stopped:
            return UIColor.orange.withAlphaComponent(0.5)
        case .counting:
            return UIColor(hexString: "#999999")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .idle, .stopped:
            return .clear
        case .counting:
            return UIColor(hexString: "#E9E9E9")
        }
    }
    
    var border: (CGColor?, CGFloat) {
        switch self {
        case .idle, .stopped:
            return (UIColor.orange.cgColor, 1)
        case .counting:
            return (nil, 0)
        }
    }
    
    
}
