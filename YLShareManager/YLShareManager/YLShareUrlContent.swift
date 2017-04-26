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
    
    override func show(_ platform: YLSharePlatformType, in vc: UIViewController, success: Success?, fail: Fail?) {
        super.show(platform, in: vc, success: success, fail: fail)

        if platform == .facebook {
            let urlContent = FBSDKShareLinkContent()
            urlContent.contentURL = URL(string: urlStr)
            urlContent.quote = quote
            urlContent.contentTitle = title
            urlContent.contentDescription = desc
            
            if let thumbImageUrlStr = self.thumbImage as? String,
                let thumbImageUrl = URL(string: thumbImageUrlStr) {
                urlContent.imageURL = thumbImageUrl
            }
            
            let dialog = FBSDKShareDialog()
            dialog.fromViewController = vc
            dialog.delegate = YLShareManager.manager
            dialog.shareContent = urlContent
            dialog.mode = .native
            if dialog.canShow() {
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
            let mediaMsg = WXMediaMessage()
            mediaMsg.title = title
            mediaMsg.description = desc
            if let imageStr = thumbImage as? String {
                if let url = URL(string: imageStr) {
                    do {
                        let data = try Data(contentsOf: url)
                        mediaMsg.thumbData = data
                    }
                    catch let err {
                        print(err)
                    }
                }
            }
            else if let imageData = thumbImage as? Data {
                mediaMsg.thumbData = imageData
            }
            else if let image = thumbImage as? UIImage {
                mediaMsg.setThumbImage(image)
            }
            
            let webpageObj = WXWebpageObject()
            webpageObj.webpageUrl = urlStr
            mediaMsg.mediaObject = webpageObj
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = mediaMsg
            if platform == .weixinSession {
                req.scene = Int32(WXSceneSession.rawValue)
            }
            else if platform == .weixinTimeline {
                req.scene = Int32(WXSceneTimeline.rawValue)
            }
            WXApi.send(req)
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
    }
}
