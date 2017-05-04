//
//  QQSendMessageToReq+YL.swift
//  YLShareManager
//
//  Created by vsccw on 2017/5/3.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//


extension SendMessageToQQReq {
    static func imageMessageToQQ(content: YLShareImageContent) -> SendMessageToQQReq? {
        if let image = content.images.first {
            let obj = QQApiImageObject(data: UIImageJPEGRepresentation(image, 1.0), previewImageData: nil, title: nil, description: nil)
            obj?.shareDestType = ShareDestTypeQQ
            return SendMessageToQQReq(content: obj)
        }
        else {
            return nil
        }
    }
    
    static func urlMessageToQQ(content: YLShareUrlContent) -> SendMessageToQQReq? {
        if let url = URL(string: content.urlStr) {
            let obj = QQApiURLObject(url: url, title: content.title, description: content.desc, previewImageData: nil, targetContentType: QQApiURLTargetTypeVideo)
            
            if let _thumbData = content.thumbImage as? Data {
                obj?.previewImageData = _thumbData
            }
            else if let _thumbImage = content.thumbImage as? UIImage,
                let data = UIImageJPEGRepresentation(_thumbImage, 0.5) {
                obj?.previewImageData = data
            }
            else if let _thumbUrl = content.thumbImage as? String,
                let url = URL(string: _thumbUrl) {
                obj?.previewImageURL = url
            }
            obj?.shareDestType = ShareDestTypeQQ
            return SendMessageToQQReq(content: obj)
        }
        else {
            return nil
        }
    }
    
    static func imageMessageToQQZone(content: YLShareImageContent) -> SendMessageToQQReq {
        let obj = QQApiImageArrayForQZoneObject(imageArrayData: content.images, title: nil)
        obj?.shareDestType = ShareDestTypeQQ
        return SendMessageToQQReq(content: obj)
    }
    
    static func urlMessageToQQZone(content: YLShareUrlContent) -> SendMessageToQQReq?  {
        if let url = URL(string: content.urlStr) {
            let obj = QQApiNewsObject(url: url, title: content.title, description: content.desc, previewImageData: nil, targetContentType: QQApiURLTargetTypeNews)
           
            if let _thumbData = content.thumbImage as? Data {
                obj?.previewImageData = _thumbData
            }
            else if let _thumbImage = content.thumbImage as? UIImage,
                let data = UIImageJPEGRepresentation(_thumbImage, 0.5) {
                obj?.previewImageData = data
            }
            else if let _thumbUrl = content.thumbImage as? String,
                let url = URL(string: _thumbUrl) {
                obj?.previewImageURL = url
            }
            obj?.shareDestType = ShareDestTypeQQ
            return SendMessageToQQReq(content: obj)
        }
        else {
            return nil
        }
    }
}
