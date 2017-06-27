//
//  AppDelegate.swift
//  YLLoginManager
//
//  Created by vsccw on 2017/6/27.
//  Copyright © 2017年 YOLO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        YLAuthManager.manager.register(weixinID: "wxdc1e388c3822c80b", qqID: "1105821097", weiboID: "2045436852")
        return true
    }
    
    @available (iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return YLAuthManager.manager.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return YLAuthManager.manager.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

