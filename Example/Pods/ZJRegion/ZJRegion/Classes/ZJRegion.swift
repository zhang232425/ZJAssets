//
//  ZJRegion.swift
//  Pods-ZJRegion_Example
//
//  Created by Jercan on 2022/10/17.
//

import Foundation

public struct ZJRegion {
    
    public enum Region: String {
        case Indonesia   = "ID"
        case Philippines = "PH"
    }
    
    private static var _currentRegion: Region?
    
    public static var current: Region {
        
        if let region = _currentRegion { return region }
        
        if let url = Bundle.main.url(forResource: "ASRegion", withExtension: "plist") {
            
            if let dict = NSDictionary(contentsOf: url),
                let code = dict["region"] as? String,
                let region = Region(rawValue: code) {
                _currentRegion = region
            } else {
                debugPrint("ASRegion😅make sure the region key is right😂String(ID/PH)😂and will use the default value")
            }
            
        } else {
            debugPrint("ASRegion😅make sure add ASRegion.plist to your project😂")
        }
        
        return _currentRegion ?? .Indonesia
        
    }
    
}

public extension ZJRegion.Region {
    
    var id: String {
        switch self {
        case .Indonesia: return "1"
        case .Philippines: return "3"
        }
    }

    var code: String {
        return rawValue
    }
    
    var currencyCode: String {
        switch self {
        case .Indonesia: return "Rp"
        case .Philippines: return "₱"
        }
    }
    
    var areaCode: String {
        switch self {
        case .Indonesia: return "+62"
        case .Philippines: return "+63"
        }
    }
    
    var servicePhone: String {
        switch self {
        case .Indonesia: return "14033"
        case .Philippines: return "(02) 7730 4085"
        }
    }
    
}
