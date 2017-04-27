//
//  ShareContent.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class YLShareContent: NSObject {
    
    let manager = YLShareManager.manager
    
    override init() {
        super.init()
    }
    
    internal func showShareView(_ platform: YLSharePlatformType, in vc: UIViewController, success: Success? = nil, fail: Fail? = nil) {
        manager.success = success
        manager.fail = fail
    }
}
