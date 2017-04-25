//
//  ViewController.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import YLLineKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        print(YLLineKit.isLineInstalled)
    }
    
    func installedFBButtonClicked() {
        print(YLShareManager.manager.isFacebookInstalled)
    }
    
    func shareImageFacebookButtonClicked() {
        let imageContent = YLShareImageContent(images: [UIImage(named: "123")!])
        imageContent.show(.facebook, in: self, success: { (results) in
            print(results)
        }) { (error) in
            print(error)
        }
    }
    
    func shareImageWeixinChatButtonClicked() {
        let imageContent = YLShareImageContent(images: [UIImage(named: "123")!])
        imageContent.show(.weixinChat, in: self, success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    func shareUrlWeixinChatButtonClicked() {
        let urlContent = YLShareUrlContent.init(urlStr: "https://vsccw.com", quote: "测试测试", title: "标题标题", desc: "描述描述", thumbImage: UIImage(named: "123"))
        urlContent.show(YLSharePlatformType.weixinChat, in: self, success: { (result) in
            
        }) { (error) in
            print(error)
        }
    }
    // "https://docs-assets.developer.apple.com/published/e0791617a4/14f9f16e-55c0-474a-ae62-f42ebf2cab33.png"
}

