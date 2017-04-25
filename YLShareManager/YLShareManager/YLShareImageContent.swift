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

class YLShareImageContent: YLShareContent {
    
    var images: [UIImage] = []
    
    convenience init(images: [UIImage]) {
        self.init()
        self.images = images
    }
    
    override func show(_ platform: YLSharePlatformType, in vc: UIViewController, success: Success?, fail: Fail?) {
        super.show(platform, in: vc, success: success, fail: fail)
        
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
            dialog.mode = .automatic
            if dialog.canShow() {
                dialog.show()
            }
            else {
                dialog.mode = .browser
                if dialog.canShow() {
                    dialog.show()
                }
                else {
                    dialog.mode = .feedWeb
                    if dialog.canShow() {
                        dialog.show()
                    }
                }
            }
        }
        else if platform == .line {
            if let image = images.first {
                YLLineKit.sendImageMessage(image: image)
            }
        }
        else if platform == .weixinChat || platform == .weixinTimeline {
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
                else if platform == .weixinChat {
                    req.scene = Int32(WXSceneSession.rawValue)
                }
                WXApi.send(req)
            }
        }
    }
}
