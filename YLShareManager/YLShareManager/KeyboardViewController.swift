//
//  KeyboardViewController.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController {
    
    @IBAction func loginWithQQButtonClicked(_ sender: UIButton) {
        YLShareManager.manager.loginWithQQ()
        print(YLShareManager.manager.tencentOAth?.accessToken)
        print(YLShareManager.manager.tencentOAth?.openId)
        YLShareManager.manager.loginSuccess = { result in
            print(result)
        }
    }
    
    @IBAction func loginWithWXButtonClicked(_ sender: UIButton) {
        YLShareManager.manager.loginWithWeChat()
        YLShareManager.manager.loginSuccess = { result in
            print(result)
        }
    }
    
    @IBAction func loginWithWBButtonClicked(_ sender: UIButton) {
        YLShareManager.manager.loginWithWeibo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}
