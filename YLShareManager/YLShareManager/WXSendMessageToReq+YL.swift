//
//  WXSendMessageToReq+YL.swift
//  YLShareManager
//
//  Created by vsccw on 2017/5/3.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

extension SendMessageToWXReq {
    static func imageMessage(content: YLShareImageContent) -> SendMessageToWXReq? {
        if let image = content.images.first {
            let mediaMsg = WXMediaMessage()
            mediaMsg.thumbData = UIImageJPEGRepresentation(image, 0.1)
            
            let imageObj = WXImageObject()
            imageObj.imageData = UIImageJPEGRepresentation(image, 1.0)
            mediaMsg.mediaObject = imageObj
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = mediaMsg
            return req
        }
        else {
            return nil
        }
    }
    
    static func urlMessage(content: YLShareUrlContent) -> SendMessageToWXReq {
        let mediaMsg = WXMediaMessage()
        mediaMsg.title = content.title
        mediaMsg.description = content.desc
        if let imageStr = content.thumbImage as? String {
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
        else if let imageData = content.thumbImage as? Data {
            mediaMsg.thumbData = imageData
        }
        else if let image = content.thumbImage as? UIImage {
            mediaMsg.setThumbImage(image)
        }
        
        let webpageObj = WXWebpageObject()
        webpageObj.webpageUrl = content.urlStr
        mediaMsg.mediaObject = webpageObj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMsg
        return req
    }
}
