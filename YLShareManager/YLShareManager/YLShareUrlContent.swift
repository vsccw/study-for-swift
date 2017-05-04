//
//  YLShareUrlContent.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FBSDKShareKit
import YLLineKit
import Social

class YLShareUrlContent: YLShareContent {
    
    var urlStr: String = ""
    /// for facebook
    var quote: String?
    var title: String?
    var desc: String?
    var thumbImage: Any?
    
    convenience init(urlStr: String, quote: String?, title: String?, desc: String?, thumbImage image: Any?) {
        self.init()
        self.urlStr = urlStr
        self.quote = quote
        self.title = title
        self.desc = desc
        self.thumbImage = image
    }
    
    internal override func showShareView(_ platform: YLSharePlatformType, in vc: UIViewController, success: Success?, fail: Fail?) {
        super.showShareView(platform, in: vc, success: success, fail: fail)

        if platform == .facebook {
            let dialog = FBSDKShareDialog.urlDialog(content: self, in: vc, delegate: YLShareManager.manager)
            if dialog.canShow() && YLShareManager.manager.isFacebookInstalled {
                dialog.show()
            }
            else {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let composeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    composeVC?.view.tintColor = UIColor.black
                    
                    if let url = URL(string: urlStr) {
                        composeVC?.add(url)
                    }
                    
                    var initialText = ""
                    if let _title = title {
                        initialText += "[\(_title)]"
                    }
                    if let _desc = desc {
                        initialText += " \(_desc)"
                    }
                    composeVC?.setInitialText(initialText)

                    vc.present(composeVC!, animated: true, completion: nil)
                }
                else {
                    fail?(YLShareError(description: "Counld not show.", codeType: .unknown))
                }
            }
        }
        else if platform == .weixinTimeline || platform == .weixinSession {
            if !YLShareManager.manager.isWeixinInstalled {
                fail?(YLShareError(description: "app not installed", codeType: .uninstalled))
                return
            }
            let req = SendMessageToWXReq.urlMessage(content: self)
            if platform == .weixinSession {
                req.scene = Int32(WXSceneSession.rawValue)
            }
            else if platform == .weixinTimeline {
                req.scene = Int32(WXSceneTimeline.rawValue)
            }
            if !WXApi.send(req) {
                fail?(YLShareError(description: "counld not share.", codeType: .unknown))
            }
        }
        else if platform == .line {
            if let title = title {
                let message = urlStr + "\n\(title)"
                YLLineKit.sendMessage(message: message)
            }
            else {
                if YLShareManager.manager.isLineInstalled {
                    YLLineKit.sendMessage(message: urlStr)
                }
                else {
                    fail?(YLShareError(description: "app not installed", codeType: .uninstalled))
                }
            }
        }
        else if platform == .qqZone {
            let req = SendMessageToQQReq.urlMessageToQQZone(content: self)
            let statusCode = QQApiInterface.send(req)
            YLShareManager.manager.handleQQStatusCode(statusCode: statusCode)
        }
        else if platform == .qqSession {
            let req = SendMessageToQQReq.urlMessageToQQZone(content: self)
            let statusCode = QQApiInterface.send(req)
            YLShareManager.manager.handleQQStatusCode(statusCode: statusCode)
        }
    }
}
