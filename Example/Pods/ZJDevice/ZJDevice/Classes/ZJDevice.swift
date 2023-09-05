//
//  File.swift
//  DeviceKit
//
//  Created by Jercan on 2022/10/17.
//

import KeychainSwift
import ZJKeychain
import DeviceKit
import UIKit

public struct ZJDevice {
    
    private var _deviceId: String?
    
    public init() {
        _deviceId = ZJKeychain.get("deviceId")
        if _deviceId == nil {
            let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
            ZJKeychain.set(deviceId, forKey: "deviceId")
            _deviceId = deviceId
        }
    }
    
}

public extension ZJDevice {
    
    var appName: String? { Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String }
    
    var appVersion: String? { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String }
    
    var build: String? { Bundle.main.infoDictionary?["CFBundleVersion"] as? String }
    
    var deviceId: String? { _deviceId }

    var deviceType: String { "2" }
    
    var systemVersion: String { Device.current.systemVersion ?? UIDevice.current.systemVersion }
    
    var deviceMode: String { Device.current.safeDescription }
    
    var isXseries: Bool { Device.current.hasSensorHousing }
    
    var screenRatio: (width: Double, height: Double) { Device.current.screenRatio }
    
}

