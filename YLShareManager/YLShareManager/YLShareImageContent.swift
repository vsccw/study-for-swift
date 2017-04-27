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
            var photos = [FBSDKSharePhoto]()
            for image in images {
                let photo = FBSDKSharePhoto()
                photo.image = image
                photos.append(photo)
            }
            
            let photoContent = FBSDKSharePhotoContent()
            photoContent.photos = photos
            
            let dialog = FBSDKShareDialog()
            dialog.fromViewController = vc
            dialog.delegate = YLShareManager.manager
            dialog.shareContent = photoContent
            dialog.mode = .native
            if dialog.canShow() {
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
            if let image = images.first {
                let mediaMsg = WXMediaMessage()
                mediaMsg.thumbData = UIImageJPEGRepresentation(image, 0.1)
                
                let imageObj = WXImageObject()
                imageObj.imageData = UIImageJPEGRepresentation(image, 1.0)
                mediaMsg.mediaObject = imageObj
                
                let req = SendMessageToWXReq()
                req.bText = false
                req.message = mediaMsg
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
    }
}
