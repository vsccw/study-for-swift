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
            if dialog.canShow() {
                dialog.show()
            }
            else {
                fail?(YLShareError(description: "Counld not show.", code: YLShareErrorType.unknown))
            }
        }
        else if platform == .weixinTimeline || platform == .weixinChat {
            let mediaMsg = WXMediaMessage()
            mediaMsg.title = title
            mediaMsg.description = desc
            if let imageStr = thumbImage as? String {
                if let url = URL.init(string: imageStr) {
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
            if platform == .weixinChat {
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
                YLLineKit.sendMessage(message: urlStr)
            }
        }
    }
}
