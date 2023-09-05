//
//  ZJModule.swift
//  FBSnapshotTestCase
//
//  Created by Jercan on 2022/9/16.
//

import UIKit

public protocol ZJModule {
    
    init()
    
    func initialize()
    
    func applicationDidBecomeActive(_ application: UIApplication)
    
    func applicationWillResignActive(_ application: UIApplication)
    
    func applicationDidEnterBackground(_ application: UIApplication)
    
    func applicationWillEnterForeground(_ application: UIApplication)
    
    func applicationWillTerminate(_ application: UIApplication)
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    
}

public extension ZJModule {
    
    func register() {
        ZJModuleManager.register(model: self)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return false
    }
    
}


public final class ZJModuleManager {
    
    private static var modules = [ZJModule]()
    
    private init() {}
    
}

extension ZJModuleManager {
    
    static func register(model: ZJModule) {
        model.initialize()
        modules.append(model)
    }
    
    static func applicationDidBecomeActive(_ application: UIApplication) {
        modules.forEach{ $0.applicationDidBecomeActive(application) }
    }
    
    static func applicationWillResignActive(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillResignActive(application) }
    }
    
    static func applicationDidEnterBackground(_ application: UIApplication) {
        modules.forEach{ $0.applicationDidEnterBackground(application) }
    }
    
    static func applicationWillEnterForeground(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillEnterForeground(application) }
    }
    
    static func applicationWillTerminate(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillEnterForeground(application) }
    }
    
    static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        for module in modules where module.application(app, open: url, options: options) == true {
            return true
        }
        
        return false
        
    }
    
    static func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        for module in modules where module.application(application, continue: userActivity, restorationHandler: restorationHandler) == true {
            return true
        }
        
        return false
        
    }
    
}
