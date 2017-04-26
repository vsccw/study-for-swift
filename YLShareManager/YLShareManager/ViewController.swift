//
//  ViewController.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import YLLineKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginWithFacebookButton = FBSDKLoginButton()
        loginWithFacebookButton.setTitle("使用facebook登录", for: .normal)
        loginWithFacebookButton.sizeToFit()
        loginWithFacebookButton.center = CGPoint(x: view.center.x, y: view.center.y - 200)
        view.addSubview(loginWithFacebookButton)
        loginWithFacebookButton.addTarget(self, action: #selector(loginWithFacebookButtonButtonClicked), for: .touchUpInside)
        
        loginWithFacebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginWithFacebookButton.delegate = self
        
        let shareImageLineButton = UIButton(type: .system)
        shareImageLineButton.setTitle("分享图片到line", for: .normal)
        shareImageLineButton.sizeToFit()
        shareImageLineButton.center = CGPoint(x: view.center.x, y: view.center.y - 160)
        view.addSubview(shareImageLineButton)
        shareImageLineButton.addTarget(self, action: #selector(shareImageLineButtonClicked), for: .touchUpInside)
        
        let shareTextLineButton = UIButton(type: .system)
        shareTextLineButton.setTitle("分享文字到line", for: .normal)
        shareTextLineButton.sizeToFit()
        shareTextLineButton.center = CGPoint.init(x: view.center.x, y: view.center.y - 120)
        view.addSubview(shareTextLineButton)
        shareTextLineButton.addTarget(self, action: #selector(shareTextLineButtonClicked), for: .touchUpInside)
        
        let button = UIButton(type: .system)
        button.setTitle("分享链接到fb", for: .normal)
        button.sizeToFit()
        button.center = view.center
        view.addSubview(button)
        button.addTarget(self, action: #selector(showShareView), for: .touchUpInside)
        
        let installedFBButton = UIButton(type: .system)
        installedFBButton.setTitle("是否安装了facebook", for: .normal)
        installedFBButton.sizeToFit()
        installedFBButton.center = CGPoint.init(x: view.center.x, y: view.center.y - 80)
        view.addSubview(installedFBButton)
        installedFBButton.addTarget(self, action: #selector(installedFBButtonClicked), for: .touchUpInside)
        
        let installedButton = UIButton(type: .system)
        installedButton.setTitle("是否安装了Line", for: .normal)
        installedButton.sizeToFit()
        installedButton.center = CGPoint.init(x: view.center.x, y: view.center.y - 40)
        view.addSubview(installedButton)
        installedButton.addTarget(self, action: #selector(isInstalledLine), for: .touchUpInside)
        
        let shareImageFacebookButton = UIButton(type: .system)
        shareImageFacebookButton.setTitle("分享image到fb", for: .normal)
        shareImageFacebookButton.sizeToFit()
        shareImageFacebookButton.center = CGPoint.init(x: view.center.x, y: view.center.y + 40)
        view.addSubview(shareImageFacebookButton)
        shareImageFacebookButton.addTarget(self, action: #selector(shareImageFacebookButtonClicked), for: .touchUpInside)
        
        let shareImageWeixinChatButton = UIButton(type: .system)
        shareImageWeixinChatButton.setTitle("分享image到weixin chat", for: .normal)
        shareImageWeixinChatButton.sizeToFit()
        shareImageWeixinChatButton.center = CGPoint.init(x: view.center.x, y: view.center.y + 80)
        view.addSubview(shareImageWeixinChatButton)
        shareImageWeixinChatButton.addTarget(self, action: #selector(shareImageWeixinChatButtonClicked), for: .touchUpInside)
        
        let shareUrlWeixinChatButton = UIButton(type: .system)
        shareUrlWeixinChatButton.setTitle("分享url到weixin chat", for: .normal)
        shareUrlWeixinChatButton.sizeToFit()
        shareUrlWeixinChatButton.center = CGPoint.init(x: view.center.x, y: view.center.y + 120)
        view.addSubview(shareUrlWeixinChatButton)
        shareUrlWeixinChatButton.addTarget(self, action: #selector(shareUrlWeixinChatButtonClicked), for: .touchUpInside)
    }
    
    func showShareView() {
        let urlContent = YLShareUrlContent.init(urlStr: "https://vsccw.com", quote: "测试测试", title: "标题标题", desc: "描述描述", thumbImage: "https://docs-assets.developer.apple.com/published/e0791617a4/14f9f16e-55c0-474a-ae62-f42ebf2cab33.png")
        urlContent.show(YLSharePlatformType.facebook, in: self, success: { (result) in
            
        }) { (error) in
            print(error)
        }
    }
    
    func isInstalledLine() {
        
        UIAlertController.alert(with: "\(YLLineKit.isLineInstalled)", withAction: "Sure", in: self)
    }
    
    func installedFBButtonClicked() {
        UIAlertController.alert(with: "\(YLShareManager.manager.isFacebookInstalled)", withAction: "Sure", in: self)
    }
    
    func shareImageFacebookButtonClicked() {
        let imageContent = YLShareImageContent(images: [UIImage(named: "123")!,UIImage(named: "123")!])
        imageContent.show(.facebook, in: self, success: { (results) in
            print(results)
        }) { (error) in
            if let err = error as? YLShareError {
                if err.codeType == YLShareErrorCodeType.versionUnsupport {
                    print("版本不匹配")
                    return
                }
            }
            print(error)
        }
    }
    
    func shareImageWeixinChatButtonClicked() {
        let imageContent = YLShareImageContent(images: [UIImage(named: "123")!])
        imageContent.show(.weixinSession, in: self, success: { (result) in
            
        }) { (error) in
            print(error)
        }
    }
    
    func shareUrlWeixinChatButtonClicked() {
        let urlContent = YLShareUrlContent.init(urlStr: "https://vsccw.com", quote: "测试测试", title: "标题标题", desc: "描述描述", thumbImage: UIImage(named: "123"))
        urlContent.show(.weixinSession, in: self, success: { (result) in
            
        }) { (error) in
            print(error)
        }
    }
    
    func shareTextLineButtonClicked() {
        let urlContent = YLShareUrlContent.init(urlStr: "https://vsccw.com", quote: "测试测试", title: "标题标题", desc: "描述描述", thumbImage: UIImage(named: "123"))
        urlContent.show(YLSharePlatformType.line, in: self, success: { (result) in
            
        }) { (error) in
            print(error)
        }
    }
    
    func shareImageLineButtonClicked() {
        let imageContent = YLShareImageContent(images: [UIImage(named: "123")!])
        imageContent.show(.line, in: self, success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    func loginWithFacebookButtonButtonClicked() {
        
    }
    
    // "https://docs-assets.developer.apple.com/published/e0791617a4/14f9f16e-55c0-474a-ae62-f42ebf2cab33.png"
}

extension ViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let token = result.token.tokenString {
            print(token)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

extension UIAlertController {
    static func alert(with title: String, withAction actionTitle: String, in vc: UIViewController) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: actionTitle, style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
