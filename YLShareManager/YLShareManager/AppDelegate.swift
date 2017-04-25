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
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        WXApi.registerApp("wx149df8a39458c4d4", enableMTA: false)
        return true
    }
    
    @available (iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            sourceApp == "com.tencent.xin" {
            return WXApi.handleOpen(url, delegate: YLShareManager.manager)
        }
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handledOpen = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handledOpen
    }
}

