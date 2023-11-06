//
//  Location.swift
//  ZJBase-ZJBase
//
//  Created by Jercan on 2023/9/19.
//

import CoreLocation
import ZJHUD

class Location: NSObject {
    
    private let locationManager = CLLocationManager()
    
    private var requestAuthorizationHandler: ((Location, Bool) -> ())?
    
    private var updateingLocationHandler: ((Double?, Double?) -> ())?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestWhenInUseAuthorization(handler: @escaping (Location, Bool) -> ()) {
        
        requestAuthorizationHandler = handler
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            handler(self, false)
        default:
            handler(self, true)
        }
        
    }
    
    func startUpdatingLocation(handler: @escaping (_ latitude: Double?, _ longitude: Double?) -> ()) {
        
        updateingLocationHandler = handler
        locationManager.stopUpdatingLocation()
    }
    
}

extension Location: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let coordinate = locations.last?.coordinate
        updateingLocationHandler?(coordinate?.latitude, coordinate?.longitude)
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            requestAuthorizationHandler?(self, false)
        default:
            requestAuthorizationHandler?(self, true)
        }
        
    }
    
}
