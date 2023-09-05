//
//  ZJNetworkMonitor.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import Alamofire

public final class ZJNetworkMonitor {
    
    public enum State {
        case wwan
        case wifi
        case notReachable
        case unKnown
    }
    
    public static let shared = ZJNetworkMonitor()
    
    public static let networkStateDidChangeNotification = Notification.Name(rawValue: "notification.name.as.network.state.change")
    
    private var _networkState = State.unKnown
    
    private var _isReachable: Bool
    
    private let reachability = NetworkReachabilityManager()
    
    private var isListening = false
    
    private init() {
        _isReachable = reachability?.isReachable ?? false
    }
    
    private func networkState(with status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        
        switch status {
        case .reachable(.ethernetOrWiFi):
            _networkState = .wifi
            _isReachable = true
            
        case .reachable(.cellular):
            _networkState = .wwan
            _isReachable = true
            
        case .notReachable:
            _networkState = .notReachable
            _isReachable = false
            
        case .unknown:
            _networkState = .unKnown
            _isReachable = false
            
        }
        
    }
    
}

public extension ZJNetworkMonitor {
    
    var networkState: State {
        
        if let reachability = reachability {
            networkState(with: reachability.status)
        }
        
        return _networkState
        
    }
    
    var isReachable: Bool {
        
        if let reachability = reachability {
            networkState(with: reachability.status)
        }
        
        return _isReachable
        
    }
    
    func startListening() {
        
        guard !isListening else { return }
        
        isListening = reachability?.startListening { [weak self] in
            
            self?.networkState(with: $0)
            
            NotificationCenter.default.post(name: ZJNetworkMonitor.networkStateDidChangeNotification, object: self?._networkState)
            
        } ?? false
                
    }
    
    func stopListening() {
        reachability?.stopListening()
        isListening = false
    }
    
}
