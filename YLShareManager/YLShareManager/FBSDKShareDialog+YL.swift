//
//  FBSDKShareDialog+YL.swift
//  YLShareManager
//
//  Created by vsccw on 2017/5/3.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import FBSDKShareKit

extension FBSDKShareDialog {
    static func urlDialog(content: YLShareUrlContent, in vc: UIViewController, delegate: FBSDKSharingDelegate) -> FBSDKShareDialog {
        let urlContent = FBSDKShareLinkContent()
        urlContent.contentURL = URL(string: content.urlStr)
        urlContent.quote = content.quote
        urlContent.contentTitle = content.title
        urlContent.contentDescription = content.desc
        
        if let thumbImageUrlStr = content.thumbImage as? String,
            let thumbImageUrl = URL(string: thumbImageUrlStr) {
            urlContent.imageURL = thumbImageUrl
        }
        
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = vc
        dialog.delegate = delegate
        dialog.shareContent = urlContent
        dialog.mode = .native
        return dialog
    }
    
    static func imageDialog(content: YLShareImageContent, in vc: UIViewController, delegate: FBSDKSharingDelegate) -> FBSDKShareDialog {
        var photos = [FBSDKSharePhoto]()
        for image in content.images {
            let photo = FBSDKSharePhoto()
            photo.image = image
            photos.append(photo)
        }
        
        let photoContent = FBSDKSharePhotoContent()
        photoContent.photos = photos
        
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = vc
        dialog.delegate = delegate
        dialog.shareContent = photoContent
        dialog.mode = .native
        return dialog
    }
}
