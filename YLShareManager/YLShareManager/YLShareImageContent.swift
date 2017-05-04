//
//  YLShareImageContent.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FBSDKShareKit
import YLLineKit
import Social

class YLShareImageContent: YLShareContent {
    
    var images: [UIImage] = []
    
    convenience init(images: [UIImage]) {
        self.init()
        self.images = images
    }
    
    /// **注意** 分享图片到Facebook时只支持在应用内分享和使用自带分享模式，其他会报错
    internal override func showShareView(_ platform: YLSharePlatformType, in vc: UIViewController, success: Success?, fail: Fail?) {
        super.showShareView(platform, in: vc, success: success, fail: fail)
        
        if platform == .facebook {
            let dialog = FBSDKShareDialog.imageDialog(content: self, in: vc, delegate: YLShareManager.manager)
            if dialog.canShow() && YLShareManager.manager.isFacebookInstalled {
                dialog.show()
            }
            else {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let composeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    composeVC?.view.tintColor = UIColor.black
                    for image in images {
                        composeVC?.add(image)
                    }
                    vc.present(composeVC!, animated: true, completion: nil)
                }
                else {
                    fail?(YLShareError(description: "counld not show.", codeType: .unknown))
                }
            }
        }
        else if platform == .line {
            if let image = images.first {
                if YLShareManager.manager.isLineInstalled {
                    YLLineKit.sendImageMessage(image: image)
                }
                else {
                    fail?(YLShareError(description: "app not installed", codeType: .uninstalled))
                }
            }
        }
        else if platform == .weixinSession || platform == .weixinTimeline {
            if !YLShareManager.manager.isWeixinInstalled {
                fail?(YLShareError(description: "app not installed", codeType: .uninstalled))
                return
            }
            if let req = SendMessageToWXReq.imageMessage(content: self) {
                if platform == .weixinTimeline {
                    req.scene = Int32(WXSceneTimeline.rawValue)
                }
                else if platform == .weixinSession {
                    req.scene = Int32(WXSceneSession.rawValue)
                }
                if !WXApi.send(req) {
                    fail?(YLShareError(description: "counld not send weixin", codeType: .unknown))
                }
            }
        }
        else if platform == .qqSession {
            let req = SendMessageToQQReq.imageMessageToQQ(content: self)
            let statusCode = QQApiInterface.send(req)
            YLShareManager.manager.handleQQStatusCode(statusCode: statusCode)
        }
        else if platform == .qqZone {
            let req = SendMessageToQQReq.imageMessageToQQZone(content: self)
            let statusCode = QQApiInterface.send(req)
            YLShareManager.manager.handleQQStatusCode(statusCode: statusCode)
        }
    }
}
