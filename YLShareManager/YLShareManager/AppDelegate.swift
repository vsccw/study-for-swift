//
//  AppDelegate.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        YLShareManager.manager.application(application, didFinishLaunchingWithOptions: launchOptions)
//        YLShareManager.manager.register(weixinID: "wx149df8a39458c4d4")
        YLShareManager.manager.register(weixinID: "wx149df8a39458c4d4", qqID: "1105821097", weiboID: "")
        return true
    }
    
    @available (iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return YLShareManager.manager.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return YLShareManager.manager.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

